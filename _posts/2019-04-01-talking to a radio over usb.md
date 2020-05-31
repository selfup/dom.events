---
layout: post
title: "Talking to a radio over usb with Powershell"
---

# Talking to a radio over usb with Powershell

These days a lot of hardware has moved from RS-232 over to USB.

So one day my dad told me he wanted to have a way to click a file or a button and turn one of his ICOM radios into USB mode or to FM mode.

I made a little template file for him in Powershell, where he could just change two variables and would be ready to go!

Here is the repo: [icom-cmd](https://github.com/selfup/icom-cmd)

#### Over USB?

Yea, sooo coming from Web development this was weird. Apparently you have to send over a byte array that has hex codes in it and there is an actual API spec to follow.

With the ICOM protocol:

1. The first two bytes need to be `FE FE`.
1. To end a command the last byte needs to be `FD`.

Ok that's cool. There is a defined protocol!

My dad knew both commands, and explained how to read the API (docs for the API in the repo).

### How to test?

Mock! Mock the whole environment. So I googled around, and at least on Windows there are two neat tools for this.

My dad uses Win10 so I had to be sure to write this in something that comes standard with his machine.

RealTerm can listen to the ports (kinda like a wireshark for USB) and com0com makes a virtualized port so you can have an input and output stream instead of a single connection to the port with no way of seing what you sent.

It took a while but you end up learning about how to open a connection to the open port, and send the payload over:

```powershell
$serialPort = "COM3"
$cmdString = "FE FE 94 E0 26 00 05 00 01 FD"

$bins = New-Object System.Collections.Generic.List[System.Object]
$hexes = $cmdString.Split(' ')

foreach ($hex in $hexes) {
    [Byte] $converted = [int]"0x$hex"
    $bins.Add($converted)
}

[Byte[]] $binaries = $bins

$port = new-Object System.IO.Ports.SerialPort $serialPort, 9600, None, 8, one

$port.open()

Start-Sleep -m 100
$port.Write($binaries, 0, $binaries.Count)
Start-Sleep -m 100

$port.Close()
```

Once I was able to confirm the payload I was sending was correct, I would email the script to my dad and he would try it out.

It worked! He was now able to double click the file on his desktop and get it to work!

#### Now What?

Eventually I ended up building an exectuable in go/js that he could run that has an actual frontend and can save commands (localStorage/a file on his computer).

Golang was actually great for this. Pretty much everything in go is a byte array of some kind :joy:, so it was a great way to get comfortable with the lanugage!

Here is the repo for that project: [hmrcmd](https://github.com/selfup/hmrcmd)
