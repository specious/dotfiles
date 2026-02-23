My configuration files, which you can adopt in part or in whole.

I didn't include the leading dot, as that would hide them inside my local git repository which is inconvenient.

## Custom shell prompt

My custom prompt called *bender* (which includes [git](https://git-scm.com) integration) is available for:

- [bash](https://gist.github.com/specious/8244801)
- [zsh](https://github.com/specious/bender)
- [fish](https://gist.github.com/specious/50bac54ac9e4ba9b88dbf24623d51dfc)

## bashrc-*

These are shell configuration files (compatible with both bash and zsh), split into platform and system specific components (or layers).

My actual configuration layout looks like this:

- `~/.zshrc` and `~/.bashrc` just source `/etc/sh` and then `/etc/sh` internally stacks all the layers that apply to the specific machine being configured (starting with `base`):

```sh
# /etc/sh

. /etc/sh-base.sh
. /etc/sh-linux.sh
. /etc/sh-arch.sh  # Arch linux
. /etc/sh-x1.sh    # ThinkPad X1

# Local configuration specific to this machine
```

NOTE: Rename each `bashrc-*` to `/etc/sh-*.sh` and create `/etc/sh` on the local system as the authoritative bash/zsh shell config file. zsh-specific configuration can then go inside `~/.zshrc` after the `. /etc/sh` line.

I named the files `bashrc-*` in the git repo so people know what they are. The `.sh` extension is tacked on to trigger syntax highlighting. Feel free to do it your way, but this system works very well.

## zshrc

These are configuration options specifically for [zsh](https://en.wikipedia.org/wiki/Z_shell), which I generally apply on top of [oh-my-zsh](https://ohmyz.sh/) with my [custom prompt](https://github.com/specious/bender).

Generally my `.zshrc` file first sources the `/etc/sh` file mentioned earlier and then includes these zshrc-specific additions.

## vimrc

I thoroughly enjoy using [vim](https://www.vim.org) and use it as my primary text editor (mostly [neovim](https://neovim.io)). This `.vimrc` file makes vim into an ergonomic environment and requires the [dein](https://github.com/Shougo/dein.vim) plugin manager to install the vim plugins.

I started my vim journey by looking at other people's `.vimrc` files and looking up what each line did to figure out what my configuration file should look like.

Change the `s:user_home` value to match your user's home directory and the `s:dein_install` value to match your dein installation directory.

Resources I found particularly helpful:

- [Vim annoyances](https://sanctum.geek.nz/arabesque/vim-annoyances/)
- [Introduction to managing windows and buffers](https://thevaluable.dev/vim-intermediate/)
- [Buffers vs Tabs](https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/)

## screenrc

Save this in your home folder as `~/.screenrc` if you use [screen](https://www.gnu.org/software/screen/) to abstract your terminal sessions.

Resources I found helpful:

- [Quick reference](https://gist.github.com/kapitanluffy/656f3eb879b408b1d8a7fee0b6952216)

## tmux.conf

[tmux](https://github.com/tmux/tmux) is more advanced than GNU Screen.

Save this as `/etc/tmux.conf` to use it system-wide, or as `~/.config/tmux/tmux.conf`.

## i3-config

Configuration for the [i3](https://i3wm.org) tiling window manager.

Save this as `~/.config/i3/config` but change the parts relevant to your system.

Resources I found helpful:

- [An article on i3wm setup](https://tildeho.me/windowmanager-setup/)
- [i3 User's Guide](https://i3wm.org/docs/userguide.html)

## sway-config

On Linux I use [sway](https://swaywm.org) which is a [Wayland](https://wayland.freedesktop.org) compositor that uses a similar configuration to i3.

Save this as `~/.config/sway/config` but change the parts relevant to your system.

## Also I use...

Firefox add-ons:
- [QR Code](https://addons.mozilla.org/en-US/firefox/addon/qr-code-address-bar/)
- [URL Parameters Editor](https://addons.mozilla.org/en-US/firefox/addon/url-parameters-editor/)
- [Pentadactyl](http://bug.5digits.org/pentadactyl/) (used to work with Firefox back in the day but is now availabe as a [Palemoon add-on](https://addons.palemoon.org/addon/pentadactyl-community/))

## Contributing

If you can improve something, by all means open a pull request.
