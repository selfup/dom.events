---
layout: post
title: Lazy Redux Reducer
---

# A Very Lazy Redux Reducer

For when you are just spiking and don't have time to make actions!

![](https://pbs.twimg.com/media/DpRmoFJVAAAOZ4Z.png)

Just in case the image doesn't load:

```js
const lazyReducer = (state = {}, { type, data }) => {
  switch (type) {
    case 'LAZY':
      return {
        ...state,
        ...data,
      };
    default:
      return state;
  }
}

...

this.dispatch({
  type: 'LAZY',
    data: {
      anyKey: 'anyValue',
      anotherKey: 'anotherValue',
    },
  },
});

...

export const setReduxState = ({ dispatch }) => (data = {}) => {
  const type = 'LAZY';

  dispatch({ type, data });
}

...

const setProps = setReduxState(this.props);

setProps({ anyKey: 'anyValue' });
```

### Conclusion

This behaves like `setState` but instead it's for your store!
