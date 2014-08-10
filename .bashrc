alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

function md() {
  mkdir -p "$@" && cd "$@"
}

function f() {
  find . -name "$1"
}

# Get Sublime: http://www.sublimetext.com/
function s() {
  if [ $# -eq 0 ]; then
    subl .
  else
    subl "${@}"
  fi
}

# Get NERDTree: https://github.com/scrooloose/nerdtree
function v() {
  if [ $# -eq 0 ]; then
    vim +NERDTree
  else
    vim "${@}"
  fi
}

# PHP 5.4.0+: http://j.mp/php-s
function pserv() {
  local port="${1:-8888}"
  php -S "0.0.0.0:${port}"
}

# These pesky files are like a plague
alias rmds="find . -name '*.DS_Store' -type f -ls -delete"

# Show local IP address
function getip() {
  ipconfig getifaddr ${1:-en1}
}

#
# OS X goodness
#

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

#
# Fancy multiline prompt
#
if [[ $TERM == screen ]] ; then
  PS1='\[\033k\033\\\]' # relay prompt to GNU Screen
else
  PS1=""
fi

PS1="\n\[\e[31;1m\]┌───=[ \[\e[39;1m\]\u \[\e[31;1m\]:: \[\e[33;1m\]\h \[\e[31;1m\]-( \[\e[39;1m\]\j\[\e[31;1m\] )-[ \[\e[39;1m\]\w\[\e[31;1m\] ]\n\[\e[31;1m\]└──( \[\e[0m\]$PS1"