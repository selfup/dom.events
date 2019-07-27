---
layout: post
title: Writing Scripts In Go Instead Of Bash Or Ruby
published: true
---

# Writing Scripts In Go Instead Of Bash Or Ruby

As I have been writing more Go lately, I have found myself using Go as a scripting language more and more.

Replacing old bash or ruby scripts in Go has given me some really nice advantages.

_Multi platform binaries._

You can compile Go bins to any platform of choice where you would otherwise develop software or automate some tasks.

Go is very easy to install on Linux/macOS/Windows and I, for ADHD and technical reasons, use all three platforms.

1. Linux when I have some heavy orchestration of an infrastructure using docker since no VM is needed
1. Mac when I am at work or when I want a really smooth UI
1. Windows when I am playing video games and have an idea pop in my head

_Why Go?_

1. Ruby on Windows is not fun.
1. Bash on Windows is a crapshoot.

Between all OSs, having to pick between WSL/Git Bash/MinGW/Bash/Zsh/etc.. can be confusing.

This isn't just for me either. Others might be running shells that don't support `&&` or all they have is `powershell`.

I typically like to use native shells, so I needed something akin to docker for scripting.

## Enter Go

All of a sudden you can write an easily installable language, that has excellent support in VSCode.

The built in `flag` lib makes for some neat self documenting CLIs.

Is it a bit more verbose? Sure. Does it run faster? Sure. Is it more convenient when swapping environments? Absolutely!

## Elegant

Something about the zen of Go, and the plethora of built in std lib features like http/os/flag/sync/goroutines/etc.. make it really easy to convert common bash scripts into a staticly typed script that can be compiled and shared.

Even if you are not compiling the scripts, `go run cmd/script/main.go` is convenient and still really fast.

## Caveats

Sometimes bash is the clear winner. You want to automate a task or have a special build for an Elixir/Rails/Spring project in Docker. The image you are going to use more than likely won't have Go in it but bash will be there. Don't add friction!

Or you are writing a Jenkins/Travis/GitLab CI job and a few `curl`/`grep`/`sed` commands will do just fine.

Sometimes ruby can be simpler but you can typically always replace a ruby script with Go unless you are using some quality of life gems that would make writing something in Go a nightmare.

## Educational

Instead of just writing apis, you can finally have some fun and learn other areas of the language. It really has fantastic documentation and there is so much offered without needing external packages.

## Conclusion

I won't replace all of my scripts in Go, but this is a great way to sharpen the Go knife and make life simpler!
