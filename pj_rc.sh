function lspj() {
    if [ "x${DIR_PJ}" = "x" ]; then
        echo "ERROR: environment variable DIR_PJ not set."
    else
        /usr/local/bin/gls -1 "${DIR_PJ}"
    fi
}
function mkpj() {
    if [ "x${1}" = "x" ]; then
        echo "ERROR: no name specified."
    elif [ "x${DIR_PJ}" = "x" ]; then
        echo "ERROR: environment variable DIR_PJ not set."
    else
        [ -d "${DIR_PJ}" ] || mkdir -p "${DIR_PJ}"
        if [ -d "${DIR_PJ}/${1}" ]; then
            echo "ERROR: already existed: ${1}"
        else
            (cd "${DIR_PJ}" && mkdir "${1}")
        fi
    fi
}
function rmpj() {
    if [ "x${1}" = "x" ]; then
        echo "ERROR: no name specified."
    elif [ "x${DIR_PJ}" = "x" ]; then
        echo "ERROR: environment variable DIR_PJ not set."
    else
        rm -rf "${DIR_PJ}/${1}"
    fi
}
function cdpj() {
    if [ "x${DIR_PJ}" = "x" ]; then
        echo "ERROR: environment variable DIR_PJ not set."
    else
        [ "x${1}" = "x" ] && _DIR="${DIR_PJ}" || _DIR="${DIR_PJ}/${1}"
        if [ -d "${_DIR}" ]; then
            cd "${_DIR}"
        else
            echo "ERROR: not existed: ${1}"
        fi
        unset _DIR
    fi
}
function _pj() {
    local cur
    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    case $COMP_CWORD in
    1)  # virtual env name
        pjs=$(find "${DIR_PJ}" -maxdepth 1 -mindepth 1\
                               -type d -exec basename {} \; | sort -u)
        COMPREPLY=( $(compgen -W "${pjs}" -- ${cur}) )
        ;;
    esac
}
complete -F _pj rmpj
complete -F _pj cdpj
