---
layout: post
title: Writing A TCP Client In Go
published: false
---

# Writing A TCP Client In Go

In a previous post I wrote about writing a concurrent TCP server in go.

However one thing that is unfortunate is that `nc` or `netcat` is not native to Windows, and might also not be avaible on lightweight containers.

So in this post we will talk about writing a TCP client that can be compiled to windows/darwin/linux/etc..

### The simple client

All code will be explained using comments in the code block

```go
package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
)

func main() {
  // ip and port of TCP server
  ip := "127.0.0.1"
	port := "8081"

  // format ip and port
	addr := ip + ":" + port

  // dial into the tcp server and have access to the connection via `conn`
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}

  // block main() and set up a reader for stdin to read inputs from the shell
	for {
		reader := bufio.NewReader(os.Stdin)

    // grab all text prior to hitting enter
		text, err := reader.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}

    // send over payload to the connection
		fmt.Fprintf(conn, text+"\n")

    // read the response from the server
    // if you modified your server to not send a response you can omit everything below
		message, err := bufio.NewReader(conn).ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}

		fmt.Print(message)
	}
}
```

Great! Now you have a simple client that does mostly what we use netcat for anyways.

If your TCP server is being interacted with from a windows client you will have to add some logic to check for `\r\n` instead of just `\n`.

### Truly multi platform

Setting ENVs on Windows can also be a pain so here we will add usage of the `flag` parser built into the Go std lib.

I have only added comments where we add new functionality:

```go
package main

import (
  "bufio"
  "flag"
	"fmt"
	"log"
	"net"
	"os"
)

func main() {
  var ip string
  // make a CLI flag for the IP address
  // go run main.go -ip=10.0.0.42
  // default is "127.0.0.1"
  flag.StringVar(&ip, "ip", "127.0.0.1", "ip addr of TCP server")

  var port string
  // make a CLI flag for the IP address
  // go run main.go -port=9000
  // default is "8081"
  flag.StringVar(&port, "port", "8081", "port of TCP server")

  // full custom use of both ip and port: go run main.go -ip=10.0.0.42 -port=9000
  flag.Parse()

	addr := ip + ":" + port

	conn, err := net.Dial("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}

	for {
		reader := bufio.NewReader(os.Stdin)

		text, err := reader.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}

		fmt.Fprintf(conn, text+"\n")

		message, err := bufio.NewReader(conn).ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}

		fmt.Print(message)
	}
}
```

So now you can have a nice CLI interface. You can also ask for "help" by doing:

```bash
go run main.go -h
  -ip string
        ip addr of TCP server (default "127.0.0.1")
  -port string
        port of TCP server) (default "8081")
```

So without having to think about how to make a nice output block, the `flag` lib has got your back.

## Conclusion

Hope you learned how to use `flag` as well as how to make a crossplatform TCP client that will work anywhere you have Go, or if you cross compile your binary, anywhere you please!
