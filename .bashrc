alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# these pesky files are like a plague
alias rmds="find . -name '*.DS_Store' -type f -ls -delete"

#
# fancy multiline prompt
#
if [[ $TERM == screen ]] ; then
  PS1='\[\033k\033\\\]' # relay prompt to GNU Screen
else
  PS1=""
fi

PS1="\n\[\e[31;1m\]┌───=[ \[\e[39;1m\]\u \[\e[31;1m\]:: \[\e[33;1m\]\h \[\e[31;1m\]-( \[\e[39;1m\]\j\[\e[31;1m\] )-[ \[\e[39;1m\]\w\[\e[31;1m\] ]\n\[\e[31;1m\]└──( \[\e[0m\]$PS1"