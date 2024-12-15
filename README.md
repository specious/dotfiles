My configuration files, which you can adopt in part or in whole.

I didn't include the leading dot, as that would hide them inside my local git repository which is inconvenient.

## Custom shell prompt

My custom prompt called *bender* (which includes [git](https://git-scm.com) integration) is available for:

- [bash](https://gist.github.com/specious/8244801)
- [zsh](https://github.com/specious/bender)

## bashrc

It's included with the name `bashrc` here, but it contains functionality designed to be shared by both bash and zsh. I generally make it available as `/etc/sh` which is [sourced](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-source) by both my `.bashrc` and `.zshrc` files by including this line:

```sh
. /etc/sh
```

This file, in turn, sources `/etc/sh-local.sh`, which contains functionality for that specific machine or operating system.

## zshrc

These are configuration options specifically for [zsh](https://en.wikipedia.org/wiki/Z_shell), which I generally apply on top of [oh-my-zsh](https://ohmyz.sh/) with my [custom prompt](https://github.com/specious/bender).

Generally my `.zshrc` file sources the `/etc/sh` mentioned earlier.

Add these to your `.zshrc` file if you think they are useful.

## vimrc

I love [vim](https://www.vim.org) and use it as my main text editor (this includes [neovim](https://neovim.io)). This `.vimrc` file makes vim way more ergonomic and requires the [dein](https://github.com/Shougo/dein.vim) (the installation of which is unforunately slightly tricky) plugin manager to install the vim plugins.

I started my vim journey by looking at other people's `.vimrc` files and looking up what each line did to figure out what my configuration file should look like.

In fact, that's how I learned how to use vim.

Adjust the `s:dein_base` value to match your home directory and dein installation directory. The reason I didn't use `~` was so that `root` would load the same `.vimrc` without problems.

Resources I found particularly helpful:

- [Vim annoyances](https://sanctum.geek.nz/arabesque/vim-annoyances/)
- [Introduction to managing windows and buffers](https://thevaluable.dev/vim-intermediate/)
- [Buffers vs Tabs](https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/)

## screenrc

Save this in your home folder as `~/.screenrc` if you use [screen](https://www.gnu.org/software/screen/) to abstract your terminal sessions.

I now mostly use [tmux](https://github.com/tmux/tmux) because it's more advanced.

Resources I found helpful:

- [Quick reference](https://gist.github.com/kapitanluffy/656f3eb879b408b1d8a7fee0b6952216)

## i3wm .config

Resources I found helpful:

- [An article on i3wm setup](https://tildeho.me/windowmanager-setup/)

I now use [sway](https://swaywm.org) which is a [Wayland](https://wayland.freedesktop.org) compositor that uses a similar configuration to i3.

## Also I use...

Firefox add-ons:
- [QR Code](https://addons.mozilla.org/en-US/firefox/addon/qr-code-address-bar/)
- [URL Parameters Editor](https://addons.mozilla.org/en-US/firefox/addon/url-parameters-editor/)
- [Pentadactyl](http://bug.5digits.org/pentadactyl/) (used to work with Firefox but is now availabe as a [Palemoon add-on](https://addons.palemoon.org/addon/pentadactyl-community/))

## Contributing

If you can improve something, by all means open a pull request.
