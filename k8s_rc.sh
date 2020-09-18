if [ ${K8S_INSTALLED} ]; then
    source <(kubectl completion bash)
    alias lsk8s='kubectl config get-contexts'

    function k8s() {
        if [ "x${K8S_PS1}" = "x" ]; then
            export K8S_PS1=1
        else
            unset K8S_PS1
        fi
    }
    function chk8s() {
        if [ "x${1}" = "x" ]; then
            echo "ERROR: no context name specified."
        else
            kubectl config use-context ${1}
        fi
    }
    function _k8s() {
        local cur
        COMPREPLY=()

        cur="${COMP_WORDS[$COMP_CWORD]}"
        case $COMP_CWORD in
        1)  # k8s contexts
            ctx=$(kubectl config get-contexts --no-headers --output=name)
            COMPREPLY=( $(compgen -W "${ctx}" -- ${cur}) )
            ;;
        esac
    }
    complete -F _k8s lsk8s
    complete -F _k8s chk8s
fi


if [ $(which helm 2> /dev/null) ]; then
    source <(helm completion bash)
fi

