###############################################################################
[ -f /etc/bashrc ] && . /etc/bashrc

###############################################################################
PATH="$HOME/.$(whoami)/bin"
PATH="$PATH:/usr/local/opt/coreutils/libexec/gnubin"
PATH="$PATH:/usr/local/opt/curl/bin"
PATH="$PATH:/usr/local/opt/file-formula/bin"
PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH

###############################################################################
MANPATH="/usr/local/opt/coreutils/libexec/gnuman"
MANPATH="$MANPATH:/usr/local/share/man"
MANPATH="$MANPATH:"
export MANPATH

###############################################################################
export DIR_PJ="$HOME/Workspace"
export DIR_VV="$HOME/.$(whoami)/venv"
[ ! -z $(which pipenv 2>/dev/null) ] && export WORKON_HOME=${DIR_VV}

###############################################################################
if [ -d /usr/local/etc/profile.d ]; then
    for ish in /usr/local/etc/profile.d/*.sh; do
        source $ish
    done
fi
if [ -d /usr/local/etc/bash_completion.d ]; then
    for ish in /usr/local/etc/bash_completion.d/*; do
        source $ish
    done
fi
if [ -d ${HOME}/.alex/etc ]; then
    for ish in ${HOME}/.alex/etc/*_rc.sh; do
        source $ish
    done
fi
unset ish

###############################################################################
alias ls='/usr/local/bin/gls -F --color=auto --group-directories-first'
alias la='/usr/local/bin/gls -aF --color=auto --group-directories-first'
alias ll='/usr/local/bin/gls -lF --color=auto --group-directories-first'
alias lla='/usr/local/bin/gls -laF --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias vi='/usr/local/bin/vim'
alias alex='cd $HOME/.$(whoami)'
alias r='fc -s'

###############################################################################
export PS1="$(__alex_ps1)"

###############################################################################
umask 0022

###############################################################################
set -o vi
