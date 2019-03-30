---
layout: post
title: 'JS: Using Reduce for Synchronizing Async Calls'
---

# Using Reduce for Synchronizing Async Calls

So let's say you want to slowly write out a sentence. `forEach` and `map` won't wait for each async call to go through. However, if you form a `reduce` properly, it has to!

In this example we will be writting text to an empty HTML element.

```html
<div>
  <pre><h1 class="my-text"></h1></pre>
</div>
```

```js
const myText = document.querySelector('.my-text');

const writeChars = (myText, char) => new Promise((resolve, reject) => {
  return setTimeout(() => {
    myText.innerText += char;
    resolve();
  }, 25);
});

function type(sentence) {
  sentence.split('').reduce((promiseResolver, char) => {
    return promiseResolver.then(() => writeChars(myText, char));
  }, Promise.resolve());
}

type('This is a sentence');
```

1. First we grab the `h1`
1. Then we write a function that writes to `innerText` after some time
1. We wrap the `setTimeout` in a `Promise`
1. We write a function called `type`
1. It takes in a string and splits it by char
1. Each char is then iterated over via the `reduce`
1. We return a `Promise` of `writeChars` and tell the reduce to `resolve` said `Promise`
1. Each char will wait `25ms` to be typed!

Here is a little bit more advanced CodePen:

<p data-height="311" data-theme-id="0" data-slug-hash="ePBJOr" data-default-tab="js,result" data-user="selfup" data-pen-title="feedread" data-preview="true" class="codepen">See the Pen <a href="https://codepen.io/selfup/pen/ePBJOr/">feedread</a> by Regis Boudinot (<a href="https://codepen.io/selfup">@selfup</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

### Conclusion

Nothing crazy, just something we all run into sometimes.

Hope you enjoyed this little micro blog!
