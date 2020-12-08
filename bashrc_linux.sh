###############################################################################
# System defaults.
###############################################################################
[ -f "/etc/bashrc" ] && source "/etc/bashrc"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

###############################################################################
# Custom environment variables regarding paths.
###############################################################################
# projects
export DIR_PJ="${HOME}/Workspaces"

# nvm (node)
export DIR_NVM="${HOME}/.nvm"

# virtual env
export DIR_VV="${HOME}/.alex/venv"

###############################################################################
# NVM/Node behaviors.
###############################################################################
# This loads nvm
if [ -s "${DIR_NVM}/nvm.sh" ]; then
    source "${DIR_NVM}/nvm.sh"
fi

# This loads nvm bash_completion
if [ -s "${DIR_NVM}/bash_completion" ]; then
    source "${DIR_NVM}/bash_completion"
fi

###############################################################################
# Load our own resources.
###############################################################################
# Custom rc files.
if [ -d "${HOME}/.alex/etc" ]; then
    for ish in "${HOME}"/.alex/etc/*_rc.sh; do
        source "${ish}"
    done
fi
unset ish

# Custom PATH
PATH="${HOME}/.local/bin:${PATH}"
PATH="${HOME}/.alex/bin:${PATH}"
export PATH

# Custom aliases
alias r='fc -s'
alias ls='/usr/bin/ls -F --color=auto --group-directories-first'
alias la='/usr/bin/ls -aF --color=auto --group-directories-first'
alias ll='/usr/bin/ls -lF --color=auto --group-directories-first'
alias lla='/usr/bin/ls -laF --color=auto --group-directories-first'

# Custom PS1
PS1="$(__alex_ps1)"
export PS1

# Custom umask
umask 0002

# Custom editor mode
set -o vi
