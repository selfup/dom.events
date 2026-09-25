---
layout: post
title: Writing Scripts In Go Instead Of Bash Or Ruby
published: true
---

As I've been writing more Go lately, I've found myself using it as a scripting language more and more. Replacing old Bash and Ruby scripts with Go has given me some really nice advantages.

## Why not Bash or Ruby?

For ADHD and technical reasons, I use Linux, macOS, and Windows:

- Linux when I have some heavy infrastructure orchestration with Docker, since no VM is needed
- Mac when I'm at work or want a really smooth UI
- Windows when I'm playing video games and an idea pops into my head

My scripts have to work on all three, and that's where things fall apart:

1. Ruby on Windows is not fun.
2. Bash on Windows is a crapshoot.

Across all those OSs, picking between WSL, Git Bash, MinGW, Bash, Zsh, etc. gets confusing fast.

It isn't just me either. Someone else might be running a shell that doesn't support `&&`, or all they have is PowerShell.

I like to use each platform's native shell, so I needed something that behaves the same everywhere, the way Docker does for services.

## Enter Go

Go is easy to install on Linux, macOS, and Windows, and it has excellent support in VS Code.

Better yet, whoever runs your script doesn't need Go at all. Go compiles to a single binary for any platform you choose, from whatever platform you're on:

```sh
GOOS=windows GOARCH=amd64 go build -o count.exe main.go
GOOS=linux GOARCH=amd64 go build -o count main.go
GOOS=darwin GOARCH=arm64 go build -o count main.go
```

The built-in `flag` package makes for some neat self-documenting CLIs. Here's a small script that counts files with a given extension:

```go
package main

import (
	"flag"
	"fmt"
	"io/fs"
	"log"
	"path/filepath"
)

func main() {
	dir := flag.String("dir", ".", "directory to search")
	ext := flag.String("ext", ".md", "file extension to count")
	flag.Parse()

	count := 0

	err := filepath.WalkDir(*dir, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if !d.IsDir() && filepath.Ext(path) == *ext {
			count++
		}

		return nil
	})

	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("%d %s files in %s\n", count, *ext, *dir)
}
```

Every flag comes with a default and a description, and Go turns those into help text for free:

```
$ ./count -h
Usage of ./count:
  -dir string
    	directory to search (default ".")
  -ext string
    	file extension to count (default ".md")
```

Pointed at this blog's posts, it works the same on every OS:

```
$ ./count -dir _posts
17 .md files in _posts
```

Is it more verbose than Bash? Sure. Does it run faster? Sure. Is it more convenient when swapping environments? Absolutely!

## Elegant

Something about the zen of Go makes it really easy to turn common Bash scripts into statically typed programs that can be compiled and shared. The standard library covers a lot of ground, with `net/http`, `os`, `flag`, and `sync`, and goroutines are built right into the language.

Even if you're not compiling your scripts, `go run cmd/script/main.go` is convenient and still really fast.

## Caveats

Sometimes Bash is the clear winner. Say you want to automate a task or run a special build for an Elixir, Rails, or Spring project in Docker. The image you're using more than likely won't have Go in it, but a shell will be there. Don't add friction!

Or you're writing a Jenkins, Travis, or GitLab CI job, and a few `curl`, `grep`, and `sed` commands will do just fine.

Sometimes Ruby is simpler too. You can almost always replace a Ruby script with Go, unless you're leaning on quality-of-life gems that would make writing it in Go a nightmare.

## Educational

Instead of just writing APIs, you get to have some fun and learn other areas of the language. Go has fantastic documentation, and so much comes built in without needing external packages.

## Conclusion

I won't replace all of my scripts with Go, but it's a great way to sharpen the Go knife and make life simpler!
