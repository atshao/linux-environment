if [ "x${DIR_VV}" != "x" ]; then
    [ ! -d "${DIR_VV}" ] && mkdir -p "${DIR_VV}"

    function lsvv() {
        if [ $# -gt 0 ]; then
            echo "ERROR: lsvv requires no argument"
        else
            local vvs
            vvs=$(find "${DIR_VV}" -maxdepth 1 -type d 2>/dev/null | sort)
            for vv in "${vvs}"; do
                if [ "${vv}" != "${DIR_VV}" ]; then
                    echo "--> $(basename "${vv}")"
                fi
            done
        fi
    }
    function mkvv() {
        local version
        version=$(python -V 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1)
        if [ "${version}" = "2" ]; then
            mkvv2 "$@"
        elif [ "${version}" = "3" ]; then
            mkvv3 "$@"
        else
            echo "ERROE: cannot determine default Python version"
        fi
    }
    function mkvv2() {
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
            vvs=$(find "${DIR_VV}" \
                  -maxdepth 1 -mindepth 1\
                  -type d -exec basename {} \; \
                  2>/dev/null \
                  | sort -u)
            COMPREPLY=($(compgen -W "${vvs}" -- "${COMP_WORDS[1]}"))
        fi
    }
    complete -F _vv lsvv
    complete -F _vv mkvv
    complete -F _vv mkvv2
    complete -F _vv mkvv3
    complete -F _vv rmvv
    complete -F _vv cdvv
    complete -F _vv vvup
    complete -F _vv vvdown
fi
