---
layout: post
title: 'History of text editors'
published: false
---

# History of text editors

These notes were taken from a ruby conf video!

[String Theory and Time Travel: the humble text editor by Colin Fulton](https://www.youtube.com/watch?v=zaql_NwlO18)

## Who _loves_ their text editor?

## Has anyone tried to make their own?

## Why are text editors so personal?

## Yak Shaving

Build so much stuff to understand how it works, have not expiremented with making a text editor but there is a good chance I will try to make one soon

## Curriculum

1. Time Travel

1. Philosophy of Tools

1. Build a time machine?

## IDE

Wizards, GUI, Refactoring Tutorials, Debugger, meh text editor, etc..

## THE KEY PUNCHER

You would punch holes into paper/plastic cards

Punch it in wrong, yep, new one

Don't drop cards when you have 1000's of them

## Teletype (tty)

type on keyboard

computer processes

paper prints output

## Dumb terminals

type on keyboard

computer processes

characters print out on new line

## TECO

1960s

Had it's own DSL (IF/OR/etc..)

Really complex macros were written and looked really bad

## ed

Simple af

`ed file`

prints out how many bytes

now you can type in it like a TCP client

line 42

returns what is on that line

42,44 prints out last line of range

10,9001p

returns `?`

means error :joy:

now you can just type: `h` and it will tell you the error

## sed

very commonly used in bash scripts

extremely powerful (not as cool as
`awk` though)

## Modal vs. Modeless

write vs read (mode)

##### Hand tools vs. wizards

Learning how to become a carpenter

Productivity can go up or down

vs.

Going to home depot

Productivity can go up or down

## git the ultimate hand tool

once you spend the time to learn how to use it really well, you can be the go to surgeon

however doctors go to school for a very long time..

## Remember ed?

Terrible experience.

Well then there was `ex`.

Then someone made something that would repaint the screen on every stroke. That editor was called
`vi`

Then someone improved `vi` and made
`vim`

## TECO

Remember the super macro editor?
Yea well EMACS came from Teco

## A lot of our tools were written a long time ago

Why does vim have such weird keybindings?

Well the ADM-3a wsa the most popular machine/keyboard during the time.

Build in arrows on `hjkl`

Esc was next to Q

`~` was on the Home key

## Write an Editor

#### SRP (Single Responsibility Principle)

#### Composability

#### Higher Order Abstractions

#### Static Typing / Runtime Type Checks / Documentation

1. Selection (find line, shift over words, etc..)
1. Modification (Remove parens from all selected words)
1. Editing (Delete/Cursor/Insert)
1. Delete replaces with nothing
1. Cursor selects nothing
1. Insert is just a column and row position
1. Extension and scripting language

## TICO vs Emacs

Lisp is much better than TECO macros

## EDIT HISTORY WHAT

Going back in time and edit previous states...

Giant linked list

insert -> insert -> insert -> delete -> insert

what happens when we go back in time and

`cut`? :sob:

We delete the future..

Solution? Branched history

Store a pointer to the rest of the list prior to cutting.

## The Mac

Jef Raskin:

First GUI text eiditing to consumer market

Douglas Engelbart - 1968 -> Jef Raskin

## Cannon Cat

## Rob Pike

Creator of Go (Google Golang)

Wrote an editor called `sam`

Structural Regular Expressions. Instead of basing the editor off of line, based it off of Regular Expressions to select words and then perform a command on the regex.

`plan9` wrote an OS but made unix even more powerful

First shared network drives

Then wrote `acme` another text editor!

Rob Pike/Ken Thompson/Dennis Ritchie/Brian Kernighan/Bjarne Stroustrup (creator of C++)

## Next time you build a development tool

Are you bulding a tool or a wizard?

Rails/Spring -> Wizards

Flask/Express -> hand tools
