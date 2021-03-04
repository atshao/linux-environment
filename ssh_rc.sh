[ -n "$(which ssh 2>/dev/null)" ] || return

function __my_ssh__completion() {
    [ -f "${HOME}/.ssh/config" ] || return
    [ ${#COMP_WORDS[@]} -eq 2 ] || return

    local line targets=() re_host='^ *Host +([^*]+) *$'
    while IFS= read -r line; do
        if [[ "${line}" =~ $re_host ]]; then
            targets+=("${BASH_REMATCH[1]}")
        fi
    done < <(cat "${HOME}/.ssh/config")

    COMPREPLY=($(compgen -W "${targets[*]}" -- "${COMP_WORDS[1]}"))
}

complete -F __my_ssh__completion ssh
