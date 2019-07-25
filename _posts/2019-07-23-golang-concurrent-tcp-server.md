---
layout: post
title: 'Long: Golang concurrent TCP server'
---

# Golang concurrent TCP server

Today we will learn how to write a TCP server in Go that is concurrent in nature. This will enable this server to handle more than one connection. This server will also know if a client disconnects without asking the server to close the connection.

### Main

```go
package main

import (
	"log"
	"net"
)


func main() {
  listener, err := net.Listen("tcp", "127.0.0.1:8080")
	if err != nil {
		log.Fatal("tcp server listener error:", err)
  }

  for {
		conn, err := listener.Accept()
		if err != nil {
			log.Fatal("tcp server accept error", err)
		}

		go handleConnection(conn)
	}
}
```

Ok, so for now everything is quite simple. Your server listens on localhost:8080. Then you wrap all new connections in a `for {}` to keep your server alive forever.

Now you accept the client connection. An easy way to connect would be: `nc localhost 8080`

But what does `handleConnection` do? And why use a goroutine?

Great questions!

### Goroutines for handling all incoming connections

If we don't use a goroutine, we will not be able to accept another client. Otherwise the function hangs in our `for {}` block until the client leaves!

So here we just preface `handleConnection` with `go` and now we are able to handle multiple clients.

```go
func handleConnection(conn net.Conn) {
	bufferBytes, err := bufio.NewReader(conn).ReadBytes('\n')

	if err != nil {
    log.Println(clientAddr, "client left..")
    conn.Close()

    // escape recursion
		return
	}

	message := string(bufferBytes)
	clientAddr := conn.RemoteAddr().String()
  response := fmt.Sprintf(message + " from " + clientAddr + "\n")

  log.Println(response)

  conn.Write([]byte("you sent: "+response))

  // recursive func to handle io.EOF for random disconnects
  handleConnection(conn)
}
```
