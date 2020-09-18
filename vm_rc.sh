if [ ${VBOX_INSTALLED} ]; then
    alias vmup='VBoxManage startvm'
    alias lsvm='VBoxManage list vms'
    alias lsvm-all='VBoxManage list vms'
    alias lsvm-running='VBoxManage list runningvms'

    function vmdown() {
        if [ "x${1}" = "x" ]; then
            echo "ERROR: no virtual machine name specified."
        else
            VBoxManage controlvm "${1}" poweroff
        fi
    }
    function _vmup() {
        local cur
        COMPREPLY=()

        cur="${COMP_WORDS[$COMP_CWORD]}"
        case $COMP_CWORD in
        1)  # available vms
            vms=$(VBoxManage list vms | cut -d'"' -f2)
            COMPREPLY=( $(compgen -W "${vms}" -- ${cur}) )
            ;;
        esac
    }
    function _vmdown() {
        local cur
        COMPREPLY=()

        cur="${COMP_WORDS[$COMP_CWORD]}"
        case $COMP_CWORD in
        1)  # running vms
            vms=$(VBoxManage list runningvms | cut -d'"' -f2)
            COMPREPLY=( $(compgen -W "${vms}" -- ${cur}) )
            ;;
        esac
    }
    complete -F _vmup vmup
    complete -F _vmdown vmdown
fi

