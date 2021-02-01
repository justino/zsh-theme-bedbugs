# ZSH 'Bedbugs' Theme

## What does it do?

* Shows user and hostname (always)
* Shows number of background jobs (when there are some)
* Shows current working directory (always)
* Shows Python Virtualenv (when there is one)
* Shows Git status (when in a repo)
  * Working Branch
  * Dirty Tree
  * Staged/Unstaged
  * Number of stashes (when there are some)
* Root/User sigil
* Colored return value of previously run command

## Who cares? Show it to me!

![Example](https://raw.githubusercontent.com/justino/zsh-theme-bedbugs/master/assets/lookandfeel.png)

## Inspriation

This theme is largely inspired by the [agnoster](https://github.com/agnoster/agnoster-zsh-theme) theme.

I really liked the look and feel but wanted to make enough changes that would effectively make this a new theme.

## What's different?

Multi-line. No longer try to cram a lot of information into one line, instead representing some information on the top line, and other information on the input line.

No reliance on Powerline fonts, could do without the notched segments.

I also wasn't a fan of the way jobs, root/user, and return value were represented.

I wanted some additional Git information displayed, such as count of stashes.
