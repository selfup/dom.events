---
layout: post
title:  'Micro: Neat command line tool called entr'
---

# Neat tool called entr

*TIL* about a command line util called `entr` :tada:

Website: [entrproject](http://eradman.com/entrproject/)

_mac_: `brew install entr`

_ubuntu_: `sudo apt install entr`

#### Purpose

This will watch any filename you pipe into entr. Then it can run any script you pass it with `-s` or just completely reload a process (ctrl - c and start again) using the `-r` flag.

Perfect for scripting or spiking parsing weird payloads :rocket:

#### Usage

Example scripts:

`ls *.rb | entr -r ruby main.rb`

`echo 'script.js' | entr -r node script.js`

```bash
echo 'main.go' | entr -sr \
  'docker stop $(docker ps -aq) && docker-compose up --build'
```

So useful!

#### Repo with a bunch of langs

I made a repo so I could script in a bunch of different languages with watch scripts for each one!

Check it out: [dev.random](https://github.com/selfup/dev.random)
