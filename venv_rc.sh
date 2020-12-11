[ -n "$(which virtualenv 2>/dev/null)" ] || return
[ -n "${DIR_VENV}" ] || return
[ -d "${DIR_VENV}" ] || mkdir -p "${DIR_VENV}" || return

    function mkvv() {
        local version
        version=$(python -V 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1)
        if [ "${version}" = "2" ]; then
            mkvv2 "$@"
        elif [ "${version}" = "3" ]; then
            mkvv3 "$@"
        else
            echo "error: cannot determine default Python version"
        fi
    }
    function mkvv2() {
        if [ -z "${1}" ]; then
            echo "error: no name specified."
        else
            if [ -d "${DIR_VENV}/${1}" ]; then
                echo "error: already existed: ${1}"
            else
                (cd "${DIR_VENV}" && virtualenv --python=python2 "${1}")
            fi
        fi
    }
    function mkvv3() {
        if [ -z "${1}" ]; then
            echo "error: no name specified."
        else
            if [ -d "${DIR_VENV}/${1}" ]; then
                echo "error: already existed: ${1}"
            else
                (cd "${DIR_VENV}" && virtualenv --python=python3 "${1}")
            fi
        fi
    }
    function _vv() {
        [ "${#COMP_WORDS[@]}" != "2" ] && return
        [ "${COMP_WORDS[0]}" == "lsvv" ] && return
        [ "${COMP_WORDS[0]}" == "mkvv" ] && return
        [ "${COMP_WORDS[0]}" == "mkvv2" ] && return
        [ "${COMP_WORDS[0]}" == "mkvv3" ] && return
        [ "${COMP_WORDS[0]}" == "vvdown" ] && return

        local vvs
        if [ "${COMP_WORDS[0]}" == "mkvv" ]; then
            COMPREPLY=("--python=")
        else
            vvs=$(find "${DIR_VENV}" \
                  -maxdepth 1 -mindepth 1\
                  -type d -exec basename {} \; \
                  2>/dev/null \
                  | sort -u)
            COMPREPLY=($(compgen -W "${vvs}" -- "${COMP_WORDS[1]}"))
        fi
    }

function __my_venv__cmd__add() {
    echo "add:" "${@}"
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
        cd "${where}"
    else
        echo "error: not existed: ${1}"
    fi
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
    fi
}

function venv() {
    if [ ${#} -eq 1 ]; then
        if [ "${1}" = "ls" ] || [ "${1}" = "list" ]; then
            __my_venv__cmd__list
        elif [ "${1}" = "unmount" ]; then
            __my_venv__cmd__unmount
        fi
    elif [ ${#} -eq 2 ]; then
        if [ "${1}" = "add" ]; then
            shift; __my_venv__cmd__add "${@}"
        elif [ "${1}" = "remove" ]; then
            __my_venv__cmd__remove "${2}"
        elif [ "${1}" = "mount" ]; then
            __my_venv__cmd__mount "${2}"
        elif [ "${1}" = "go" ]; then
            __my_venv__cmd__go "${2}"
        fi
    fi
}

complete -F __my_venv__completion venv
