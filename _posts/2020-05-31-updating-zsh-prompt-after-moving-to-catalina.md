---
layout: post
title: 'Micro: Updating Zsh Prompt After Moving To Catalina'
published: true
---

# Updating Zsh Prompt After Moving To Catalina

### MacOS Catalina

So I waited a bit for Catalina to mature before upgrading my Mac. It will keep you on `bash` if you upgrade but it will only have `zsh` if you do a clean install.

I tested out `zsh` on my Linux machine (Ubuntu 18.04LTS) and discovered some neat things. Once I felt comfortable I changed the default shell on Catalina:

```zsh
chsh -s /bin/zsh
```

First of all, no more real need to worry about a `.bash_profile`/`.zprofile` as the `.zshrc` behaves like a `.bashrc`.

Let's say I like have a terminal prompt like so:

```zsh
dom.events (master) $ 
```

Where the cursor is one space after the dollar sign.

Let's look into taking a function that is popular (`parse_git_branch`) and using the easy to read color schemas for zsh.

```zsh
setopt PROMPT_SUBST

parse_git_branch() {
  echo $(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
}

prmpt() {
    current_dir=$(basename $(pwd))
    current_branch=$(parse_git_branch)

    prompt="%F{yellow}${current_dir}%f"

    if [[ $current_branch != '' ]]
    then
        prompt="${prompt} %F{green}${current_branch}%f"
    fi

    prompt="${prompt} $ "

    PROMPT=$prompt
}

precmd() {
    prmpt
}
```

Here we see a function called `precmd`. According to the [zsh documentation on sourceforge](http://zsh.sourceforge.net/Doc/Release/Functions.html) (the link is plain text http not https):

```
precmd

Executed before each prompt. Note that precommand functions are not re-executed simply because the command line is redrawn, as happens, for example, when a notification about an exiting job is displayed.
```

So this is exactly what we want! After we change a directory, switch branches, execute a command, we get a consistent update that is in tune with our environment!

I also like the `%F{yellow}%f` notation. The capital `F%` is the begining of a color block and the lower case `%f` is the end. So you can easily dictate when the color changes.

### Conclusion

Hope this post made switching over a bit easier. I use two really helpful aliases when updating my rc files, these two are specific to the `.zshrc` file.

```zsh
alias zrc="code $HOME/.zshrc"
alias zgo="source $HOME/.zshrc"
```

This way I can open, edit, and make available any change I am working on in my rc file.

