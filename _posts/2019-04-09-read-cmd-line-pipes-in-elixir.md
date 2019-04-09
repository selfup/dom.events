---
layout: post
title: 'Micro: Read cmd line pipes in elixir'
---

# Read cmd line pipes in elixir

Say you want to delete all remotely merged branches with the name `feature-`.

You can use: [IO.read](https://hexdocs.pm/elixir/IO.html#read/2)

```bash
git branch | grep feature | elixir -e 'IO.read(:all) |> IO.puts'`
```

Ok so now that you know this is going to work, we can write the actual script:

```bash
git checkout -b feature-new-branch \
  && git checkout master \
  && git branch \
  | grep -v '* master' \
  | grep 'feature-' \
  | elixir -e 'IO.read(:all) |> String.trim("\n") |> fn args -> "git branch -d #{args}" end.() |> to_charlist |> :os.cmd |> IO.puts'
```

So now you can start piping your heart out!

You might notice:

```elixir
IO.read(:all) |> String.trim("\n") |> fn args -> "git branch -d #{args}" end.()
```

Anon func that takes in the pipe output and executes (think IIFE in JS).

This is the easiest workaround to not making a variable. Otherwise you would:

```elixir
i = IO.read(:all) |> String.trim("\n"); "git branch -d #{i}"
```

So now you could shrink it down to:

```elixir
i = IO.read(:all) |> String.trim("\n"); "git branch -d #{i}" |> to_charlist |> :os.cmd |> IO.puts
```

_sometimes it makes more sense to do this_

Here is the output:

```shell
Switched to a new branch 'feature-new-branch'
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
Deleted branch feature-new-branch (was a4144dd).
```

I really do enjoy using ruby to do this as well, but you end up using a ton of semi-colons (`;`) and defining really small cryptic variables.
Otherwise your "_one liner_" becomes quites long.

I am sure `awk` and `sed` can continue to be used instead, but sometimes using elixir is more fun! :tada:
