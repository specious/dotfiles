browser=firefox-developer-edition
alias www=$browser

# Enhanced su (su that reads this file)
ssu() {
  su -c "zsh -ic $@"
}

# Decimal to hex
d2h() {
  printf '%x\n' $1
}

# Decimal to hex (upper case)
d2H() {
  printf '%X\n' $1
}

# Hex to decimal
h2d() {
  echo $((16#$1))
}

# Decimal to binary
d2b() {
  echo "ibase=10;obase=2;$1" | bc
}

# Binary to decimal
b2d() {
  echo $((2#$1))
}

# Hex to binary
h2b() {
  hex2base 2 $1
}

# Hex to arbitrary base, e.g.: hex2base 10 ff
hex2base() {
  # Target base must be written in the input base
  tobase=$(d2H $1)

  # Input to 'bc' must be upper case
  echo "ibase=16;obase=$tobase;$(echo $2 | tr '[a-z]' '[A-Z]')" | bc
}

# Create a new directory and enter it
md() {
  mkdir -p "$1" && cd "$1"
}

# Find file
ff() {
  find . -iname "$1"
}

# Unzip and delete zip file
unzipp() {
  unzip "$1" && rm -v "$1"
}

# Make tarball
mktar() {
  for f in $@; do
    tar cvzf "$f.tar.gz" $f
  done
}

# fzf file contents (fuzzy search)
f() {
  cat $1 | fzf
}

# Shuffle input, e.g. ls | shuffle
shuffle() {
  perl -MList::Util=shuffle -e 'print shuffle <>;'
}

# Downsample video
ffdown() {
  ffmpeg -i "$1" -vf scale=iw/2:-1 "$2"
}

# Convert file to mp4, e.g. ff2mp4 file.mkv file.mp4
ff2mp4() {
  ffmpeg -i "$1" -c:v mpeg4 -b:v 5000k "$2"
}

# Current working directory of a process, e.g. pwdx `pgrep firefox`
pwdx() {
  lsof -a -p $1 -d cwd -Fn | cut -c2- | grep -v $1
}

# Start HTTP server
pserv() {
  port=${1:-8888}
  root=${2:-./}
  php -S "0.0.0.0:${port}" -t $root
}

# Start HTTP server and open in browser
pservo() {
  port=${1:-8888}
  www http://localhost:${port}
  pserv $@
}

# Get local IP address
getip() {
  hostname -i
}

# Look up DNS records, e.g. dns fb.me aaaa
dns() {
  # If unspecified, default record type is A
  rec="${2:-A}"
  dig +nocmd $1 $rec @8.8.8.8 +multiline +noall +answer
}

# Render HTML
html() {
  links -dump "data:text/html,$1"
}

# Open HTML from stdin in browser, e.g. cat index.html | viewhtml w3m
viewhtml() {
  app=${1:-elinks}
  $app "data:text/html;base64,$(base64 -w 0 <&0)"
}

# Show server SSL certificate in plain text, e.g. sslplain reddit.com:443
viewssl() {
  openssl s_client -connect $@ 2>&1 < /dev/null | sed -n '/-----BEGIN/,/-----END/p' | openssl x509 -noout -text
}

# Make text URL-safe
urlsafe() {
  for a in "$@"; do
    echo $(php -r "echo urlencode('$a');")
  done
}

# Make a query URL-safe, preserving "quoted terms"
urlsafeq() {
  for a in "$@"; do
    case $a in
      *[" "]* ) echo $(urlsafe "\"$a\"")
        ;;
      *)
        echo $a
    esac
  done
}

# Build a search query URL fragment
qterms() {
  t=$IFS
  IFS=$'\n'
  terms=($(urlsafeq $@))
  IFS="+"
  echo "${terms[*]}"
  IFS=$t
}

# Launch a web search from a terminal
#   e.g. SEARCHSITE="https://ddg.gg" websearch metabolic pathways
websearch() {
  [[ $# -eq 0 ]] && links $SEARCHSITE || links "$SEARCHSITE?q=$(qterms $@)"
}

# DuckDuckGo search
ddg() {
  SEARCHSITE=https://lite.duckduckgo.com/lite/
  websearch $@
}

# Google search
gg() {
  SEARCHSITE=https://www.google.com/search
  websearch $@
}

# DuckDuckGo query link
ddgl() {
  echo "https://ddg.gg?q=$(qterms $@)"
}

# Google query link
ggl() {
  echo "https://www.google.com/search?q=$(qterms $@)"
}

# Google image search query link
ggil() {
  echo "$(ggl $@)&tbm=isch"
}

# Open DuckDuckGo search in default browser
ddgo() {
  www `ddgl $@`
}

# Open Google search in default browser
ggo() {
  www `ggl $@`
}

# Shorten URL with is.gd
isgd() {
  curl -s "https://is.gd/api.php?longurl=${1}"
  echo
}

# Publish to ix, e.g. cat ~/.bashrc | ix
ix() {
  curl -F 'f:1=<-' ix.io
}

# Shorten github URL: http://git.io/help
gitio() {
  curl -i http://git.io -F "url=${1}" -F "code=${2}"
}

# Show current branch or commit ref
gbb() {
  git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD
}

# 'git stash' but keeping the working directory untouched (doesn't stash untracked files)
gsave() {
  # Print usage
  [ $# -eq 0 ] && echo "$0 <message>" && kill -INT $$

  # Spaces must be in quotes
  [ $# -gt 1 ] && echo "Put the message in quotes" && kill -INT $$

  git stash store $(git stash create $@) -m "On $(gbb): $@"

  # Show the new entry
  git --no-pager stash list -1
}

# 'git stash' but keeping the working directory untouched (stash includes untracked files)
gsaveu() {
  # Print usage
  [ $# -eq 0 ] && echo "$0 <message>" && kill -INT $$

  # Spaces must be in quotes
  [ $# -gt 1 ] && echo "Put the message in quotes" && kill -INT $$

  # Stash everything including untracked files
  git stash --include-untracked --keep-index -m $@

  # Restore working tree
  git stash apply --quiet

  echo

  # Show the commits that make up the stash 
  git --no-pager log stash@{0} --oneline -3
}

# History of a file's size by revision, e.g. git-filehist yarn.lock
git-filehist() {
  for rev in $(git rev-list HEAD -- $1); do
    git ls-tree -r -l $rev $1
  done
}

# gdbytes <ref1> <ref2> <path>
#
# Show difference in size between two versions of a file in git
#
# Difference since previous commit: gdbytes @~ @ index.html
gdbytes() {
  echo "$(git cat-file -s $1:$3) -> $(git cat-file -s $2:$3)"
}

# Pretty print json
json() {
  jq < $1
}

# Print file contents in base64 format
basef() {
  base64 -w0 < $1
}

# Show a QR code of file contents encoded in base64
qrf() {
  basef $1 | qrcode-terminal
}

# Repeat a string "n" times e.g. repeatstr abc 3
#
# Solution: https://stackoverflow.com/a/5349842/
repeatstr() {
  printf "%.0s$1" $(seq 1 $2)
}

# Reindent file that uses spaces
#   e.g. reindent 2 4 index.html
#   e.g. cat index.html | reindent 2 4
#
# Solution: https://unix.stackexchange.com/a/47210/
reindent() {
  if [[ $# -gt 2 ]]; then
    f=$(mktemp)
    cat $3 | reindent $1 $2 > $f && mv $f $3
  else
    sed "h;s/[^ ].*//;s/$(repeatstr ' ' $1)/$(repeatstr ' ' $2)/g;G;s/\n *//"
  fi
}

# Get repository for NPM package
nrepo() {
  npm v $1 repository.url
}

# Get homepage for NPM package
nurl() {
  npm v $1 homepage
}

# Set title in GNU Screen
stitle() {
  echo -e '\033k'$1'\033\\'
}

# Set environment variable in current GNU Screen session
#
# (it will only take effect when new windows are opened)
ssetenv() {
  screen -X setenv $1 $2
}

# Execute a process in each window inside a GNU Screen session
#
# saexec <session> <executable> [<args>]
#
# Inside current session:
#   saexec <executable> [<args>]
saexec() {
  if [ -n "$STY" ]; then
    screen -X at '#' exec $@
  else
    screen -S $1 -X at '#' exec "${@:2}"
  fi
}

# Play youtube in the framebuffer console
yplay() {
  youtube-dl -o - $1 | mplayer -vo fbdev2 -
}

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="ls"
alias l.="ls -d .*"
alias la="ls -a"
alias ll="ls -l"
alias lR="ls -R"
alias lla="ls -la"
alias llh="ls -lh"
alias rmd="rmdir"
alias lstree="ls -lR"
alias tree="tree -C"
alias sa="screen -S"
alias sx="screen -x"
alias sls="screen -ls"
alias t="screen"
alias pstree="pstree -h"
alias dush="du -sh .[!.]* *"
alias to="rlwrap trans -t"
alias un="rlwrap trans -s"
alias qr="qrcode-terminal"
alias o7="optipng -o 7"
alias jpego="jpegtran -copy none -optimize -perfect"
alias yget="youtube-dl -o '%(title)s.%(ext)s'"
alias yget-mp3="yget -x --audio-format mp3 --add-metadata"
alias y3="yget-mp3"
alias wwwrip="wget --recursive --no-clobber --page-requisites --html-extension --convert-links --no-parent"
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ssl="openssl s_client -connect"
alias jp2a="jp2a --colors"
alias bitly="bitly-client"
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
alias vplay="mplayer -vo fbdev2"
alias cplay="mpv -vo caca"
alias mix="pulsemixer"
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
alias gce="git commit"
alias gcm="git commit -m"
alias gcme="git commit -e -m"
alias gc1="git commit --amend --no-edit"
alias gcm1="git commit -m --amend"
alias gc1e="git commit --amend"
alias gcse="git commit -S"
alias gcsm="git commit -S -m"
alias gcsme="git commit -S -e -m"
alias gcs1="git commit -S --amend --no-edit"
alias gcsm1="git commit -S -m --amend"
alias gcs1e="git commit -S --amend"
alias gf="git fetch"
alias gp="git pull"
alias gpa="git pull --rebase --autostash"
alias gpush="git push"
alias gpushf="git push --force"
alias undopush="git push -f origin HEAD^:master"

alias sss=". /etc/sh"

# `cat` with syntax highlighting
#
# Requires Pygments package: pip install Pygments
alias c='pygmentize -O style=monokai -f console256 -g'

# Depends on specious/elm-format fork (official mainline does not support configurable tab size)
alias elm-format="elm-format --tabsize 2 --yes"

# Enable git to find gpg
export GPG_TTY=$(tty)

# v is symlinked in /usr/local/bin to a specific version of vim
EDITOR=v

# Specific local configuration
. /etc/sh-local.sh