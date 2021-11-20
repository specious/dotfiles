Pieces to share from the configuration files I use.

Some of my configuration files are also posted here: https://keybase.pub/tknomad/files/config/

## bashrc

Functionality I share between bash and zsh. I generally have it available as `/etc/sh` which is sourced by both my `.bashrc` and `.zshrc` files with the line:

```sh
. /etc/sh
```
My custom prompt with git integration is available for:
- [bash](https://gist.github.com/specious/8244801)
- [zsh](https://github.com/specious/bender)

Some parts may be specific to the Linux system I use.

## zshrc

These are configuration options for [zsh](https://en.wikipedia.org/wiki/Z_shell), which are in addition to [oh-my-zsh](https://ohmyz.sh/) with my [custome prompt](https://github.com/specious/bender) and customizations that pertain specifically to my local system.

## vimrc

Vim is currently my main text editor. This `.vimrc` file uses [dein](https://github.com/Shougo/dein.vim) to manage plugins.

Resources I found helpful:

- [Vim annoyances](https://sanctum.geek.nz/arabesque/vim-annoyances/)
- [Introduction to managing windows and buffers](https://thevaluable.dev/vim-intermediate/)
- [Buffers vs Tabs](https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/)

## screenrc

Put this in your home folder as `~/.screenrc`.

Resources I found helpful:

- [Quick reference](https://gist.github.com/kapitanluffy/656f3eb879b408b1d8a7fee0b6952216)

## i3wm .config

Resources I found helpful:

- [An article on i3wm setup](https://tildeho.me/windowmanager-setup/)

## Also I use...

Firefox add-ons:
- [QR Code](https://addons.mozilla.org/en-US/firefox/addon/qr-code-address-bar/)
- [URL Parameters Editor](https://addons.mozilla.org/en-US/firefox/addon/url-parameters-editor/)
- [Pentadactyl](http://bug.5digits.org/pentadactyl/) (used to work with Firefox but is now availabe as a [Palemoon add-on](https://addons.palemoon.org/addon/pentadactyl-community/))

## Contributing

If you can improve something, by all means open a pull request.
