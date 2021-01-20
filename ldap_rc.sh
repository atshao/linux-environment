function ldap() {
    if [ -z "${1}" ]; then
        echo "error: no CN specified."
    else
        ldapsearch \
            -W \
            -H "ldap://172.20.1.99:3268" \
            -D "advantech\alex.shao" \
            -b "dc=advantech,dc=corp" \
            "(cn=${1})" | \
        while IFS= read -r line; do
            echo "${line}" | grep -i 'distinguishedName: ' 2>/dev/null
            echo "${line}" | grep -i 'physicalDeliveryOfficeName: ' 2>/dev/null
            echo "${line}" | grep -i 'telephoneNumber: ' 2>/dev/null
            echo "${line}" | grep -i 'memberOf: ' 2>/dev/null
            echo "${line}" | grep -i 'department: ' 2>/dev/null
            echo "${line}" | grep -i 'company: ' 2>/dev/null
            echo "${line}" | grep -i 'directReports: ' 2>/dev/null
            echo "${line}" | grep -i 'mail: ' 2>/dev/null
        done
    fi
}
