function lsvv() {
    if [ "x${DIR_VV}" = "x" ]; then
        echo "ERROR: environment variable DIR_VV not set."
    else
        /usr/local/bin/gls -1 "${DIR_VV}"
    fi
}
function mkvv() {
    if [ "x${DIR_VV}" = "x" ]; then
        echo "ERROR: environment variable DIR_VV not set."
    elif [ "x${1}" = "x" ]; then
        echo "ERROR: no name specified."
    else
        [ -d "${DIR_VV}" ] || mkdir -p "${DIR_VV}"
        if [ -d "${DIR_VV}/${1}" ]; then
            echo "ERROR: already existed: ${1}"
        else
            (cd "${DIR_VV}" && virtualenv --python=python2 "${1}")
        fi
    fi
}
function mkvv3() {
    if [ "x${DIR_VV}" = "x" ]; then
        echo "ERROR: environment variable DIR_VV not set."
    elif [ "x${1}" = "x" ]; then
        echo "ERROR: no name specified."
    else
        [ -d "${DIR_VV}" ] || mkdir -p "${DIR_VV}"
        if [ -d "${DIR_VV}/${1}" ]; then
            echo "ERROR: already existed: ${1}"
        else
            (cd "${DIR_VV}" && virtualenv --python=python3 "${1}")
        fi
    fi
}
function rmvv() {
    if [ "x${DIR_VV}" = "x" ]; then
        echo "ERROR: environment variable DIR_VV not set."
    elif [ "x${1}" = "x" ]; then
        echo "ERROR: no name specified."
    else
        rm -rf "${DIR_VV}/${1}"
    fi
}
function cdvv() {
    if [ "x${DIR_VV}" = "x" ]; then
        echo "ERROR: environment variable DIR_VV not set."
    else
        [ "x${1}" = "x" ] && _DIR="${DIR_VV}" || _DIR="${DIR_VV}/${1}"
        if [ -d "${_DIR}" ]; then
            cd "${_DIR}"
        else
            echo "ERROR: not existed: ${1}"
        fi
        unset _DIR
    fi
}
function vvup() {
    if [ "x${1}" = "x" ]; then
        echo "ERROR: no name specified."
    elif [ -r "${DIR_VV}/${1}/bin/activate" ]; then
        vvdown
        export VENV_NAME="${1}"
        source "${DIR_VV}/${1}/bin/activate" > /dev/null 2>&1
    else
        echo "ERROR: not existed: ${1}"
    fi
}
function vvdown() {
    unset VENV_NAME
    deactivate > /dev/null 2>&1
}
function _vv() {
    local cur
    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    case $COMP_CWORD in
    1)  # virtual env name
        vvs=$(find "${DIR_VV}" -maxdepth 1 -mindepth 1\
                               -type d -exec basename {} \; | sort -u)
        COMPREPLY=( $(compgen -W "${vvs}" -- ${cur}) )
        ;;
    esac
}
complete -F _vv rmvv
complete -F _vv cdvv
complete -F _vv vvup
