function _ssh() {
    [ "${#COMP_WORDS[@]}" != "2" ] && return
    [ ! -f "${HOME}/.ssh/config" ] && return

    local re_host='^ *Host +([^*]+) *$'
    local re_user='^ *User +([^ ]+) *$'

    IFS=$'\n'
    local line host="" user="" targets=""
    for line in $(cat "${HOME}/.ssh/config"); do
        if [[ "${line}" =~ $re_host ]]; then
            host="${host}${BASH_REMATCH[1]}"
            user=""  # reset user when new host section starts
        elif [[ "${line}" =~ $re_user ]]; then
            user="${user}${BASH_REMATCH[1]}"
        fi

        if [ "x${host}" != "x" -a "x${user}" != "x" ]; then
            targets="${targets}"$'\n'"${user}@${host}"
        fi
    done

    COMPREPLY=($(compgen -W "${targets[@]}" -- "${COMP_WORDS[1]}"))
}
complete -F _ssh ssh
