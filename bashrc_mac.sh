###############################################################################
# Environment must be overwritten or all relevant stuff will malfunction.
###############################################################################
export DIR_MY_ENV="${HOME}/.alex"

###############################################################################
# System defaults.
###############################################################################
[ -f "/etc/bashrc" ] && source "/etc/bashrc"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

###############################################################################
# System resources.
###############################################################################
if [ -d /usr/local/etc/profile.d ]; then
    for ish in /usr/local/etc/profile.d/*.sh; do
        source "${ish}"
    done
fi
if [ -d /usr/local/etc/bash_completion.d ]; then
    for ish in /usr/local/etc/bash_completion.d/*; do
        source "${ish}"
    done
fi

###############################################################################
# Custom environment variables regarding paths.
###############################################################################
# projects
export DIR_PJ="${HOME}/Workspaces"

# nvm (node)
export NVM_DIR="${HOME}/.nvm"

# virtual env
export DIR_VENV="${DIR_MY_ENV}/venv"

###############################################################################
# NVM/Node behaviors.
###############################################################################
# This loads nvm
if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    source "/usr/local/opt/nvm/nvm.sh"
fi

# This loads nvm bash_completion
if [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ]; then
    source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
fi

###############################################################################
# Load our own resources.
###############################################################################
# Custom rc files.
if [ -d "${DIR_MY_ENV}/etc" ]; then
    for ish in "${DIR_MY_ENV}"/etc/*_rc.sh; do
        source "${ish}"
    done
fi
unset ish

# Custom PATH
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
PATH="/usr/local/opt/findutils/libexec/gnubin:${PATH}"
PATH="/usr/local/opt/curl/bin:${PATH}"
PATH="/usr/local/opt/file-formula/bin:${PATH}"
PATH="/usr/local/opt/node@8/bin:${PATH}"
PATH="${DIR_MY_ENV}/bin:${PATH}"
export PATH

# Custom MANPATH
MANPATH="/usr/local/opt/coreutils/libexec/gnuman"
MANPATH="${MANPATH}:/usr/local/share/man"
MANPATH="${MANPATH}:"
export MANPATH

# Custom aliases
alias ls='/usr/local/bin/gls -F --color=auto --group-directories-first'
alias la='/usr/local/bin/gls -aF --color=auto --group-directories-first'
alias ll='/usr/local/bin/gls -lF --color=auto --group-directories-first'
alias lla='/usr/local/bin/gls -laF --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias vi='/usr/local/bin/vim'
alias r='fc -s'

# Custom PS1
PS1="$(__my_ps1)"
export PS1

# Custom umask
umask 0022

# Custom editor mode
set -o vi

