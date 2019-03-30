---
layout: post
title:  Neat tool called entr
---

# Neat tool called entr

*TIL* about a command line util called `entr` :tada:

This will watch any filename you pipe into entr. Then it can run any script you pass it with `-s` or just completely reload a process (ctrl - c and start again) using the `-r` flag.

Perfect for scripting or spiking parsing weird payloads :rocket:

http://eradman.com/entrproject/

Example scripts:

`ls *.rb | entr -r ruby main.rb`

`echo 'script.js' | entr -r node script.js`

```bash
echo 'main.go' | entr -sr \
  'docker stop $(docker ps -aq) && docker-compose up --build'
```

So useful!
