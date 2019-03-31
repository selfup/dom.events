---
layout: post
title:  'Micro: Output terminal colors in Elixir'
---

# Output terminal colors

So if you are ever in the mood to write a CLI or make your logs look real nice, Elixir has a native `IO.ANSI` module that has a bunch of nice methods!

Here is a list of methods:

```ocaml
Erlang/OTP 21 [erts-10.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]

Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> IO.ANSI.
Docs                          Sequence
black/0                       black_background/0
blink_off/0                   blink_rapid/0
blink_slow/0                  blue/0
blue_background/0             bright/0
clear/0                       clear_line/0
color/1                       color/3
color_background/1            color_background/3
conceal/0                     crossed_out/0
cursor/2                      cursor_down/0
cursor_down/1                 cursor_left/0
cursor_left/1                 cursor_right/0
cursor_right/1                cursor_up/0
cursor_up/1                   cyan/0
cyan_background/0             default_background/0
default_color/0               enabled?/0
encircled/0                   faint/0
font_1/0                      font_2/0
font_3/0                      font_4/0
font_5/0                      font_6/0
font_7/0                      font_8/0
font_9/0                      format/1
format/2                      format_fragment/1
format_fragment/2             framed/0
green/0                       green_background/0
home/0                        inverse/0
inverse_off/0                 italic/0
light_black/0                 light_black_background/0
light_blue/0                  light_blue_background/0
light_cyan/0                  light_cyan_background/0
light_green/0                 light_green_background/0
light_magenta/0               light_magenta_background/0
light_red/0                   light_red_background/0
light_white/0                 light_white_background/0
light_yellow/0                light_yellow_background/0
magenta/0                     magenta_background/0
no_underline/0                normal/0
not_framed_encircled/0        not_italic/0
not_overlined/0               overlined/0
primary_font/0                red/0
red_background/0              reset/0
reverse/0                     reverse_off/0
underline/0                   white/0
white_background/0            yellow/0
yellow_background/0
iex(1)> IO.ANSI.
```

Here is an example of how you can use this functionality:

```elixir
IO.ANSI.magenta <> "my purple string" |> IO.puts
```

It will look something like this:

![magenta_image](https://user-images.githubusercontent.com/9837366/55094883-3f09f380-5085-11e9-89d1-4f232e83cccc.png)

You can always write a helper module to make life a bit easier!

```elixir
defmodule Colors do
  def purple(string) do
    IO.ANSI.magenta <> string
  end

  defp print(colorized_string) do
    IO.puts(colorized_string)
  end

  def put_purple(string) do
    purple(string) |> print
  end
end

Colors.put_purple("hello world")
```

That's it!
