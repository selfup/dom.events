---
layout: post
title:  'Micro: exit code conditionals in Bash'
---

# Exit code conditionals

*TIL* about `$?` :thinking:

Just as confusing as it looks, but it makes a good bit of sense once you learn it.

Say you run: `echo 'hello' | grep 'ello'`

That will have an exit code of `0` (no failure, ran successfully).

Say you have a file `answer_to_life.txt`. We can grep the contents of the file and use the `$?` to see if grep succeeded in finding our matching pattern.

So you can do something like:

```bash
cat answer_to_life.txt | grep '42'
if [ $? -eq '0' ]
then
  echo 'The answer to life is: 42'
else
  echo 'Apparently the answer to life is not 42'
fi
```

We have the grep run, check for the exit code of the **latest operation** and if it equals `"0"`, then we print our known fact. Otherwise we print that we guessed wrong.

Just a neat little trick. Should be useful for a lot of things! :tada:
