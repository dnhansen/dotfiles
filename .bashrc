# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Set history length
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

mkdircd() {
    mkdir $1
    cd $1
}

alias gcc89="gcc -std=c89 -Wall -Wextra -pedantic"
alias gcc99="gcc -std=c99 -Wall -Wextra -pedantic"


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Prompt

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"

function timer_now {
    date +%s%3N # Get timestamp in milliseconds
}

function timer_start {
    timer=${timer:-$(timer_now)} # Set timer to timer_now if it hasn't already been set
}

function timer_stop {
    local ms=$(($(timer_now) - $timer))
    local s=$((ms / 1000))
    if ((s > 0)); then
        timer_show="${s}s"
    else
        timer_show="${ms}ms"
    fi
    unset timer
}

trap 'timer_start' DEBUG

PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local EXIT="$?"
    PS1=""

    local RESETCOL='\[\e[0m\]'
    local TIMECOL='\[\e[30;104m\]'
    local ERRORCOL='\[\e[31m\]'
    local USERCOL='\[\e[92m\]'
    local PROMPTCOL='\[\e[0m\]'
    local HOSTCOL='\[\e[35m\]'
    local PATHCOL='\[\e[36m\]'
    local ATCOL='\[\e[2;37m\]'
    local GITCOL='\[\e[2;37m\]'
    local TIMERCOL='\[\e[33m\]'

    local ERROR=""
    if [ $EXIT != 0 ]; then
        ERROR+="${ERRORCOL}exit ${EXIT}${RESETCOL}   "
    fi

    timer_stop

    PS1+="${ERROR}${TIMERCOL}took ${timer_show}${RESETCOL}\n\n${TIMECOL} \A ${RESETCOL} ${PATHCOL}\w${RESETCOL} ${GITCOL}$(__git_ps1 "(%s)")${RESETCOL}\n${PROMPTCOL}\$${RESETCOL} "
}
