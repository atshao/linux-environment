[ -d "${DIR_PJ}" ] || mkdir -p "${DIR_PJ}" || return

function __my_pj__cmd__add() {
    if [ -z "${1}" ]; then
        echo "error: no project name specified."
    else
        if [ -d "${DIR_PJ:?}/${1}" ]; then
            echo "error: already existed: ${1}"
        else
            (cd "${DIR_PJ}" && mkdir "${1}") && cd "${DIR_PJ}/${1}"
        fi
    fi
}

function __my_pj__cmd__remove() {
    if [ -z "${1}" ]; then
        echo "error: no project name specified."
    else
        rm -rf "${DIR_PJ:?}/${1}"
    fi
}

function __my_pj__cmd__go() {
    local where
    [ -z "${1}" ] && where="${DIR_PJ:?}" || where="${DIR_PJ:?}/${1}"
    if [ -d "${where}" ]; then
        cd "${where}"
    else
        echo "error: not existed: ${1}"
    fi
}

function __my_pj__cmd__list() {
    local pj
    for pj in $(find "${DIR_PJ:?}" -maxdepth 1 -type d | sort); do
        [ "${pj}" != "${DIR_PJ}" ] && echo "--> $(basename "${pj}")"
    done
}

function __my_pj__query_projects() {
    local projects
    projects=$(find "${DIR_PJ}" \
                    -maxdepth 1 \
                    -mindepth 1 \
                    -type d \
                    -exec basename {} \; \
               | sort -u)
    COMPREPLY=($(compgen -W "${projects}" -- "${COMP_WORDS[2]}"))
}

function __my_pj__query_sub_commands() {
    local sub_commands=()
    sub_commands+=("add")
    sub_commands+=("remove")
    sub_commands+=("ls")
    sub_commands+=("list")
    sub_commands+=("go")
    COMPREPLY=($(compgen -W "${sub_commands[*]}" -- "${COMP_WORDS[1]}"))
}

function __my_pj__completion() {
    if [ ${#COMP_WORDS[@]} -eq 2 ]; then
        __my_pj__query_sub_commands
    elif [ ${#COMP_WORDS[@]} -eq 3 ]; then
        if [ "${COMP_WORDS[1]}" = "remove" ]; then
            __my_pj__query_projects
        elif [ "${COMP_WORDS[1]}" = "go" ]; then
            __my_pj__query_projects
        fi
    fi
}

function pj() {
    if [ ${#} -eq 1 ]; then
        if [ "${1}" = "ls" ] || [ "${1}" = "list" ]; then
            __my_pj__cmd__list
        elif [ "${1}" = "go" ]; then
            __my_pj__cmd__go
        fi
    elif [ ${#} -eq 2 ]; then
        if [ "${1}" = "add" ]; then
            __my_pj__cmd__add "${2}"
        elif [ "${1}" = "remove" ]; then
            __my_pj__cmd__remove "${2}"
        elif [ "${1}" = "go" ]; then
            __my_pj__cmd__go "${2}"
        fi
    fi
}

complete -F __my_pj__completion pj
