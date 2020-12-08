if [ ! -d "${DIR_PJ}" ]; then
    mkdir -p "${DIR_PJ}"
fi

function lspj() {
    for pj in $(find "${DIR_PJ}" -maxdepth 1 -type d | sort); do
        [ "${pj}" != "${DIR_PJ}" ] && basename "${pj}"
    done
}
function mkpj() {
    if [ "x${1}" = "x" ]; then
        echo "ERROR: no name specified."
    else
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
    else
        rm -rf "${DIR_PJ:?}/${1}"
    fi
}
function cdpj() {
    local _dir
    [ "x${1}" = "x" ] && _dir="${DIR_PJ}" || _dir="${DIR_PJ}/${1}"
    if [ -d "${_dir}" ]; then
        cd "${_dir}" || exit 1
    else
        echo "ERROR: not existed: ${1}"
    fi
}
function _pj() {
    local cur
    COMPREPLY=()

    cur="${COMP_WORDS[$COMP_CWORD]}"
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
