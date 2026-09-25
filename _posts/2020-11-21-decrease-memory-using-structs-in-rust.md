---
layout: post
title: 'Decrease Memory Using Enums in Rust'
published: true
---

I'm slowly building an atom/universe generator and visualizer in Rust with some friends. The project is called [Oxidizy](https://github.com/selfup/oxidizy).

I started it many years ago. Now that [Bevy](https://github.com/bevyengine/bevy) exists, a game engine that makes ECS (Entity Component System) a breeze, I decided to go back and optimize the universe generator.

The first job was multithreaded mutations. Once those were in a reasonable state, we moved on to adding more layers to the generator. That's where we hit a wall: memory. Even on a machine with 32GB of RAM (DDR4 3200MHz C16), it was becoming an unfortunate constraint.

Here is what the generator ([unigen-rs](https://github.com/selfup/unigen-rs), not the simulator) outputs at max workload on my hardware:

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

Before the quark optimization ([in this PR](https://github.com/selfup/oxidizy/pull/12)), we capped out at 5.6 billion.

The optimization cut the memory footprint 5.9 times. A run now finishes in about the same amount of time as the old 5.6 billion Quark runs, while processing 4 times as much. Decreasing the memory profile improved performance 4 times over. That's a rare outcome for sure!

There is a trade-off: the CPU does more work now. That part is specific to our application, not a consequence of using enums. We chose to keep building the original structures and then infer the enum from them. More tedious, but it will help when we introduce algebra. As a bonus, that extra work is spread across all threads, so every logical core gets put to use.

So how do enums pull that off? Let's start with the basics.

### Enums

Here is a basic enum in Rust:

```rust
#[derive(Debug, Copy, Clone)]
pub enum Apple {
    Green,
    Red,
    Yellow,
}
```

Say we grab a random `Apple` out of a basket. We can inspect it and know it's exactly one of `Apple::Green`, `Apple::Red`, or `Apple::Yellow`. Nothing else is possible.

That's a pretty powerful construct. Under the hood Rust stores it as a small number, but you never have to deal with that number yourself. You work with names you made up, ones your editor can autocomplete and you can read at a glance.

It's also tiny. That `Apple` enum is 1 byte. Add 20 more variants and it's still 1 byte. In fact it stays 1 byte all the way up to 256 variants. Add a 257th and it grows to 2 bytes.

That means we can pack more information into each variant. Say we also care about freshness:

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

A _single_ `Apple` now tells us both its color (3 options) and its freshness (2 options). It's always exactly one of the 6 combinations, and it's still 1 byte.

> **Side note:** this only holds for C-style enums, where the variants don't carry any data. Once variants start holding values, the enum's size depends on what they hold. Here is a great rundown on Stack Overflow: [Enum Size Rundown](https://stackoverflow.com/a/45463142). A very useful function when optimizing is [std::mem::size_of](https://doc.rust-lang.org/std/mem/fn.size_of.html), which we'll use below.

This is where enums get really fun: matching, especially on tuples. Let's make a `Carrot` the same way:

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

Now say we're at the store with one of each in our basket, and we want to decide what to do next:

```rust
let my_food_basket = (Apple::RedAndFresh, Carrot::PurpleAndNotFresh);

match my_food_basket {
    (Apple::RedAndFresh, Carrot::PurpleAndNotFresh) => println!("find a fresh purple carrot"),
    (Apple::RedAndFresh, Carrot::PurpleAndFresh) => println!("go pay at checkout"),

    _ => println!("not sure what to do"),
}
```

Rust checks the pair against each arm in order and runs the first one that fits. Our carrot isn't fresh, so we go find a better one. The `_` arm catches every other combination, and Rust won't compile the `match` until every possible pair is handled.

Cool! Now let's look at why this saves so much space. We'll build the same `Apple` a few different ways and measure each one.

#### Attempt 1: Strings

The quickest thing to reach for is a couple of `String`s:

```rust
#[derive(Debug, Clone)]
pub struct Apple {
    pub color: String,
    pub freshness: String,
}
```

It reads fine, but it's the most expensive option by far. Each `String` is 24 bytes on a 64-bit machine (a pointer, a length, and a capacity), so this struct is 48 bytes before the text itself is even allocated on the heap. That heap allocation is also why it can't derive `Copy`.

Nothing stops you from writing `"rde"` either. The compiler can't help you.

#### Attempt 2: u8s

To save memory, you could store numbers instead:

```rust
#[derive(Debug, Copy, Clone)]
pub struct Apple {
    pub color: u8,
    pub freshness: u8,
}
```

That's 2 bytes. A huge improvement! But now you have to remember what `0`, `1`, and `2` mean for color, and nothing stops you from storing a `7`. The editor knows it's a `u8` and that's all it knows.

#### Attempt 3: A struct of enums

The traditional, maintainable approach is a struct of two small enums:

```rust
#[derive(Debug, Copy, Clone)]
pub enum Color {
    Green,
    Red,
    Yellow,
}

#[derive(Debug, Copy, Clone)]
pub enum Freshness {
    Fresh,
    NotFresh,
}

#[derive(Debug, Copy, Clone)]
pub struct Apple {
    pub color: Color,
    pub freshness: Freshness,
}
```

Each enum is 1 byte, so this is still 2 bytes. Same size as the `u8`s, but now your editor knows every possible value, and the compiler won't let you store a color that doesn't exist. Readability for free.

#### Attempt 4: One enum

Finally, the `Apple` enum from above, where color and freshness are combined into a single type. There are only 6 possible apples, and 6 fits easily in a single byte.

That's half the size of attempts 2 and 3, and just as readable.

#### Side by side

| Apple as | Size |
|---|---|
| Two `String`s | 48 bytes + heap |
| Two `u8`s | 2 bytes |
| Two enums | 2 bytes |
| One enum | 1 byte |

You can check any of these yourself:

```rust
println!("{}", std::mem::size_of::<Apple>());
```

One byte doesn't sound like much. It adds up fast though. Say you store one of these for each of the 11 billion Baryons in the output at the top of this post:

- One enum: 11 GB
- Two enums or two `u8`s: 22 GB
- Two `String`s: over 500 GB, before the text itself

On a 32GB machine, that's the difference between fitting comfortably, getting tight, and not a chance.

The trade-off is that every combination needs its own variant. 3 colors and 2 freshness states make 6 variants. Add a third property with 4 options and you're at 24. That's fine for a handful of properties, and you have up to 256 variants before it grows to 2 bytes.

Pretty cool!

### Quarks

Now back to the universe. [This PR in Oxidizy](https://github.com/selfup/oxidizy/pull/12) applies the same idea to quarks. It's a work in progress of this refactor.

The generator still builds real `Proton` and `Neutron` structs on the fly, so all the business logic stays in one place. But instead of keeping them, it reads each one, stores a 1 byte enum that represents it, and lets the original go. The full struct only lives long enough to be inspected, and that's where the memory savings come from.

Here's the enum a proton gets stored as:

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

`Protons` is a struct with two fields: a count, and an array of 118 `ProtonData` values that all start out as `ProtonData::Unknown`.

Quarks got the same treatment, with an enum called `QuarkData`:

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

A proton is made of three quarks, so turning one into a `ProtonData` is the same tuple matching trick from the fruit basket, just with three elements instead of two:

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

Neutrons work the same way, since they're made of quarks too.

So there you have it. Spend a bit more CPU, store tiny C-style enums instead of full structs, and memory drops enough that the same run time now processes 4 times as much!
