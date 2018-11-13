function _ssh() {
    local cur
    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    case $COMP_CWORD in
    1)  # Alias defined in $HOME/.ssh/config
        if [ -f $HOME/.ssh/config ]; then
            hosts=$(cat $HOME/.ssh/config \
                 | grep -i '^Host' \
                 | awk '{ print $2; }' \
                 | grep -v '*')
        else
            hosts=
        fi
        COMPREPLY=( $(compgen -W "${hosts}" -- ${cur}) )
        ;;
    esac
}
complete -F _ssh ssh
