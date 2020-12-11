[ -n "$(which ssh 2>/dev/null)" ] || return

function __my_ssh__completion() {
    [ -f "${HOME}/.ssh/config" ] || return
    [ ${#COMP_WORDS[@]} -eq 2 ] || return

    local re_host='^ *Host +([^*]+) *$'
    local re_user='^ *User +([^ ]+) *$'

    local line host="" user="" targets=()
    while IFS= read -r line; do
        if [[ "${line}" =~ $re_host ]]; then
            host="${host}${BASH_REMATCH[1]}"
            user=""  # reset user when new host section starts
        elif [[ "${line}" =~ $re_user ]]; then
            user="${user}${BASH_REMATCH[1]}"
        fi

        if [ -n "${host}" ] && [ -n "${user}" ]; then
            targets+=("${user}@${host}")
        fi
    done < <(cat "${HOME}/.ssh/config")

    COMPREPLY=($(compgen -W "${targets[*]}" -- "${COMP_WORDS[1]}"))
}

complete -F __my_ssh__completion ssh
