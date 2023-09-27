#!/bin/sh

# Install Git
sudo apt-get install git -y

# Download and install links
wget "https://windscribe.com/install/desktop/linux_deb_x64/windscribe_2.6.14_amd64.deb" -O ~/Downloads/windscribe.deb
wget "https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.deb" -O ~/Downloads/portmaster.deb

# Install downloaded files
sudo dpkg -i ~/Downloads/windscribe.deb
sudo dpkg -i ~/Downloads/portmaster.deb

# Install Guest Additions
sudo apt-get install spice-vdagent -y

# Install Brave Browser
sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install brave-browser -y
