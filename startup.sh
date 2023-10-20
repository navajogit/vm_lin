#!/bin/bash
set -x

GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear

while true
do
    echo -e "${GREEN}SHOW INSTALL HIST (Y/N)${NC}"
    read insthist
    if [[ "$insthist" =~ ^[Yy]$ ]]; then
        echo ""
        echo "install history:"
        cat /var/log/dpkg.log.1 /var/log/dpkg.log | grep " install " | nl
    else
        clear
        echo "DONE"
        break
    fi
done

# ipv6 to ipv4
ipv6_setting=$(gsettings get org.gnome.system.network ipv6-method)

if [[ "$ipv6_setting" != "'disabled'" ]]; then
    echo -e "${GREEN}changing ipv6 to ipv4${NC}\n"
    connection_name=$(nmcli -t -f NAME con show --active)
    nmcli connection modify "$connection_name" ipv6.method disabled
    sudo systemctl restart NetworkManager
    sleep 2
fi

echo -e "${GREEN}Install FIREWALL? (Y/N)${NC}"
read fwall
if [[ "$fwall" =~ ^[Yy]$ ]]; then
    # setup basic firewall
    sudo apt install ufw -y
    sudo ufw enable
    sudo ufw limit 22/tcp
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo apt-get install git -y
    echo "DONE"
else
    clear
    echo "SKIPPING..."
fi

sudo apt install curl -y
clear

echo -e "${GREEN}Install WINDSCRIBE? (Y/N)${NC}"
read wscribe
if [[ "$wscribe" =~ ^[Yy]$ ]]; then
    wget "https://windscribe.com/install/desktop/linux_deb_x64/windscribe_2.6.14_amd64.deb" -O ~/Downloads/windscribe.deb
    sudo dpkg -i ~/Downloads/windscribe.deb
    # setup windscribe
    xdg-open https://windscribe.com/signup?cpid=app_windows
    echo "DONE"
else
    clear
    echo "SKIPPING..."
fi

echo -e "${GREEN}Install PORTMASTER? (Y/N)${NC}"
read pmaster
if [[ "$pmaster" =~ ^[Yy]$ ]]; then
    sudo apt install libnetfilter-queue1 -y
    wget "https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.deb" -O ~/Downloads/portmaster.deb
    sudo dpkg -i ~/Downloads/portmaster.deb
    sudo systemctl enable portmaster
    echo "DONE"
else
    clear
    echo "SKIPPING..."
fi

echo -e "${GREEN}Install BRAVE-BROWSER? (Y/N)${NC}"
read braveb
if [[ "$braveb" =~ ^[Yy]$ ]]; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update -y
    sudo apt install brave-browser -y
    echo "DONE"
else
    clear
    echo "SKIPPING..."
fi

echo -e "${GREEN}Install GUEST ADDITIONS? (Y/N)${NC}"
read gadd
if [[ "$gadd" =~ ^[Yy]$ ]]; then
    sudo apt install liburing2 -y
    sudo apt install qemu-guest-agent -y
    sudo apt-get install spice-vdagent -y
    echo "DONE"
else
    clear
    echo "SKIPPING..."
fi

# installing git
sudo apt install git -y

# wallpapers
githubRepoUrl="https://raw.githubusercontent.com/navajogit/vm_lin/main/sample_list.txt"
wallpaperUrls=$(curl -s "$githubRepoUrl")

while true
do
    echo -e "${GREEN}Do you want to change the desktop wallpaper? (Y/N)${NC}"
    read changeWallpaper
    if [[ "$changeWallpaper" =~ ^[Yy]$ ]]; then
        # Choose a random URL
        randomUrl=$(shuf -n 1 <<< "$wallpaperUrls")
        wallpaperPath="/home/$USER/Pictures/wallpaper.jpg"
        wget -O "$wallpaperPath" "$randomUrl"
        gsettings set org.gnome.desktop.background picture-uri "file://$wallpaperPath"
        echo "DONE"
    else
        clear
        echo "DONE"
        break
    fi
done

echo -e "${GREEN}SHOW INSTALL HIST (Y/N)${NC}"
read insthist
if [[ "$insthist" =~ ^[Yy]$ ]]; then
    echo ""
    echo "install history:"
    cat /var/log/dpkg.log.1 /var/log/dpkg.log | grep " install " | nl
else
    clear
    echo "DONE"
fi
