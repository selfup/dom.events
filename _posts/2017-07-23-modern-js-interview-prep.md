---
layout: post
title:  "Modern JavaScript Interview Prep!"
date:   2017-07-23 20:43:44 -0600
categories: domevents
---

### Test your JS knowledge

_test code blocks in your dev tools console, or wherever :)_

<hr>
<hr>
<hr>  
<br>

## Iterators

What is the difference between `forEach` and `map` in JS?

**forEach:**

```javascript
const arr = [1, 2, 3];

const eachExample = () => arr.forEach(e => e);

console.log(eachExample());
```

What will the `console.log` print? Guess without running the code.

**map:**

```javascript
const arr = [1, 2, 3];

const mapExample = () => arr.map(e => e);

console.log(mapExample());
```

**bonus map example:**

```javascript
const arr = [1, 2, 3];

const mapExample = () => arr.map(e => { e });

console.log(mapExample());
```

What will the `console.log` print in the basic map example? In the bonus map example? Guess. Run no code.

## References

How does JS deal with references?

Examples to refresh your mind. *Do not run the code*.

```javascript
const a = [1, 2, 3];

const b = a;

b[0] = 90;

console.log(a);
```

What will the `zeroth` element in `a` look like? Guess without running the code.

```javascript
const a = [1, 2, 3];

const b = a.map(e => e);

const c = a.slice(0);

b[0] = 90;

c[0] = 100;

console.log(a, b, c);
```

What will the `zeroth` elements be on each array? Guess without running code.

## Events

What is event delegation? Bubbling?

When would you delegate?

```html
<ul id="list">
  <li>Hi</li>
  <li>Hello</li>
  <li>Hello again</li>
</ul>
```

With one event listener, how can I `console.log` the text from *a specific* list item?

**No `jQuery`. No `this`.**

Template for JS answer:

```javascript
document
  .querySelector('#list')
  .addEventListener(/* your code goes here */);
```

You should not need curly braces to `console.log` the text of *a* list item.

## Variables

1. Why is `const` preffered over `var` and `let`?

1. Is a `let` the same as a `var`?

## Functions

```javascript
const wow = () => 'wow';

console.log(wow());
```

How would you write this is `ES5`?

## Asynchronous Resolutions

```js
Promise.resolve().then(() => console.log('one'));
(async () => console.log('two'))();
setTimeout(() => console.log('three'), 0);
```

In what order will the three statements above print to the console?

(This is more just for fun, as it's an obviously contrived situation.)

## Default Parameters

```js
function test({hello='world'}) {
  console.log(hello);
}
test();
```

What will `test()` print to the console? (Careful, pay attention to the way this example is written)

```js
function test(obj={hello:'world'}) {
  console.log(obj.hello);
}
test({foo: 'bar'});
```

What about now? What will `test({foo: 'bar'});` print to the console?

## Closures

```javascript
const addOne = () => {
  let num = 0;
  return () => num += 1;
}
```

What happens if I do:

```javascript
let a = addOne();

a();

a();
```

## Currying

```javascript
const addNums = num1 => num2 => num3 => num1 + num2 + num3;
```

What happens if I do:

```javascript
addNums(3);
```

What happens if I do:

```javascript
addNums(3)(4)(5);
```

## Destructuring

```javascript
const obj = {
  ok: 'wow ok',
  wow: 'wow wow',
};

const { ok } = obj;

console.log(ok);
```

What will the `console.log` print?

## Classes

```javascript
class Wow {
  constructor() {
    this.wow = 'wow';
  }
};

class Ok extends Wow {
  constructor() {
    super();
  }

  printWow() {
    console.log(this.wow);
  }
};

const ok = new Ok();
ok.printWow();
```

Is this blowing your mind yet?

What will `ok.printWow()` do?

## Binding

```html
<div id="entry">
  <h1>wow</h1>
</div>
```

```javascript
const printDomStuff = new class {
  constructor() {
    this.entry = document.querySelector('#entry');
    this.fromClass = 'from class';
  }

  printWowOnClick() {
    this.entry.addEventListener('click', function(e) {
      console.log(this.fromClass);
      console.log(e.target.innerText);
    });
  }
};

printDomStuff.printWowOnClick();
```

How do we make `console.log(this.fromClass)` work?

What will `console.log(this)` print inside of the `'click'` callback?

## Passing by Reference
```javascript
const reassignWow = wow => {
  wow = { ok: 'neat' };
}

let x = { ok: 'cool!' };

reassignWow(x);

console.log(x.ok);
```
What will `console.log(x.ok)` print?

```javascript
const doStuffToWow = wow => {
  wow.ok = 'cool!';
}

let x = { ok: 'neat' };

doStuffToWow(x);

console.log(x.ok);
```
What will `console.log(x.ok)` print?

## Hoisting

```javascript
const printWow = () => {
  console.log(x);
  let x = 'wow';
}
```

What will `console.log(x)` print?

## Calling

```javascript
class Demo {
  constructor() {
    this.ok = 'ok';
  }

  printStuff(stuff) {
    console.log(this.ok + stuff);
  }
};

const d = new Demo();

const ok = function printOk() {
  this.ok = 'weird stuff';
  d.printStuff.call(this, " wasn't that cool");
}

ok();
```

What will `ok()` print?
