[ -n "$(which virtualenv 2>/dev/null)" ] || return
[ -n "${DIR_VENV}" ] || return
[ -d "${DIR_VENV}" ] || mkdir -p "${DIR_VENV}" || return

function __my_venv__cmd__add() {
    local name="${1}" py_path="${2}"

    if [ -z "${name}" ]; then
        echo "error: no venv name specified."
        return
    fi

    if [ -d "${DIR_VENV:?}/${name}" ]; then
        echo "error: already existed: ${name}"
        return
    fi

    if [ -z "${py_path}" ]; then
        virtualenv "${DIR_VENV}/${name}"
    else
        virtualenv --python="${py_path}" "${DIR_VENV}/${name}"
    fi
}

function __my_venv__cmd__remove() {
    if [ -z "${1}" ]; then
        echo "error: no venv name specified."
    else
        rm -rf "${DIR_VENV:?}/${1}"
    fi
}

function __my_venv__cmd__list() {
    local vv
    for vv in $(find "${DIR_VENV:?}" -maxdepth 1 -type d | sort); do
        [ "${vv}" != "${DIR_VENV}" ] && echo "--> $(basename "${vv}")"
    done
}

function __my_venv__cmd__mount() {
    if [ -z "${1}" ]; then
        echo "error: no venv name specified."
        return
    fi

    if [ -f "${DIR_VENV:?}/${1}/bin/activate" ]; then
        __my_venv__cmd__unmount
        export VENV_NAME="${1}"
        source "${DIR_VENV}/${1}/bin/activate" 2>/dev/null
        source <(pip completion --bash 2>/dev/null)
    else
        echo "error: not existed: ${1}"
    fi
}

function __my_venv__cmd__unmount() {
    unset VENV_NAME
    deactivate > /dev/null 2>&1
}

function __my_venv__cmd__go() {
    local where
    [ -z "${1}" ] && where="${DIR_VENV:?}" || where="${DIR_VENV:?}/${1}"
    if [ -d "${where}" ]; then
        cd "${where}" || return
    else
        echo "error: not existed: ${1}"
    fi
}

function __my_venv__query__paths() {
    COMPREPLY=($(compgen -o default -f -- "${COMP_WORDS[3]}"))
}

function __my_venv__query__venvs() {
    local venvs
    venvs=$(find "${DIR_VENV}" \
                 -maxdepth 1 \
                 -mindepth 1 \
                 -type d \
                 -exec basename {} \; \
            | sort -u)
    COMPREPLY=($(compgen -W "${venvs}" -- "${COMP_WORDS[2]}"))
}

function __my_venv__query_sub_commands() {
    local sub_commands=()
    sub_commands+=("add")
    sub_commands+=("remove")
    sub_commands+=("ls")
    sub_commands+=("list")
    sub_commands+=("mount")
    sub_commands+=("unmount")
    sub_commands+=("go")
    COMPREPLY=($(compgen -W "${sub_commands[*]}" -- "${COMP_WORDS[1]}"))
}

function __my_venv__completion() {
    if [ ${#COMP_WORDS[@]} -eq 2 ]; then
        __my_venv__query_sub_commands
    elif [ ${#COMP_WORDS[@]} -eq 3 ]; then
        if [ "${COMP_WORDS[1]}" = "remove" ]; then
            __my_venv__query__venvs
        elif [ "${COMP_WORDS[1]}" = "mount" ]; then
            __my_venv__query__venvs
        elif [ "${COMP_WORDS[1]}" = "go" ]; then
            __my_venv__query__venvs
        fi
    elif [ ${#COMP_WORDS[@]} -eq 4 ]; then
        if [ "${COMP_WORDS[1]}" = "add" ]; then
            __my_venv__query__paths
        fi
    fi
}

function venv() {
    if [ ${#} -eq 1 ]; then
        if [ "${1}" = "ls" ] || [ "${1}" = "list" ]; then
            __my_venv__cmd__list
        elif [ "${1}" = "unmount" ]; then
            __my_venv__cmd__unmount
        elif [ "${1}" = "go" ]; then
            __my_venv__cmd__go
        fi
    elif [ ${#} -eq 2 ]; then
        if [ "${1}" = "add" ]; then
            __my_venv__cmd__add "${2}"
        elif [ "${1}" = "remove" ]; then
            __my_venv__cmd__remove "${2}"
        elif [ "${1}" = "mount" ]; then
            __my_venv__cmd__mount "${2}"
        elif [ "${1}" = "go" ]; then
            __my_venv__cmd__go "${2}"
        fi
    elif [ ${#} -eq 3 ]; then
        if [ "${1}" = "add" ]; then
            __my_venv__cmd__add "${2}" "${3}"
        fi
    fi
}

complete -F __my_venv__completion venv
