---
layout: post
title: "Optimization and Performance: Memoizing in JavaScript!"
date: 2017-07-23 22:43:44 -0600
categories: domevents
---

# Learn to memoize in JS with Fibonacci

The classic, first introduction to recursion most of us know.

The problem is, we immediately see why tail call optimization is so important. We don't want to pollute the stack, but how do we do this?

Ahh, well we create our own sort of optimization!

### Basic Fib Implementation

Here is an example of a basic `fib` function:

```javascript
function fib(number) {
  if (number < 2) return number;
  return fib(number - 1) + fib(number - 2);
}
```

Ok, so with small numbers this works just fine.

Example: `fib(23);`

_Now if you try_: `fib(42);`

You _will_ wait..and wait..and then you will finally get your result.

Seems that the answer to life (**42**) is telling us something here.

## Optimization

How can we possibly make **42** and other numbers like **900** run quickly? We have to pseudo tail call optimize the function itself.

What this means is that we have to store the results of the recursion to avoid expanding our stack (_sounds scary I know!_).

If you google `memoization in JavaScript` you will see some (what I consider) overly complex solutions. Here I will try to focus on memoizing kind of how `ruby` does it.

Here is an example of non memoized and memoized ruby:

```ruby
def fib(n)
  return n if n < 2

  fib(n - 1) + fib(n - 2)
end

def memo_fib(n, cache = {})
  return n if n < 2

  cache[n] ||= fib(n - 1, cache) + fib(n - 2, cache)
end
```

What is going on there? `||=` is very powerful in ruby. Essentially, if **an assignment attempt** _already equals something_, just return what it equals, otherwise, make it equal something.

This is very helpful as `fib` goes down the recursive stack because now it checks if it has already solved the same problem or not.

This ensures that the function doesn't have to start from scratch all over again!

### Javascript

```javascript
const fib = (num, cache = {}) => {
  if (num < 2) {
    return num;
  }

  // if the cached result exists, return the cached result
  if (cache[num]) {
    return cache[num];
  }

  // otherwise, create a new entry in the cache with the new result
  cache[num] = fib(num - 1, cache) + fib(num - 2, cache);

  // return the result so recursion can continue
  return cache[num];
};
```

Now this function can take **42**, **500**, **900**, **1000**, and so on!

_Take note: This is not a compiler level tail call optimization which ES6 does provide with certain flags in beta versions of Chrome._

To be fair once you get near **2000**, it will start just returning `Infinity`. However this is a good way to show the power of being able to optimize a tail call ourselves, without having to do too much magic.

Either way you decide to assign a cache key to the result of the function (as long as you return the function result) you should be good to go.

**Here is a way to do it in ES5**:

```javascript
function fib(n, cache) {
  cache = cache || {};

  if (n < 2) {
    return n;
  } else {
    if (cache[n]) {
      return cache[n];
    } else {
      cache[n] = fib(n - 1, cache) + fib(n - 2, cache);
      return cache[n];
    }
  }
}
```

## Conclusion

Recursion is powerful until it is not. Finding ways to memoize is an extremely powerful approach to optimizing your code!
