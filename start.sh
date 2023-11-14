#!/bin/bash

doner () {
echo -e "\033[0;32mDONE \033[0m"
}
updatesys () {
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y
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
    checkbasic() {
        if ! command -v $1 &>/dev/null; then
            echo "$1 is not installed. Installing..."
            sudo apt install $1 -y
        fi
    }
    checkbasic "curl"
    checkbasic "wget"
    checkbasic "make"
    checkbasic "sxiv"
    checkbasic "mpv"
    checkbasic "mplayer"
    checkbasic "libavcodec-extra"
    checkbasic "libdvd-pkg"
    sudo dpkg-reconfigure libdvd-pkg
    sudo apt-get install ubuntu-restricted-extras -y
    sudo apt-get install gnome-tweaks -y
    sudo add-apt-repository ppa:jonathonf/ffmpeg-4

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


vpninst () {
    wget "https://windscribe.com/install/desktop/linux_deb_x64/windscribe_2.7.14_amd64.deb" -O ~/Downloads/windscribe.deb
    sudo dpkg -i ~/Downloads/windscribe.deb &&
    shred -uz ~/Downloads/windscribe.deb

}

firewalliiinst () {
    sudo apt install libnetfilter-queue1 -y
    wget "https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.deb" -O ~/Downloads/portmaster.deb
    sudo dpkg -i ~/Downloads/portmaster.deb
    sudo systemctl enable portmaster
    shred -uzv ~/Downloads/portmaster.deb

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

aescryptinst () {
if ! type "aescrypt" &>/dev/null; then
    clear
    echo "Aescrypt"
    cd ~/Downloads
    wget https://github.com/navajogit/aescrypt/raw/main/aescrypt-3.16.tgz &&
    tar -xzf aescrypt-3.16.tgz &&
    cd aescrypt-3.16
    make &&
    sudo make install &&
    shred -uz ~/Downloads/aescrypt-3.16.tgz
    rm -rf ~/Downloads/aescrypt/
    cd ~
fi
}



extras () {

echo 'alias ali="nano ~/.bashrc"' >> ~/.bashrc
echo 'alias ..="cd .."' >> ~/.bashrc
echo 'alias .1="cd .."' >> ~/.bashrc
echo 'alias .2="cd ../.."' >> ~/.bashrc
echo 'alias .3="cd ../../.."' >> ~/.bashrc
echo 'alias xclip="xclip -selection c"' >> ~/.bashrc
echo 'alias setclip="xclip -selection c"' >> ~/.bashrc
echo 'alias getclip="xclip -selection c -o"' >> ~/.bashrc
echo 'alias rmhist="truncate -s 0 ~/.bash_history && echo  > ~/.bash_history && exit"' >> ~/.bashrc
echo 'alias e="rmhist && truncate -s 0 ~/.bash_history  && exit"' >> ~/.bashrc
echo 'alias Pic="cd ~/Pictures"' >> ~/.bashrc
echo 'alias Muz="cd ~/Music"' >> ~/.bashrc
echo 'alias Home="cd ~/"' >> ~/.bashrc
echo 'alias Dow="cd ~/Downloads"' >> ~/.bashrc
echo 'alias Doc="cd ~/Documents"' >> ~/.bashrc
echo 'alias Des="cd ~/Desktop"' >> ~/.bashrc
echo 'alias Data="cd /media/zlomek/DATA/"' >> ~/.bashrc
echo 'alias grep="grep --color=auto"' >> ~/.bashrc
echo 'alias ls="ls --color=auto"' >> ~/.bashrc
echo 'alias lll="ls -lah | fzf -e"' >> ~/.bashrc
echo 'alias ll="ls -l"' >> ~/.bashrc
echo 'alias ip="ip --color=auto"' >> ~/.bashrc
echo 'alias mpvx="mpv --ytdl-format=mp4 --geometry=50%:50% --no-border --force-window --autofit=1280x- $1"' >> ~/.bashrc
echo 'alias mpvv="mpv -vo=tct $1 $$"' >> ~/.bashrc
echo 'alias scaner3="sudo chkrootkit && sudo rkhunter -c && sudo clamscan -r / && clamscan -ir / && sudo lynis audit system && sudo openvas-start && sudo openvas-check-setup && sudo openvas-stop && sudo tiger && sudo /var/ossec/bin/ossec-control start && sudo aide -.."' >> ~/.bashrc
echo 'alias scaner2="sudo clamscan -r / && clamscan -ir /"' >> ~/.bashrc
echo 'alias scaner="sudo chkrootkit && sudo rkhunter -c"' >> ~/.bashrc
echo 'alias fullupdate="sudo apt update -y && sudo apt full-upgrade -y && sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade --fix-missing && sudo apt autoremove -y && sudo apt --fix-broken install -y"' >> ~/.bashrc
echo 'alias source="cat /etc/apt/sources.list"' >> ~/.bashrc
alias compile="pyinstaller --onefile"  >> ~/.bashrc




check() {
    if ! command -v $1 &>/dev/null; then
        echo "$1 is not installed. Installing..."
        sudo apt install $1 -y
    fi
}


check "zip"
check "dconf-editor"
check "cmake"
check "gnome-tweaks"
check "tar"
check "wget"
check "figlet"
check "shc"
check "xdotool"
check "toilet"
check "chafa"
check "fzf"
check "xdg-utils"
check "curl"
check "grep"
check "xsel"
check "xclip"
check "parted"
check "fdisk"
check "git"
check "macchanger"
check "hciconfig"
check "nmcli"
check "ip"
check "shuf"
check "colrm"
check "arp-scan"
check "gdal-bin"
check "ffmpeg"
check "python3-wheel"
check "python3-pip"
check "python3-dev"
check "python3-xlib"
check "libx11-dev"
check "libxext-dev"
check "plocate"
check "jq"
check "bat"
check "libc6"
check "libnetfilter-queue1"
check "libpcap0.8"
check "libusb-1.0-0"
check "sqlite3"
check "img2pdf"
check "poppler-utils"
check "lynx"
check "libxml2-dev"
check "libseccomp-dev"
check "libcurl4-gnutls-dev"
check "xcalib"
check "xbacklight"
check "w3m"
check "pdfgrep"
check "pandoc"
check "wkhtmltopdf"
check "texlive"
check "recode"
check "hexedit"
check "wireless-tools"
check "net-tools"
check "isc-dhcp-server"
check "lighttpd"
check "php-cgi"
check "nmap"
check "crunch"
check "john"
check "binwalk"
check "outguess"
check "stegosuite"
check "wireshark"
check "mediainfo"
check "fcrackzip"
check "netcat"
check "httrack"
check "iftop"
check "links"
check "php-league-html-to-markdown"
check "parallel"
check "exifprobe"
check "recon-ng"
check "python3-pil"
check "imagemagick"
check "graphicsmagick-imagemagick-compat"
check "imagemagick-6.q16"
check "imagemagick-6.q16hdri"
check "recoverjpeg"
check "foremost"
check "libusb-1.0-0-dev"
check "build-essential"
check "bison"
check "byacc"
check "libpcap0.8-dev"
check "pkg-config"
check "libnetfilter-queue-dev"
check "screenkey"






check_pip() {
    if ! pip show $1 &>/dev/null; then
        echo "$1 is not installed. Installing..."
        pip install --upgrade $1
    else
        echo "$1 is already installed."
    fi
}

check_pip "cfscrape"
check_pip "h8mail"
check_pip "toutatis"
check_pip "pycryptodome"
check_pip "yt-dlp"
check_pip "pyinstaller"
check_pip "youtube-dl"
check_pip "waybackpy"
check_pip "oauth2"
check_pip "sherlock"
check_pip "sublist3r"
check_pip "theHarvester"
check_pip "exifread"




cd ~/Dowlnloads
wget -O ~/google-earth.deb https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
sudo dpkg -i ~/google-earth.deb
cd ~/


git clone https://github.com/saitoha/libsixel.git
cd libsixel
autoreconf -i
./configure
make
sudo make install
cd ~



#bettercap
sudo apt update
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export GOROOT=/usr/local/src/go' >> ~/.bashrc
echo 'export PATH=${PATH}:/usr/local/src/go/bin:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
sudo apt-get update
sudo apt-get install git
git clone https://github.com/golang/go.git /usr/local/src/go
sudo apt-get install build-essential bison byacc libpcap0.8-dev pkg-config libnetfilter-queue-dev
sudo ln -sf /usr/lib/x86_64-linux-gnu/libpcap.so.1.10.1 /usr/lib/x86_64-linux-gnu/libpcap.so.1
git clone https://github.com/bettercap/bettercap.git $HOME/go/src/github.com/bettercap/bettercap
cd $HOME/go/src/github.com/bettercap/bettercap
sudo make build && sudo make install
git pull
sudo make build && sudo make install

cd ~




git clone https://github.com/xnl-h4ck3r/waymore.git
cd waymore
pip3 install -r requirements.txt
sudo python setup.py install
cd $HOME

pip3 install xeuledoc

flatpak install flathub org.pulseaudio.pavucontrol -y
echo "alias='flatpak run org.pulseaudio.pavucontrol'" >> ~/.bashrc

cd Downloads
wget https://github.com/hackerb9/lsix/archive/master.zip
unzip master.zip
sudo cp lsix-master/lsix /usr/local/bin/
sudo chmod +x /usr/local/bin/lsix
cd $HOME


}


appearance () {
# wallpapers
githubRepoUrl="https://raw.githubusercontent.com/navajogit/vm_lin/main/sample_list.txt"
wallpaperUrls=$(curl -s "$githubUrl")

while true
do
    echo -e "\033[0;32mDo you want to change the desktop wallpaper? (Y/N)\033[0m"
    read changeWallpaper
    if [[ "$changeWallpaper" =~ ^[Yy]$ ]]; then
        # Choose a random URL
        randomUrl=$(shuf -n 1 <<< "$wallpaperUrls")
        wallpaperPath="/home/$USER/Pictures/wallpaper.jpg"
        wget -progress=bar:force -O "$wallpaperPath" "$randomUrl"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaperPath"
        clear
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
cd ~/tor-browser
./start-tor-browser.desktop --register-app
echo "alias tor='cd ~/tor-browser && ./start-tor-browser.desktop'" >> ~/.bashrc
echo "alias tor='cd ~/tor-browser && ./start-tor-browser.desktop'" >> ~/.bashrc
}

installhist () {
    echo ""
    echo "install history:"
    cat /var/log/dpkg.log.1 /var/log/dpkg.log | grep " install " | nl

}


menu () {
    while true
    do
        clear
        cd ~
        echo -e "\033[0;32mCHOOSE OPTIONS TO SETUPS:\033[0m"
        echo ""
        echo ""
        echo -e "\033[0;32m0.	UPDATE SYSTEM \033[0m"
        echo ""
        echo -e "\033[0;32m1.	IPV6 TO IPV4 \033[0m"
        echo -e "\033[0;32m2.	FIREWALL \033[0m"
        echo -e "\033[0;32m3.	FIREWALL II (PORTMASTER) \033[0m"
        echo -e "\033[0;32m4.	BASIC DEPS \033[0m"
        echo -e "\033[0;32m5.	VPN \033[0m"
        echo -e "\033[0;32m6.	BRAVE-BROWSER \033[0m"
        echo -e "\033[0;32m7.	GUEST ADDITIONS FOR VM \033[0m"
        echo -e "\033[0;32m8.	GIT \033[0m"
        echo -e "\033[0;32m9.	AESCRYPT \033[0m"
        echo -e "\033[0;32m10.	APPEARANCE \033[0m"
        echo ""
        echo -e "\033[0;32m11.	TOR BROWSER \033[0m"
        echo ""
        echo -e "\033[0;32m12.	OPTIONS 1-11 \033[0m"
        echo -e "\033[0;32m13.	ALL 0-11 \033[0m"
        echo ""
        echo -e "\033[0;32m14.	SHOW INSTALL HISTORY \033[0m"
        echo -e "\033[0;32m15.	ADD EXTRAS \033[0m"
        echo ":"
        read option
       
        if [ ${option} -eq 0 ]; then
            clear && updatesys
        elif [ ${option} -eq 1 ]; then
            ipvchange
        elif [ ${option} -eq 2 ]; then
            firewallinst
        elif [ ${option} -eq 3 ]; then
            firewalliiinst
        elif [ ${option} -eq 4 ]; then 
            basicdeps
        elif [ ${option} -eq 5 ]; then
            vpninst
        elif [ ${option} -eq 6 ]; then 
            braveinst
        elif [ ${option} -eq 7 ]; then 
            guestinst
        elif [ ${option} -eq 8 ]; then 
            gitinst
        elif [ ${option} -eq 9 ]; then 
            aescryptinst
        elif [ ${option} -eq 10 ]; then 
            appearance
        elif [ ${option} -eq 11 ]; then 
            torinst
        elif [ ${option} -eq 12 ]; then 
            ipvchange && firewallinst && firewalliiinst && basicdeps && vpninst && braveinst && guestinst && gitinst && aescryptinst && appearance && torinst
        elif [ ${option} -eq 13 ]; then 
            updatesys && ipvchange && firewallinst && firewalliiinst && basicdeps && vpninst && braveinst && guestinst && gitinst && aescryptinst && appearance && torinst 
        elif [ ${option} -eq 14 ]; then
            installhist
        elif [ ${option} -eq 15 ]; then
            extras
        else
            echo "wrong option"
        fi
        echo "Press any key to continue..."
        read -n 1 -s
    done
}

menu
