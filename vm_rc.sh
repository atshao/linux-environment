[ -n "$(which VBoxManage 2>/dev/null)" ] || return

function __my_vm__cmd__list() {
    local vm
    for vm in $(VBoxManage list vms | cut -d'"' -f2); do
        echo "--> ${vm}"
    done
}

function __my_vm__cmd__start() {
    if [ -z "${1}" ]; then
        echo "error: no vm name specified."
    else
        local vm
        for vm in $(VBoxManage list vms | cut -d'"' -f2); do
            if [ "${vm}" = "${1}" ]; then
                VBoxManage startvm "${vm}"
                return
            fi
        done
    fi
    echo "error: not existed: ${1}"
}

function __my_vm__cmd__stop() {
    if [ -n "${1}" ]; then
        local vm
        for vm in $(VBoxManage list runningvms | cut -d'"' -f2); do
            if [ -z "${1}" ] || [ "${vm}" = "${1}" ]; then
                VBoxManage controlvm "${1}" poweroff
                return
            fi
        done
    fi
    echo "error: not running: ${1}"
}

function __my_vm__query__vms() {
    local vms
    vms=$(VBoxManage list vms | cut -d'"' -f2)
    COMPREPLY=($(compgen -W "${vms}" -- "${COMP_WORDS[2]}"))
}

function __my_vm__query_vms_running() {
    local vms
    vms=$(VBoxManage list runningvms | cut -d'"' -f2)
    COMPREPLY=($(compgen -W "${vms}" -- "${COMP_WORDS[2]}"))
}

function __my_vm__query_sub_commands() {
    local sub_commands=()
    sub_commands+=("ls")
    sub_commands+=("list")
    sub_commands+=("start")
    sub_commands+=("stop")
    COMPREPLY=($(compgen -W "${sub_commands[*]}" -- "${COMP_WORDS[1]}"))
}

function __my_vm__completion() {
    if [ ${#COMP_WORDS[@]} -eq 2 ]; then
        __my_vm__query_sub_commands
    elif [ ${#COMP_WORDS[@]} -eq 3 ]; then
        if [ "${COMP_WORDS[1]}" = "start" ]; then
            __my_vm__query__vms
        elif [ "${COMP_WORDS[1]}" = "stop" ]; then
            __my_vm__query_vms_running
        fi
    fi
}

function vm() {
    if [ ${#} -eq 1 ]; then
        if [ "${1}" = "ls" ] || [ "${1}" = "list" ]; then
            __my_vm__cmd__list
        fi
    elif [ ${#} -eq 2 ]; then
        if [ "${1}" = "start" ]; then
            __my_vm__cmd__start "${2}"
        elif [ "${1}" = "stop" ]; then
            __my_vm__cmd__stop "${2}"
        fi
    fi
}

complete -F __my_vm__completion vm
