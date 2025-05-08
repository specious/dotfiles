browser=firefox-developer-edition

alias www="$browser"

# Convert decimal to hex
function d2h() {
  printf '%x\n' "$1"
}

# Convert decimal to hex (upper case)
function d2H() {
  printf '%X\n' "$1"
}

# Convert hex to decimal
function h2d() {
  echo $((16#$1))
}

# Convert decimal to binary
function d2b() {
  echo "ibase=10;obase=2;$1" | bc
}

# Convert binary to decimal
function b2d() {
  echo $((2#$1))
}

# Convert hex to binary
function h2b() {
  hex2base 2 "$1"
}

# Convert hex to arbitrary base, e.g.: hex2base 10 ff
function hex2base() {
  # Target base must be written in the input base
  tobase=$(d2H "$1")

  # Input to 'bc' must be upper case
  echo "ibase=16;obase=$tobase;$(echo "$2" | tr '[a-z]' '[A-Z]')" | bc
}

# Create a new directory and enter it
function md() {
  mkdir -p "$1" && cd "$1"
}

# Find file (exact)
function f() {
  find . -iname "$1"
}

# Find file (fuzzy)
function ff() {
  find . -iname "*$1*"
}

# Unzip and delete zip file
function unzipp() {
  unzip "$1" && rm -v "$1"
}

# Make .tar.gz tarballs of one or more directories
function mktar() {
  for f in "$@"; do
    tar cvzf "$f.tar.gz" "$f"
  done
}

# Fuzzy search file contents with fzf
function fz() {
  fzf < "$1"
}

# Shuffle input, e.g. ls | shuffle
function shuffle() {
  perl -MList::Util=shuffle -e 'print shuffle <>;'
}

# Downsample video
function ffdown() {
  ffmpeg -i "$1" -vf scale=iw/2:-1 "$2"
}

# Convert file to mp4, e.g. ff2mp4 file.mkv file.mp4
function ff2mp4() {
  ffmpeg -i "$1" -c:v mpeg4 -b:v 5000k "$2"
}

# Current working directory of a process
#
# E.g.:
# - pwdx firefox
# - pwdx 10081
function pwdx() {
  [ -z "$1" ] && echo "Provide a process name or ID" >&2 && return 1

  if [[ "$1" =~ ^[0-9]+$ ]]; then
    echo -n "$1: "
    lsof -a -p "$1" -d cwd -Fn | cut -c2- | grep -v "$1"
  else
    local pids
    pids=($(pgrep "$1"))

    if [[ ${#pids[@]} -ne 0 ]]; then
      for pid in $pids; do
        pwdx "$pid"
      done
    else
      echo "No process found with this name: $1" >&2
      return 1
    fi
  fi
}

# Start HTTP server
function pserv() {
  local port=${1:-8888}
  local root=${2:-./}
  php -S "0.0.0.0:${port}" -t "$root"
}

# Start HTTP server and open in browser
function pservo() {
  local port=${1:-8888}
  www http://localhost:${port}
  pserv "$@"
}

# Get local IP address
function getip() {
  hostname -i
}

# Look up DNS records, e.g. dns fb.me aaaa
function dns() {
  [[ -z "$1" ]] && echo "Usage, e.g.: $0 microsoft.com aaaa" && return 1

  # If unspecified, default record type is A
  local rec="${2:-A}"
  dig +nocmd "$1" "$rec" @8.8.8.8 +multiline +noall +answer
}

# Render HTML
function renderhtml() {
  links -dump "data:text/html,$1"
}

# Open HTML from stdin in browser, e.g. cat index.html | viewhtml w3m
function viewhtml() {
  ${1:-elinks} "data:text/html;base64,$(base64 -w 0 <&0)"
}

# Show server SSL certificate in plain text, e.g. sslplain reddit.com:443
function viewssl() {
  openssl s_client -connect "$@" 2>&1 < /dev/null | sed -n '/-----BEGIN/,/-----END/p' | openssl x509 -noout -text
}

# Make strings URL-safe
function urlsafe() {
  for a in "$@"; do
    php -r "echo urlencode('$a');" && echo
  done
}

# Make strings URL-safe, preserving text with spaces as "quoted text"
#
# In other words:
#
#   urlsafeq "now reticulating splines"
#
# Yields:
#
#   %22now+reticulating+splines%22
function urlsafeq() {
  for a in "$@"; do
    case $a in
      *[" "]* ) urlsafe "\"$a\""
        ;;
      *)
        echo "$a"
    esac
  done
}

# Build a search query URL fragment
function qterms() {
  t=$IFS
  IFS=$'\n'
  terms=($(urlsafeq "$@"))
  IFS="+"
  echo "${terms[*]}"
  IFS=$t
}

# Launch a web search from a terminal
#   e.g. SEARCHSITE="https://ddg.gg" websearch metabolic pathways
function websearch() {
  [ -z "$1" ] && links "$SEARCHSITE" || links "$SEARCHSITE?q=$(qterms "$@")"
}

# DuckDuckGo search
function ddg() {
  SEARCHSITE=https://lite.duckduckgo.com/lite/
  websearch "$@"
}

# DuckDuckGo search link
function ddgl() {
  echo "https://ddg.gg?q=$(qterms "$@")"
}

# DuckDuckGo image search link
function ddgli() {
  echo "$(ddgl "$@")&ia=images&iax=images"
}

# Open DuckDuckGo search in browser
function ddgo() {
  www $(ddgl "$@")
}

# Google search
function gg() {
  SEARCHSITE=https://www.google.com/search
  websearch "$@"
}

# Google search link
function ggl() {
  echo "https://www.google.com/search?q=$(qterms "$@")"
}

# Google image search query link
function ggli() {
  echo "$(ggl "$@")&tbm=isch"
}

# Open Google search in browser
function ggo() {
  www $(ggl "$@")
}

# Shorten URL with is.gd
function isgd() {
  curl -s "https://is.gd/api.php?longurl=${1}" && echo
}

# Publish stdin to ix, e.g. cat ~/.bashrc | ix (might be defunct)
# function ix() {
#   curl -F 'f:1=<-' ix.io
# }

# Publish stdin to 0x0.st, e.g. cat ~/.bashrc | 0x0
function 0x0() {
  if [ -p /dev/stdin ]; then
    curl -F "file=@-" https://0x0.st
  elif [[ -n "$1" && -f "$1" ]]; then
    curl -F "file=@$1" https://0x0.st
  else
    echo "Usage: $0 <file> or pipe data to the script"
    return 1
  fi
}

# Shorten github URL: http://git.io/help
function gitio() {
  curl -i http://git.io -F "url=${1}" -F "code=${2}"
}

# Show current branch or commit ref
function gref() {
  git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD
}

# List git branches by recency of commit activity
#
# Usage:
#   gblist
#     List local branches with recent commits
#   gblist origin
#     List remote branches with recent commits
#   gblist origin 10
#     List 10 latest remote branches with recent commits
function gblist() {
  local refs

  [ -z "$1" ] && refs="refs/heads/"
  [ -n "$1" ] && refs="refs/remotes/$1/"

  local cmd="git for-each-ref --sort=-committerdate --format='%(refname:short) - %(committerdate:relative)' $refs"

  [ -n $2 ] && eval "$cmd | head -n $2" || eval "$cmd"
}

# 'git stash' without disturbing the working directory (doesn't stash untracked files)
function gsave() {
  # Print usage
  [ -z "$1" ] && echo "$0 <message>" && return 1

  # Spaces must be in quotes
  [ $# -gt 1 ] && echo "Put the message in quotes" && return 1

  git stash store "$(git stash create "$1")" -m "On $(gref): $1"

  # Show the new entry
  git --no-pager stash list -1
}

# 'git stash' without disturbing the working directory (stash with untracked files)
function gsaveu() {
  # Print usage
  [ -z "$1" ] && echo "$0 <message>" && return 1

  # Spaces must be in quotes
  [ $# -gt 1 ] && echo "Put the message in quotes" && return 1

  # Stash everything including untracked files
  git stash --include-untracked --keep-index -m "$1"

  # Restore working tree
  git stash apply --quiet

  echo

  # Show the commits that make up the stash
  git --no-pager log stash@{0} --oneline -3
}

# History of a file's size by revision, e.g. git-filehist yarn.lock
function git-filehist() {
  for rev in $(git rev-list HEAD -- "$1"); do
    git ls-tree -r -l "$rev" "$1"
  done
}

# gdbytes <ref1> <ref2> <path>
#
# Show difference in size between two versions of a file in git
#
# Difference since previous commit: gdbytes @~ @ index.html
function gdbytes() {
  echo "$(git cat-file -s "$1":"$3") -> $(git cat-file -s "$2":"$3")"
}

# Pretty print json
function json() {
  jq < "$1"
}

# Print file contents in base64 format
function basef() {
  base64 -w0 < "$1"
}

# Show a QR code of file contents encoded in base64
function qrf() {
  basef "$1" | qrcode-terminal
}

# Repeat a string "n" times e.g. repeatstr abc 3
#
# From: https://stackoverflow.com/questions/5349718/how-can-i-repeat-a-character-in-bash/5349842#comment31668137_5349842
function repeatstr() {
  printf "%.0s$1" $(seq 1 "$2")
}

# Reindent file that already uses spaces for indentation
#   e.g. retab 2 4 index.html
#   e.g. cat index.html | retab 2 4
#
# Based on: https://unix.stackexchange.com/questions/47171/sed-convert-4-spaces-to-2/47210#47210
function retab() {
  if [[ $# -gt 2 ]]; then
    f=$(mktemp)
    retab "$1" "$2" < "$3" > "$f" && mv "$f" "$3"
  else
    sed "h;s/[^ ].*//;s/$(repeatstr ' ' "$1")/$(repeatstr ' ' "$2")/g;G;s/\n *//"
  fi
}

# Get repository for NPM package
function nrepo() {
  npm v "$1" repository.url
}

# Get homepage for NPM package
function nurl() {
  npm v "$1" homepage
}

# Set title in GNU Screen
function stitle() {
  echo -e '\033k'"$1"'\033\\'
}

# Set environment variable in current GNU Screen session
#
# (it will only take effect when new windows are opened)
function ssetenv() {
  screen -X setenv "$1" "$2"
}

# Execute a process in each window inside a GNU Screen session
#
# saexec <session> <executable> [<args>]
#
# Inside current session:
#   saexec <executable> [<args>]
function saexec() {
  if [ -n "$STY" ]; then
    screen -X at '#' exec "$@"
  else
    screen -S "$1" -X at '#' exec "${@:2}"
  fi
}

# Play youtube in the framebuffer console
function yplay() {
  youtube-dl -o - "$1" | mplayer -vo fbdev2 -
}

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="ls"
alias l.="ls -d .*"
alias la="ls -a"
alias ldl="ls -d */"
alias lr="ls -R"
alias ll="ls -l"
alias lla="ls -la"
alias llh="ls -lh"
alias lldl="ls -ld */"
alias rmd="rmdir"
alias lstree="ls -lR"
alias tree="tree -C"
alias ssa="screen -S"
alias ssx="screen -x"
alias ssls="screen -ls"
alias tt="screen"
alias sa="tmux new-session -A -s" # create or attach to session
alias sx="tmux new-session -t" # new grouped session connected to an existing session
alias t="tmux new-window"
alias sls="tmux list-sessions"
alias pstree="pstree -h"
alias dush="du -sh .[!.]* *"
alias to="trans -I -t" # install translate-shell
alias un="trans -I -s"
alias qr="qrcode-terminal" # npm i -g qrcode-terminal
alias o7="optipng -o 7"
alias jpego="jpegtran -copy none -optimize -perfect"
alias yget="yt-dlp -o '%(title)s.%(ext)s'"
alias yget-mp3="yget -x --audio-format mp3 --add-metadata"
alias y3="yget-mp3"
alias jj="yq -P -oy" # Nicely print json or yml as yml
alias wwwrip="wget --recursive --no-clobber --page-requisites --html-extension --convert-links --no-parent"
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ssl="openssl s_client -connect"
alias jp2a="jp2a --colors"
alias bitly="bitly-client" # npm i -g bitly-client
alias jmp="bitly-client --domain j.mp"
alias fzp="fzf +s --tac"
alias sorta='grep -o . | sort | tr -d "\n"' # sort string alphabetically, e.g. echo cbda | sorta
alias stripcolor="sed -E 's/[[:cntrl:]]\[[0-9]{1,3}m//g'" # From: https://stackoverflow.com/a/46262090/
alias jp="json_pp | c" # cat data.json | jp
alias rmds="find . -name '*.DS_Store' -type f -ls -delete"
alias sfd="setfont -d"
alias saver="xscreensaver-command -activate"
alias nn="node"
alias dos="dosbox-x -fs -nomenu"
alias dockerip="docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
alias ii="ping -c 1 8.8.8.8"
alias iii="ping 8.8.8.8"

alias gs="git status -s"
alias gr="git remote"
alias gb="git --no-pager branch"
alias gstat="git show --stat --pretty=format:" # Show files changed in commit
alias gl="git log"
alias gls="git log --show-signature"
alias gll="git --no-pager log --oneline"
alias glg="git --no-pager log --oneline --graph"
alias glll="git --no-pager log --format=\"%C(yellow)%h%C(reset) %s\""
alias glla="git --no-pager log --format=\"%C(yellow)%h%C(reset) %C(blue)%an%C(reset) %s\""
alias gllf="gll --format="%ad" --date=short --" # Show when a file was last touched
alias glf="git rev-list @ --oneline" # List commits that changed a file
alias gd="git diff"
alias gdc="git diff --cached"
alias gdw="git diff --no-ext-diff --word-diff=color"
alias gdf="git diff --color | diff-so-fancy | less -RFX"
alias gdstat="git --no-pager diff --stat"
alias glst="git ls-tree -rl HEAD"
alias glst1="git ls-tree -rl"
alias gsl="git --no-pager stash list"
alias gss="git --no-pager stash show -u"
alias gco="git checkout"
alias ga="git add"
alias gua="git restore --staged"
alias guaa="git reset HEAD"
alias gcf="git clean -f"
alias gconf="git config -l"
alias gce="git commit"
alias gcm="git commit -m"
alias gcme="git commit -e -m"
alias gc1="git commit --amend --no-edit"
alias gc1m="git commit --amend -m"
alias gc1e="git commit --amend"
alias gcse="git commit -S"
alias gcsm="git commit -S -m"
alias gcsme="git commit -S -e -m"
alias gc1s="git commit -S --amend --no-edit"
alias gc1sm="git commit -S --amend -m"
alias gc1se="git commit -S --amend"
alias gf="git fetch"
alias gp="git pull"
alias gpa="git pull --rebase --autostash"
alias gpush="git push"
alias gpushf="git push --force"
alias undopush="git push -f origin HEAD^:master"

# Decode JWT header, payload and expiration time
alias jwth="jq -R 'split(\".\") | .[0] | @base64d | fromjson'"
alias jwtp="jq -R 'split(\".\") | .[1] | @base64d | fromjson'"
alias jwtexp="jq -R 'split(\".\") | .[1] | @base64d | fromjson | .exp' | xargs -I {} sh -c 'echo -e \"UTC: \$(date -u -d @{})\nLocal: \$(date -d @{})\"'"

# Reload shell configuration
alias sss=". /etc/sh"

# Don't paginate if less than a page of content
export LESS="-F -X $LESS"

# Color `cat` with syntax highlighting
#
# Requires Pygments package: pip install Pygments
alias c='pygmentize -O style=monokai -f console256 -g'

# Depends on the specious/elm-format fork (official mainline does not support configurable tab size)
alias elm-format="elm-format --tabsize 2 --yes"

# This makes GPG pin entry not crash when signing git commits
export GPG_TTY=$(tty)

# v is symlinked in /usr/local/bin to a specific version of (n)vim
export EDITOR=v