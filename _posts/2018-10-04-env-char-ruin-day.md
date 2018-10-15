---
layout: post
title: How a character in my .env ruined my day
---

# How a character in my .env ruined my day

After having worked on a branch for 2 weeks we were ready to push.

We added some tokens for a new api and were ready to go.

We start a live screen shared demo, but the endpoints that used to work no longer worked.

### What we tried

We tried getting a new lease with the router and getting a new IP address.

Restarting and changing ethernet ports.

Changing hostname and rebooting with yet another port plugged in.

### Conclusion

A Slack copy paste gone wrong.

We changed the .env from scratch and everything was good to go again.

Make sure to always use code blocks when sharing configs!
