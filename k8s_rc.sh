[ -n "$(which kubectl 2>/dev/null)" ] || return

[ -n "$(which kubectl 2>/dev/null)" ] \
    && source <(kubectl completion bash 2>/dev/null)
[ -n "$(which helm 2>/dev/null)" ] \
    && source <(helm completion bash 2>/dev/null)

function __my_k8s__cmd__list() {
    if [ -n "$(kubectl config get-contexts -o name 2>/dev/null)" ]; then
        kubectl config get-contexts
    fi
}

function __my_k8s__cmd__toggle_ps1() {
    if [ -z "${K8S_PS1}" ]; then
        export K8S_PS1="on"
    else
        unset K8S_PS1
    fi
}

function __my_k8s__cmd__use() {
    if [ -z "${1}" ]; then
        echo "error: no context name specified."
    else
        kubectl config use-context "${1}"
    fi
}

function __my_k8s__query__contexts() {
    local ctx
    ctx=$(kubectl config get-contexts --no-headers --output=name 2>/dev/null)
    COMPREPLY=($(compgen -W "${ctx}" -- "${COMP_WORDS[2]}"))
}

function __my_k8s__query__sub_commands() {
    local sub_commands=()
    sub_commands+=("ls")
    sub_commands+=("list")
    sub_commands+=("use")
    COMPREPLY=($(compgen -W "${sub_commands[*]}" -- "${COMP_WORDS[1]}"))
}

function __my_k8s__completion() {
    if [ ${#COMP_WORDS[@]} -eq 2 ]; then
        __my_k8s__query__sub_commands
    elif [ ${#COMP_WORDS[@]} -eq 3 ]; then
        if [ "${COMP_WORDS[1]}" = "use" ]; then
            __my_k8s__query__contexts
        fi
    fi
}

function k8s() {
    if [ ${#} -eq 0 ]; then
        __my_k8s__cmd__toggle_ps1
    elif [ ${#} -eq 1 ]; then
        if [ "${1}" = "ls" ] || [ "${1}" = "list" ]; then
            __my_k8s__cmd__list
        fi
    elif [ ${#} -eq 2 ]; then
        if [ "${1}" = "use" ]; then
            __my_k8s__cmd__use "${2}"
        fi
    fi
}

complete -F __my_k8s__completion k8s
