---
layout: post
title: Writing A TCP Client In Go
published: true
---

In a [previous post]({% post_url 2019-07-23-golang-concurrent-tcp-server %}), I wrote about building a concurrent TCP server in Go. To talk to a server like that, you'd normally reach for `nc` (netcat). Unfortunately, netcat isn't native to Windows, and it might not be available in lightweight containers either.

So in this post we'll write our own TCP client, one that compiles to Windows, macOS, Linux, and anything else Go supports.

## The simple client

The code is explained with comments inline:

```go
package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
	"os"
)

func main() {
	// ip and port of the TCP server from the previous post
	ip := "127.0.0.1"
	port := "8080"

	// join ip and port into "127.0.0.1:8080"
	// JoinHostPort also adds the brackets that IPv6 addresses need
	addr := net.JoinHostPort(ip, port)

	// dial into the TCP server and have access to the connection via `conn`
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	// print everything the server sends, as soon as it arrives
	// this runs in its own goroutine so it never waits on us typing
	go func() {
		io.Copy(os.Stdout, conn)

		// io.Copy only returns once the server closes the connection
		fmt.Println("server closed the connection")
		os.Exit(0)
	}()

	// set up a reader for stdin to read inputs from the shell
	// create it once, outside the loop, so no buffered input gets lost
	reader := bufio.NewReader(os.Stdin)

	// block main() and keep sending lines until stdin closes
	for {
		// grab all text up to and including the newline from hitting enter
		text, err := reader.ReadString('\n')
		if err != nil {
			// io.EOF means stdin closed (Ctrl-D, or the end of piped input)
			return
		}

		// send the line to the server, newline included
		fmt.Fprint(conn, text)
	}
}
```

Two things happen at once here. A goroutine prints whatever the server sends as soon as it arrives, while the main loop sends every line you type. Neither one waits on the other, so it doesn't matter how many lines the server sends back, or when. That's exactly how netcat behaves too.

Great! Now you have a simple client that does most of what we use netcat for anyways.

One Windows gotcha: lines typed into a Windows terminal end in `\r\n` instead of just `\n`. If Windows clients will be talking to your server, trim that `\r` on the server side (`strings.TrimSpace` works well), or it ends up in your messages.

## Truly multi-platform

Hard-coding the IP and port isn't great, and passing in environment variables works differently on every OS. On Windows it can be a real pain. So let's use the `flag` parser built into Go's standard library instead.

I've only added comments where there's new functionality:

```go
package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"os"
)

func main() {
	var ip string
	// make a CLI flag for the IP address
	// go run main.go -ip=10.0.0.42
	// default is "127.0.0.1"
	flag.StringVar(&ip, "ip", "127.0.0.1", "IP address of the TCP server")

	var port string
	// make a CLI flag for the port
	// go run main.go -port=9000
	// default is "8080"
	flag.StringVar(&port, "port", "8080", "port of the TCP server")

	// full custom use of both ip and port: go run main.go -ip=10.0.0.42 -port=9000
	flag.Parse()

	addr := net.JoinHostPort(ip, port)

	conn, err := net.Dial("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	go func() {
		io.Copy(os.Stdout, conn)

		fmt.Println("server closed the connection")
		os.Exit(0)
	}()

	reader := bufio.NewReader(os.Stdin)

	for {
		text, err := reader.ReadString('\n')
		if err != nil {
			return
		}

		fmt.Fprint(conn, text)
	}
}
```

Now you have a nice CLI, and `flag` even writes the help text for you:

```
$ go build -o client main.go
$ ./client -h
Usage of ./client:
  -ip string
    	IP address of the TCP server (default "127.0.0.1")
  -port string
    	port of the TCP server (default "8080")
```

So without having to think about how to make a nice output block, the `flag` package has got your back.

## Conclusion

Hope you learned how to use `flag`, as well as how to make a cross-platform TCP client. It works anywhere you have Go, or if you cross-compile the binary, anywhere you please!
