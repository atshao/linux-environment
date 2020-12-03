if [ $(which VBoxManage 2>/dev/null) ]; then
    alias vmup='VBoxManage startvm'
    #alias lsvm='VBoxManage list vms'

    function lsvm() {
        if [ $# -gt 0 ]; then
            echo "ERROR: argument provided"
        else
            local vm
            for vm in $(VBoxManage list vms | cut -d'"' -f2); do
                echo "--> ${vm}"
            done
        fi
    }
    function vmdown() {
        if [ "x${1}" != "x" ]; then
            VBoxManage controlvm "${1}" poweroff
        else
            local num_vms
            num_vms=$(VBoxManage list runningvms | wc -l)
            if [ ${num_vms} -eq 0 ]; then
                echo "INFO: no virtual machine running."
            elif [ ${num_vms} -eq 1 ]; then
                local vm
                vm=$(VBoxManage list runningvms | cut -d'"' -f2)
                VBoxManage controlvm "${vm}" poweroff
            else
                echo "ERROR: no virtual machine name specified."
            fi
        fi
    }
    function _vm() {
        [ "${#COMP_WORDS[@]}" != "2" ] && return

        local vms
        if [ "${COMP_WORDS[0]}" == "vmup" ]; then
            vms=$(VBoxManage list vms | cut -d'"' -f2)
        elif [ "${COMP_WORDS[0]}" == "vmdown" ]; then
            vms=$(VBoxManage list runningvms | cut -d'"' -f2)
        else
            return
        fi

        COMPREPLY=($(compgen -W "${vms}" -- "${COMP_WORDS[1]}"))
    }
    complete -F _vm lsvm
    complete -F _vm vmup
    complete -F _vm vmdown
fi

