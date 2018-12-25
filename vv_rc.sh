if [ "x${DIR_VV}" != "x" ]; then
    [ ! -d "${DIR_VV}" ] && mkdir -p "${DIR_VV}"

    function lsvv() {
        /usr/local/bin/gls -1 "${DIR_VV}"
        for vv in $(find "${DIR_VV}" -maxdepth 1 -type d | sort); do
            [ "${vv}" != "${DIR_VV}" ] && echo "$(basename "${vv}")"
        done
    }
    function mkvv() {
        if [ "x${1}" = "x" ]; then
            echo "ERROR: no name specified."
        else
            if [ -d "${DIR_VV}/${1}" ]; then
                echo "ERROR: already existed: ${1}"
            else
                (cd "${DIR_VV}" && virtualenv --python=python2 "${1}")
            fi
        fi
    }
    function mkvv3() {
        if [ "x${1}" = "x" ]; then
            echo "ERROR: no name specified."
        else
            if [ -d "${DIR_VV}/${1}" ]; then
                echo "ERROR: already existed: ${1}"
            else
                (cd "${DIR_VV}" && virtualenv --python=python3 "${1}")
            fi
        fi
    }
    function rmvv() {
        if [ "x${1}" = "x" ]; then
            echo "ERROR: no name specified."
        else
            rm -rf "${DIR_VV}/${1}"
        fi
    }
    function cdvv() {
        local _dir
        [ "x${1}" = "x" ] && _dir="${DIR_VV}" || _dir="${DIR_VV}/${1}"
        if [ -d "${_dir}" ]; then
            cd "${_dir}"
        else
            echo "ERROR: not existed: ${1}"
        fi
    }
    function vvup() {
        if [ "x${1}" = "x" ]; then
            echo "ERROR: no name specified."
        elif [ -r "${DIR_VV}/${1}/bin/activate" ]; then
            vvdown
            export VENV_NAME="${1}"
            source "${DIR_VV}/${1}/bin/activate" > /dev/null 2>&1

            pip | grep 'completion' >& /dev/null
            [ $? -eq 0 ] && source <(pip completion --bash)
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
fi
