# Custom personal PS1 like following
#
#   user@hostname venv:venv_info git:branch_name
#   working-dir
#   $
#
[ -n "$(type -t __git_ps1)" ] \
    && export GIT_PS1_SHOWDIRTYSTATE="true" \
    && export GIT_PS1_SHOWSTASHSTATE="true" \
    && export GIT_PS1_SHOWUNTRACKEDFILES="true" \
    && export GIT_PS1_SHOWUPSTREAM="auto" \
    && export GIT_PS1_SHOWCOLORHINTS="true"


function __my_ps1() {
    local info=""

    local c_normal='\[\e[0m\]'
    local c_user_root='\[\e[1;37;41m\]'
    local c_user_normal='\[\e[1;30;42m\]'
    local b_blue='\[\e[1;37;44m\]'
    local b_purple='\[\e[1;37;45m\]'
    local b_yellow='\[\e[0;30;43m\]'
    local c_where='\[\e[0;36m\]'

    [ "$(id -un)" = "root" ] \
        && info="${c_user_root} \u@\h ${c_normal}" \
        || info="${c_user_normal} \u@\h ${c_normal}"

    local k8s='${K8S_PS1:+ k8s:$(kubectl config current-context 2>/dev/null) }'
    info="${info}${b_yellow}${k8s}${c_normal}"

    local venv_info='${VENV_NAME:+ venv:$(printenv VENV_NAME) }'
    info="${info}${b_blue}${venv_info}${c_normal}"

    [ -n "$(type -t __git_ps1)" ] \
        && info="${info}${b_purple}"'$(__git_ps1 " git:%s ")'"${c_normal}"

    local where="${c_where}"'$(pwd)'"${c_normal}"
    printf -- '\n%s\n%s\n\$ ' "${info}" "${where}"
}


# We don't want virtualenv's prompt!
export VIRTUAL_ENV_DISABLE_PROMPT=1

