# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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













# PS1="|\t|\u@\h \w\$ "
# PS1="\u@\h:\w\$ "
# export PS1

hr() { i=1; while [ $i -le $COLUMNS ] ; do i=$((i+1)); printf "%s" "${1:-=}"; done ; }

# PROMPT_COMMAND=__prompt_command

# __prompt_command() {
#     local EXIT="$?"
#     PS1=""

#     local DEFCOL='\[\e[0m\]'        # white

#     local ERRORCOL='\[\e[0;31m\]'   # red
#     local USERCOL='\[\e[0;32m\]'    # green
#     local PROMPTCOL='\[\e[1;33m\]'  # yellow
#     local HOSTCOL='\[\e[1;34m\]'    # blue
#     local PATHCOL='\[\e[0;36m\]'    # cyan

#     if [ $EXIT != 0 ]; then
#         PS1+="${ERRORCOL}[${EXIT}] "
#     fi

#     PS1+="${USERCOL}\u${DEFCOL}@${HOSTCOL}\h${DEFCOL}:${PATHCOL}\w${PROMPTCOL}\$ ${DEFCOL}"
# }
# https://stackoverflow.com/a/62175983



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

    # PS1+="\n${TIMECOL}\A  ${PATHCOL}\w  ${GITCOL}$(__git_ps1 "%s")\n${ERROR}${USERCOL}\u${ATCOL}@${HOSTCOL}\h ${PROMPTCOL}\$${RESETCOL} "
    # PS1+="\n${TIMECOL}\A ${PATHCOL}\w ${GITCOL}$(__git_ps1 "(%s)")\n${ERROR}${TIMERCOL}${timer_show} ${PROMPTCOL}\$${RESETCOL} "
    PS1+="${ERROR}${TIMERCOL}took ${timer_show}${RESETCOL}\n\n${TIMECOL} \A ${RESETCOL} ${PATHCOL}\w${RESETCOL} ${GITCOL}$(__git_ps1 "(%s)")${RESETCOL}\n${PROMPTCOL}\$${RESETCOL} "
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

mkdircd() {
    mkdir $1
    cd $1
}

alias gcc89="gcc -std=c89 -Wall -Wextra -pedantic"
alias gcc99="gcc -std=c99 -Wall -Wextra -pedantic"
