---
layout: post
title: 'JS: Lazy Redux Reducer'
---

# Lazy Redux Reducer

For when you are just spiking and don't have time to make actions!

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

const setProps = setReduxState({ dispatch: this.props.dispatch });

setProps({ anyKey: 'anyValue' });
```

### Conclusion

This behaves like `setState` but instead it's for your store!
