###############################################################################
[ -f /etc/bashrc ] && . /etc/bashrc

###############################################################################
PATH="${HOME}/.alex/bin"
PATH="${HOME}/.local/bin"
PATH="${PATH}:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH

###############################################################################
MANPATH="${MANPATH}:"
export MANPATH

###############################################################################
# This loads nvm
if [ -s "${DIR_NVM}/nvm.sh" ]; then
    source "${DIR_NVM}/nvm.sh"
fi

# This loads nvm bash_completion
if [ -s "${DIR_NVM}/bash_completion" ]; then
    source "${DIR_NVM}/bash_completion"
fi

# Load our own resources
if [ -d "${HOME}/.alex/etc" ]; then
    for ish in ${HOME}/.alex/etc/*_rc.sh; do
        source "${ish}"
    done
fi
unset ish

###############################################################################
alias r='fc -s'
alias ls='/usr/bin/ls -F --color=auto --group-directories-first'
alias la='/usr/bin/ls -aF --color=auto --group-directories-first'
alias ll='/usr/bin/ls -lF --color=auto --group-directories-first'
alias lla='/usr/bin/ls -laF --color=auto --group-directories-first'

###############################################################################
export PS1="$(__alex_ps1)"

###############################################################################
umask 0002

###############################################################################
set -o vi
