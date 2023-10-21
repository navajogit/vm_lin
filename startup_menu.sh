#!/bin/bash

doner () {
echo -e "\033[0;32mDONE \033[0m"
}
updatesys () {
    sudo apt update -y
    sudo apt upgrade -y
}



ipvchange () {

    ipv6_setting=$(gsettings get org.gnome.system.network ipv6-method)

    if [ "$ipv6_setting" != "'disabled'" ]; then
        echo "Disabling IPv6 ..."    
        gsettings set org.gnome.system.network ipv6-method 'disabled'    
        echo " IPv6 'disabled'."
    else
        echo "IPv6 is set to 'disabled'."
    fi

    nmcli connection modify "Wired connection 1" ipv6.method disabled
    sudo systemctl restart NetworkManager
    sleep 1

}

basicdeps () {
    sudo apt install curl -y
    sudo apt install wget -y

}

firewallinst () {
    sudo apt install ufw -y
    sudo ufw enable
    sudo ufw limit 22/tcp
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo apt-get install git -y

}


vpninstall () {
    wget "https://windscribe.com/install/desktop/linux_deb_x64/windscribe_2.6.14_amd64.deb" -O ~/Downloads/windscribe.deb
    sudo dpkg -i ~/Downloads/windscribe.deb
    # setup windscribe
    xdg-open https://windscribe.com/signup?cpid=app_windows

}

firewalliiinstall () {
    sudo apt install libnetfilter-queue1 -y
    wget "https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.deb" -O ~/Downloads/portmaster.deb
    sudo dpkg -i ~/Downloads/portmaster.deb
    sudo systemctl enable portmaster

}

braveinst () {
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update -y
    sudo apt install brave-browser -y

}

guestinst () {
    sudo apt install liburing2 -y
    sudo apt install qemu-guest-agent -y
    sudo apt-get install spice-vdagent -y

}

gitinst () {
    sudo apt install git -y

}

aperance () {
# wallpapers
githubRepoUrl="https://github.com/navajogit/vm_lin/raw/main/sample_list.txt"
wallpaperUrls=$(curl -s "$githubRepoUrl")

while true
do
    echo -e "\033[0;32mDo you want to change the desktop wallpaper? (Y/N)\033[0m"
    read changeWallpaper
    if [[ "$changeWallpaper" =~ ^[Yy]$ ]]; then
        # Choose a random URL
        randomUrl=$(shuf -n 1 <<< "$wallpaperUrls")
        wallpaperPath="/home/$USER/Pictures/wallpaper.jpg"
        wget -O "$wallpaperPath" "$randomUrl"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaperPath"
        echo "DONE"
    else
        clear
        echo "DONE"
        break
    fi
done
    
}

torinst () {
wget https://www.torproject.org/dist/torbrowser/13.0/tor-browser-linux-x86_64-13.0.tar.xz -O tor-browser-linux-x86_64-13.0.tar.xz
tar -xf tor-browser-linux-x86_64-13.0.tar.xz
chmod +x tor-browser-linux-x86_64-13.0.tar.xz
echo "alias tor='~/tor-browser/start-tor-browser.desktop'"
}

installhist () {
    echo ""
    echo "install history:"
    cat /var/log/dpkg.log.1 /var/log/dpkg.log | grep " install " | nl

}


menu () {
clear
echo -e "\033[0;32mCHOOSE OPTIONS TO SETUPS:\033[0m"
echo ""
echo ""
echo -e "\033[0;32m0.	UPDATE SYSTEM \033[0m"
echo ""
echo -e "\033[0;32m1.	IPV6 TO IPV4 \033[0m"
echo -e "\033[0;32m2.	FIREWALL \033[0m"
echo -e "\033[0;32m3.	FIREWALL II (PORTMASTER) \033[0m"
echo -e "\033[0;32m4.	BASIC DEPS \033[0m"
echo -e "\033[0;32m5.	BRAVE-BROWSER \033[0m"
echo -e "\033[0;32m6.	GUEST ADDITIONS FOR VM \033[0m"
echo -e "\033[0;32m7.	GIT \033[0m"
echo -e "\033[0;32m8.	APERANCE \033[0m"
echo ""
echo -e "\033[0;32m9.	TOR BROWSER \033[0m"
echo ""
echo -e "\033[0;32m10.	OPTIONS 1-7 \033[0m"
echo -e "\033[0;32m11.	ALL 0-8 \033[0m"
echo ":"
read option
}

menu

if [ ${option} -eq 0 ] then  
clear && updatesys && menu
elif [ ${option} -eq 1 ] then 
ipvchange && menu
elif [ ${option} -eq 2 ] then 
firewallinst && menu
elif [ ${option} -eq 3 ] then 
firewalliiinst && menu
elif [ ${option} -eq 5 ] then
basicdeps && menu
elif [ ${option} -eq 5 ] then 
braveinst && menu
elif [ ${option} -eq 6 ] then 
guestinst && menu
elif [ ${option} -eq 7 ] then 
gitinst && menu
elif [ ${option} -eq 8 ] then 
apperance && menu
elif [ ${option} -eq 9 ] then 
torinst && menu
elif [ ${option} -eq 10 ] then 
ipvchange && firewallinst &&firewalliiinst && basicdeps && braveinst && guestinst && gitinst && apperance && menu
elif [ ${option} -eq 11 ] then 
updatesys && ipvchange && firewallinst &&firewalliiinst && basicdeps && braveinst && guestinst && gitinst && apperance && torinst && menu
else
echo "wrong option"
fi
