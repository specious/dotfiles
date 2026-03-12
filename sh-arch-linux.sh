#
# Shell configuration specific to Arch Linux
#

# Show package build script
function pkg () {
  asp show $1 | c
}

# Show binaries installed by a package
function plbin () {
  pacman -Ql $1 | ag -sw bin
}

# List installed packages for which a given package is an optional dependency
function poptionalof() {
  [ $# -eq 0 ] && echo "Specify a package that might be an optional dependency of one or more installed packages" && return 1

  echo "Looking for installed packages which list $1 as their optional dependency... (this might take a while)"
  echo

  comm -12 <(pacman -Qq --color never | sort) <(for pkg in $(pacman -Qq); do
    if pacman -Qi "$pkg" | grep -q "Optional Deps.*$1"; then
      echo "$pkg"
    fi
  done | sort)
}

# Directly boot kernel image
function kboot() {
  [ $# -eq 0 ] && echo "Specify a kernel image to boot" && return 1

  sudo kexec -l "$1" --reuse-cmdline && systemctl kexec
}

alias pi="yay -Sii"
alias pl="yay -Ql"
alias po="yay -Qo"
alias pfiles="pkgfile -l"
alias yup="yay -Syu"

alias regrub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
