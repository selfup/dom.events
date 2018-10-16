---
layout: post
title:  Private methods in es6
---

# Private methods in es6

Private Methods in ES6
Lessons learned from making my first npm package

Decided to write a database in Javascript for server side developer freedom in NodeJS. ES6 is my preferred flavor of Javascript, so off I went. Here is what I learned from doing this in a weekend.

Here is the repo: [https://github.com/selfup/rejs](https://github.com/selfup/rejs)

The package on npm: [https://www.npmjs.com/package/selfup-rejs/](https://www.npmjs.com/package/selfup-rejs/)

Making a DB for the sake of learning is highly educational. Learned a ton about the fs module in node and how important it is to make your code readable and understandable.

[Josh Cheek](https://github.com/JoshCheek) found the time to refactor my code and make a nice pull request. He however was having trouble making methods private in the ES6 class that my library has. I had trouble doing it as well.

[Steve Kinney](https://github.com/stevekinney) was kind enough to explain that Symbols were the answer in ES6 to make methods private. So off I went and read the few resources available to explain how it is done. Even though ES6 is technically last years standard, people seem to be quite slow at adopting it. Which is crazy, since ES7 is bound to be the standard this year now that ECMA is releasing a new version every year!

This made finding detailed tutorials kind of difficult.

How to make private methods in an ES6 class
First will be a gist of the original class, with all public facing methods.

```js
'use strict'

const fs = require('fs')
const _  = require('lodash')

class Rejs {
  constructor() {
    if(fs.existsSync("rejs"))
      return
    fs.mkdirSync("rejs", err => {
      if(err) console.log(err)
    })
  }

  // public
  createTable(tableName) {
    if(fs.existsSync(`./rejs/${tableName}`)) return
    this.resetTable(tableName)
  }

  newData(tableName, data) {
    this.modifyTable(tableName, t => t[t[0].nextId++] = data)
  }

  deleteById(tableName, id) {
    this.modifyTable(tableName, t => delete t[id])
  }

  dropTable(tableName) {
    fs.unlinkSync(`./rejs/${tableName}`)
  }

  updateTable(tableName, data) {
    this.resetTable(tableName)
    this.newData(tableName, data)
  }

  getTable(tableName) {
    return JSON.parse(fs.readFileSync(`./rejs/${tableName}`, 'utf8'))
  }

  findId(tableName, id) {
    return this.getTable(tableName)[id]
  }

  where(tableName, prop) {
    const whereTable = this.getTable(tableName)
    const records    = _.values(whereTable)
    records.shift() // remove the metadata
    return _.filter(records, (record) => _.includes(record, prop))
  }

  // private
  replaceTable(tableName, data) {
    fs.writeFileSync(`./rejs/${tableName}`, JSON.stringify(data))
  }

  resetTable(tableName) {
    this.replaceTable(tableName, this.initialData(tableName))
  }

  modifyTable(tableName, fn) {
    const table = this.getTable(tableName)
    fn(table)
    this.replaceTable(tableName, table)
  }

  initialData(tableName) {
    return {"0": {"table": tableName, nextId: 1}}
  }
}

module.exports = Rejs
```

As you can see, nothing actually makes these methods private.

```js
'use strict'

const fs = require('fs')
const _  = require('lodash')

const _resetTable = Symbol('resetTable');
const _modifyTable = Symbol('modifyTable');
const _replaceTable = Symbol('replaceTable');
const _initialData = Symbol('initialData');

class Rejs {
  constructor() {
    if (fs.existsSync("rejs")) return
    fs.mkdirSync("rejs", err => { if (err) console.log(err) })
  }

  // public
  createTable(tableName) {
    if (fs.existsSync(`./rejs/${tableName}`)) return
    this[_resetTable](tableName)
  }

  newData(tableName, data) {
    this[_modifyTable](tableName, t => t[t[0].nextId++] = data)
  }

  deleteById(tableName, id) {
    this[_modifyTable](tableName, t => delete t[id])
  }

  dropTable(tableName) {
    fs.unlinkSync(`./rejs/${tableName}`)
  }

  updateTable(tableName, data) {
    this[_resetTable](tableName)
    this.newData(tableName, data)
  }

  getTable(tableName) {
    return JSON.parse(fs.readFileSync(`./rejs/${tableName}`, 'utf8'))
  }

  findId(tableName, id) {
    return this.getTable(tableName)[id]
  }

  where(tableName, prop) {
    const whereTable = this.getTable(tableName)
    const records    = _.values(whereTable)
    records.shift() // remove the metadata
    return _.filter(records, (record) => _.includes(record, prop))
  }

  // private
  [_replaceTable](tableName, data) {
    fs.writeFileSync(`./rejs/${tableName}`, JSON.stringify(data))
  }

  [_resetTable](tableName) {
    this[_replaceTable](tableName, this[_initialData](tableName))
  }

  [_modifyTable](tableName, fn) {
    const table = this.getTable(tableName)
    fn(table)
    this[_replaceTable](tableName, table)
  }

  [_initialData](tableName) {
    return {"0": {"table": tableName, nextId: 1}}
  }
}

module.exports = Rejs
```

Now, here is the real easy part. You make your methods as you please, wrap them in hard brackets, prepend an underscore (naming convention it seems) and then define the Symbols as constants above the class.

Once you have done this, remove the dots between this and the method wherever they were being called. Add brackets and underscores everywhere else they are being called, and now these methods are not available outside of the class!

Why private methods?
To protect myself and developers from my library.

Someone could easily read the open source code, see that there are more methods available to them, and accidentally break the way the DB works and ruin their project. Private methods are for developer safety.

The idea of this Key Value Store Database that can store Events Over Time, is that it is simple. There should not be an easy way to break things.

So private methods ensure that the developers using my library can be free to use what is available to them and not break anything!

Conclusion
If you are writing ES6, and you are going to make a library for other people to use, heavily consider the use of private methods to save yourself as well as others!
