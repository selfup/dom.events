---
layout: post
title: "Micro: Task async stream in elixir"
---

# Task async stream in elixir

Ok so for a while now I have been using `Task.async/1` and `Task.await/1` with piped `Enum.map`(s) to get some concurrent work done.

_Imagine `api_call/1` exists and makes an HTTP request somewhere_

```elixir
0..20
|> Enum.map(fn idx ->
  Task.async(fn -> api_call(idx) end)
end)
|> Enum.map(fn task -> Task.await(task) end)
|> IO.inspect
```

However **TIL** about `Task.async_stream/3`!

You can go read about it here: [Task.async_stream/3](https://hexdocs.pm/elixir/Task.html#async_stream/3)

Runs through your enum in chunks (equal to the number of logical cores on your machine) to execute the tasks as fast as possible! :rocket:

By default the maximum number of tasks to run at the same time will equal the result of `System.schedulers_online`.

Here it is being used in comparison to the earlier snippet:

```elixir
0..20
|> Task.async_stream(fn idx -> api_call(idx) end)
|> Enum.map(fn {:ok, result} -> result end)
|> IO.inspect
```

Much better! :tada:

Reminds me of `par_iter` in the [Rayon](https://crates.io/crates/rayon) Rust crate: [par_iter](https://docs.rs/rayon/0.6.0/rayon/par_iter/index.html)

Not only is it a win in performance, but also a win in code clarity and cleanliness :smile:
