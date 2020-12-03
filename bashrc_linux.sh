###############################################################################
[ -f /etc/bashrc ] && . /etc/bashrc

###############################################################################
PATH="${HOME}/.$(whoami)/bin"
PATH="${PATH}:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH

###############################################################################
MANPATH="${MANPATH}:"
export MANPATH

###############################################################################
# projects, programming
export DIR_PJ="${HOME}/Workspaces"
# nvm (node)
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] \
    && source "${NVM_DIR}/nvm.sh"  # This loads nvm              
[ -s "${NVM_DIR}/bash_completion" ] \
    && source "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion
# virtual env
[ $(which virtualenv 2>/dev/null) ] \
    && export DIR_VV="${HOME}/.$(whoami)/venv" \
    || unset DIR_VV
# kubernetes
[ $(which kubectl 2>/dev/null) ] \
    && export K8S_INSTALLED=1 \
    || unset K8S_INSTALLED
# virtual box
[ $(which VBoxManage 2> /dev/null) ] \
    && export VBOX_INSTALLED=1 \
    || unset VBOX_INSTALLED

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
alias mongo='/usr/local/opt/mongodb@3.6/bin/mongod --config /usr/local/etc/mongod.conf'
alias pgsql='/usr/local/opt/postgresql@9.6/bin/postgres -D /usr/local/var/postgresql@9.6'
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
