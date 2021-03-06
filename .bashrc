#
# File system
#

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

function md () {
  mkdir -p "$@" && cd "$@"
}

function f () {
  find . -name "$1"
}

# These .DS_Store files are like a plague
alias rmds="find . -name '*.DS_Store' -type f -ls -delete"

#
# Conversions
#

# Base 10 to binary
function d2b () {
  echo "ibase=10;obase=2; $@" | bc
}

# Hex to binary
function h2b () {
  # input to 'bc' must be upper case
  echo "ibase=16;obase=2; $(echo $@ | tr '[a-z]' '[A-Z]')" | bc
}

#
# Network
#

# Local IP address
function getip() {
  ipconfig getifaddr ${1:-en1}
}

# WAN IP address
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"

function urlencode () {
  for a in "$@"; do
    echo $(php -r "echo urlencode('$a');")
  done
}

#
# URL convenience
#

# URL encode parameters, preserving "quoted terms"
function qterms () {
  for a in "$@"; do
    case $a in
      *[" "]* ) echo $(urlencode "\"$a\"")
        ;;
     *)
        echo $a
    esac
  done
}

# Google query builder
function goog () {
  IFS=$'\n'
  terms=($(qterms $@))
  IFS="+"
  echo "https://www.google.com/#q=${terms[*]}"
  IFS=$' \t\n'
}

# Google query builder (image search)
function googi () {
  IFS=
  echo "$(goog $@)&tbm=isch"
  IFS=$' \t\n'
}

#
# git enhancements
#

# history of a file's size by revision
function git-filehist() {
  for rev in $(git rev-list HEAD -- $1); do
    git ls-tree -r -l $rev $1
  done
}

#
# Launch stuff
#

# Quick PHP server - requires PHP 5.4.0+: http://j.mp/php-s
function pserv () {
  local port="${1:-8888}"
  php -S "0.0.0.0:${port}"
}

# Quick SublimeText ( http://www.sublimetext.com/ )
function s () {
  if [ $# -eq 0 ]; then
    subl .
  else
    subl "${@}"
  fi
}

#
# Fancy two-line prompt with git integration
#
# ┌───=[ specious :: sharp -( 0 )-[ ~ ]-( master )
# └──(
#

parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -1) != "nothing to commit, working tree clean" ]] && echo "*"
}

parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

show_git_prompt () {
  git branch 2>/dev/null 1>&2 && echo -e "-( \e[34;1m$(parse_git_branch)\e[31;1m )"
}

if [[ -n $(type -t git) ]] ; then
  PS1="\$(show_git_prompt)"
else
  PS1=
fi

PS1="
\[\e[31;1m\]┌───=[ \[\e[39;1m\]\u\[\e[31;1m\] :: \[\e[33;1m\]\h\[\e[31;1m\] ]-( \[\e[39;1m\]\j\[\e[31;1m\] )-[ \[\e[39;1m\]\w\[\e[31;1m\] ]$PS1
\[\e[31;1m\]└──( \[\e[0m\]"

# Display running command in GNU Screen window status
#
# In .screenrc, set: shelltitle "( |~"
#   See: http://aperiodic.net/screen/title_examples#setting_the_title_to_the_name_of_the_running_program
case $TERM in screen*)
  PS1=${PS1}'\[\033k\033\\\]'
esac

#
# Mac OS X
#

# Quit an application from the command line
function quit () {
  for app in $*; do
    osascript -e 'quit app "'$app'"'
  done
}

# List connected USB devices
function lsusb () {
  ioreg -p IOUSB -w 0
}

# Control your wireless network adapter
alias air="networksetup -setairportpower en1" # on | off
alias airup="air off; air on"
alias airlist="networksetup -listpreferredwirelessnetworks en1"
alias airdel="networksetup -removepreferredwirelessnetwork en1"

# Lock your computer
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Turn on screensaver
alias saver="open -a ScreenSaverEngine"

# Quick preview
alias ql="qlmanage -p 2>/dev/null"