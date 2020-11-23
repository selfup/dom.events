---
layout: post
title: 'Decrease Memory Using Enums in Rust'
published: true
---

# Decrease Memory Using Enums in Rust

I am slowly building a sort of atom/universe generator/visualizer in Rust with friends. The project is called [Oxidizy](https://github.com/selfup/oxidizy).

I started this project many years ago but now that [Bevy](https://github.com/bevyengine/bevy) is an available game engine that makes ECS a breeze I decided to go back and optimize the universe generator.

The first thing was to tackle multithreaded mutations and then once that was at a reasonable state we moved on to adding more layers to the generator.

Now we are at the point where memory is starting to become an unfortunate contstraint even on a machine with 32GB of RAM (DDR4 3200MHz C16).

The program ([unigen](https://github.com/selfup/oxidizy/tree/master/crates/unigen), not the simulator) at max workload with my hardware outputs the following:

```
$ ./scripts/generate.sh 360
--------------------------------
Threads: 16
Building..
--------------------------------
Universe built!
--------------------------------
Field is Anionic
--------------------------------
Atoms: 46656000
Baryons: 11010816000
Quarks: 33032448000
--------------------------------

real    0m5.797s
user    0m0.000s
sys     0m0.031s
```

That's a lot of Quarks! 33 billion..

Before the quark optimization ([in this PR](https://github.com/selfup/oxidizy/pull/12)) we capped out at 5.6 billion.

We reduced the memory footprint 6.6 times. This runs at/around the same speed. Which is an added bonus since it increases the load on all threads now that we are increasing processing on the CPU (all logical cores). The CPU bump is more unique to our application and not a consequence of using enums. We just chose to keep the original structures to infer the enum type. More tedious but it will help when we introduce algebra.

Decreasing the memory profile by utilizing enums and additional processing improved the performance 4 times over. That's a rare outcome for sure.

### Enums

Here is a basic Enum in Rust:

```rust
#[derive(Debug, Copy, Clone)]
pub enum Apple {
    Green,
    Red,
    Yellow,
}
```

Say we grab a bunch of random `Apple`s out of a basket. You can inspect the `Apple` and see that it's either: `Apple::Green`, `Apple::Red`, or `Apple::Yellow`.

That's a pretty powerful construct. No need to store strings, or ints, or booleans, or anything really.

You can now just store imaginary words that your editor can infer and that you can also read sensibly.

That `Apple` enum is 1 byte. You can add say 20 other imaginary things to the `Apple` and it will still be 1 byte.

Something like so:

```rust
#[derive(Debug, Copy, Clone)]
pub enum Apple {
    GreenAndFresh,
    GreenAndNotFresh,
    RedAndFresh,
    RedAndNotFresh,
    YellowAndFresh,
    YellowAndNotFresh,
}
```

Now you can inspect a _single_ `Apple` enum and have it be possibly 3 different colors as well as 3 different states of freshness, but it will always be one of the 6.

This is really fun for matching, especially with tuples!

***
_Important side note:_

_If you go beyond the C style enum and start storing more complex variants your enum size will vary._

_Here is a great rundown on Stack Overflow: [Enum Size Rundown](https://stackoverflow.com/a/45463142)_

_A very useful function when optimizing: [std::mem::size_of](https://doc.rust-lang.org/std/mem/fn.size_of.html)_

***
<em></em>

Let's do something similar with a `Carrot`:

```rust
#[derive(Debug, Copy, Clone)]
pub enum Carrot {
    OrangeAndFresh,
    OrangeAndNotFresh,
    PurpleAndFresh,
    PurpleAndNotFresh,
    YellowAndFresh,
    YellowAndNotFresh,
}
```

Now you can have a basket of `Apple`s and `Carrot`s of different states.

Say you are executing a function called `inspect_an_apple_and_a_carrot`:

```rust
let my_food_basket = (Apple::RedAndFresh, Carrot::PurpleAndNotFresh);

match my_food_basket {
    (Apple::RedAndFresh, Carrot::PurpleAndNotFresh) => println!("find a fresh purple carrot"),
    (Apple::RedAndFresh, Carrot::PurpleAndFresh) => println!("go pay at checkout"),

    _ => println!("not sure what to do"),
}
```

Cool, let's go over why that saved us a ton of space.

A more traditional yet maintainable approach you would do something like:

```rust
#[derive(Debug, Copy, Clone)]
pub struct Apple {
    pub color: Color,
    pub freshness: Freshness,
}
```

Where Color/Freshness is an Enum similar to `Color::Red`/`Freshness::Fresh`.

A quick and easy struct while having less inferance from your editor would be:

```rust
#[derive(Debug, Copy, Clone)]
pub struct Apple {
    pub color: String,
    pub freshness: String,
}
```

An optimized version of that:

```rust
#[derive(Debug, Copy, Clone)]
pub struct Apple {
    color: u8,
    freshness: u8,
}
```

Here a `u8` is a cheap memory saving trick while still having to map things out and not have as much intellisense. While the editor will know it's a `u8` you'll have to memorize what 0, 6, 11, or 24 means.

Whereas with an enum you just know because it tells you.

With the enum we now have half the footprint as using the `u8`s.

Since we have to store 2 `u8`s in the low memory struct version, that's two bytes.

With the enum we can store all 6 potential different states as 1 byte.

Pretty cool!

### Quarks

[This PR in Oxidizy](https://github.com/selfup/oxidizy/pull/12) introduces a work in progress of this refactor.

Essentially additional enums were made to create a representation of a created `Proton`/`Neutron`. So we still create the original elements on the fly to have all the correct business logic in place, then we infer from the created object the representation of that data that we will store in RAM. The created object that is not stored now dissapears, reducing the memory footprint. `Protons` is a two field struct with a count and a default array of 118 `ProtonData::Unknown`s.

What is `ProtonData`? That was the made up abstraction to the `Proton` objects themselves:

```rust
#[derive(Debug, Copy, Clone)]
pub enum ProtonData {
    Unknown,
    RedUpUpDownQuark,
    BlueUpUpDownQuark,
    GreenUpUpDownQuark,
    AlphaUpUpDownQuark,
}
```

Something similar was done with quarks, and an enum called `QuarkData` was made. This makes processing a `Proton` quite simple matching a 3 element tuple:

```rust
impl ProtonData {
    pub fn new(proton: Proton) -> Self {
        let first_quark: QuarkData = Quark::data(proton.quarks.0);
        let second_quark: QuarkData = Quark::data(proton.quarks.1);
        let third_quark: QuarkData = Quark::data(proton.quarks.2);

        match (first_quark, second_quark, third_quark) {
            (QuarkData::RedUpQuark, QuarkData::RedUpQuark, QuarkData::RedDownQuark) =>
                ProtonData::RedUpUpDownQuark,
            
            (QuarkData::BlueUpQuark, QuarkData::BlueUpQuark, QuarkData::BlueDownQuark) =>
                ProtonData::BlueUpUpDownQuark,
            
            (QuarkData::GreenUpQuark, QuarkData::GreenUpQuark, QuarkData::GreenDownQuark) =>
                ProtonData::GreenUpUpDownQuark,
            
            (QuarkData::AlphaUpQuark, QuarkData::AlphaUpQuark, QuarkData::AlphaDownQuark) =>
                ProtonData::AlphaUpUpDownQuark,
            
            _ => ProtonData::Unknown,
        }
    }
}
```

This same logic is being implemented for `Neutrons` as well since they are made of `Quarks`.

Here is `QuarkData` for further clarification:

```rust
#[derive(Debug, Copy, Clone)]
pub enum QuarkData {
    Unknown,
    RedUpQuark,
    RedDownQuark,
    BlueUpQuark,
    BlueDownQuark,
    GreenUpQuark,
    GreenDownQuark,
    AlphaUpQuark,
    AlphaDownQuark,
}
```

So there you have it.

Increase CPU a bit, decrease mem allocations by a significant amount by utilizing C style enums, and a faster program emerges!
