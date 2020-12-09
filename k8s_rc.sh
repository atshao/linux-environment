if [ $(which kubectl 2>/dev/null) ]; then
    source <(kubectl completion bash 2>/dev/null)

    function __alex_k8s__list() {
        if [ -n "$(kubectl config get-contexts -o name 2>/dev/null)" ]; then
            for ctx in $(kubectl config get-contexts 2>/dev/null); do
                echo "--> ${ctx}"
            done
        fi
    }

    function __alex_k8s__toggle_ps1() {
        if [ "x${K8S_PS1}" = "x" ]; then
            export K8S_PS1="on"
        else
            unset K8S_PS1
        fi
    }

    function __alex_k8s__use() {
        if [ "x${1}" = "x" ]; then
            echo "ERROR: no context name specified."
        else
            kubectl config use-context "${1}"
        fi
    }

    function k8s() {
        if [ "${#}" -eq 0 ]; then
            __alex_k8s__toggle_ps1
        elif [ "${#}" -eq 1 ]; then
            if [ "${1}" = "ls" -o "${1}" = "list" ]; then
                __alex_k8s__list
            elif [ "${1}" = "use" ]; then
                __alex_k8s__use
            fi
        fi
    }

    function __alex_k8s__completion() {
        if [ "${#COMP_WORDS[@]}" = 2 ]; then
            local sub_cmd=""
            sub_cmd="${sub_cmd}"$'\n'"use"
            sub_cmd="${sub_cmd}"$'\n'"list"
            COMPREPLY=($(compgen -W "${sub_cmd}" -- "${COMP_WORDS[1]}"))
        elif [ "${#COMP_WORDS[@]}" = 3 -a "${COMP_WORDS[1]}" = "use" ]; then
            local ctx
            ctx=$(kubectl config get-contexts \
                  --no-headers \
                  --output=name \
                  2>/dev/null)
            COMPREPLY=($(compgen -W "${ctx}" -- "${COMP_WORDS[2]}"))
        fi
    }

    complete -F __alex_k8s__completion k8s
fi


if [ $(which helm 2> /dev/null) ]; then
    source <(helm completion bash)
fi

