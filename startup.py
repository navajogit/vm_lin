import subprocess
import os
import random
import shutil

def doner():
    print("\033[0;32mDONE \033[0m")

def updatesys():
    subprocess.run(["sudo", "apt", "update", "-y"])
    subprocess.run(["sudo", "apt", "upgrade", "-y"])
    subprocess.run(["sudo", "apt", "autoremove", "-y"])

def ipvchange():
    ipv6_setting = subprocess.check_output(["gsettings", "get", "org.gnome.system.network", "ipv6-method"]).decode().strip()

    if ipv6_setting != "'disabled'":
        print("Disabling IPv6 ...")
        subprocess.run(["gsettings", "set", "org.gnome.system.network", "ipv6-method", "'disabled'"])
        print(" IPv6 'disabled'.")
    else:
        print("IPv6 is set to 'disabled'.")

    subprocess.run(["nmcli", "connection", "modify", "Wired connection 1", "ipv6.method", "disabled"])
    subprocess.run(["sudo", "systemctl", "restart", "NetworkManager"])
    time.sleep(1)

def basicdeps():
    subprocess.run(["sudo", "apt", "install", "curl", "-y"])
    subprocess.run(["sudo", "apt", "install", "wget", "-y"])

def firewallinst():
    subprocess.run(["sudo", "apt", "install", "ufw", "-y"])
    subprocess.run(["sudo", "ufw", "enable"])
    subprocess.run(["sudo", "ufw", "limit", "22/tcp"])
    subprocess.run(["sudo", "ufw", "allow", "80/tcp"])
    subprocess.run(["sudo", "ufw", "allow", "443/tcp"])
    subprocess.run(["sudo", "ufw", "default", "deny", "incoming"])
    subprocess.run(["sudo", "ufw", "default", "allow", "outgoing"])
    subprocess.run(["sudo", "apt-get", "install", "git", "-y"])

def vpninst():
    subprocess.run(["wget", "https://windscribe.com/install/desktop/linux_deb_x64/windscribe_2.7.14_amd64.deb", "-O", "~/Downloads/windscribe.deb"])
    subprocess.run(["sudo", "dpkg", "-i", "~/Downloads/windscribe.deb"])
    subprocess.run(["shred", "-uz", "~/Downloads/windscribe.deb"])

def firewalliiinst():
    subprocess.run(["sudo", "apt", "install", "libnetfilter-queue1", "-y"])
    subprocess.run(["wget", "https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.deb", "-O", "~/Downloads/portmaster.deb"])
    subprocess.run(["sudo", "dpkg", "-i", "~/Downloads/portmaster.deb"])
    subprocess.run(["sudo", "systemctl", "enable", "portmaster"])
    subprocess.run(["shred", "-uzv", "~/Downloads/portmaster.deb"])

def braveinst():
    subprocess.run(["sudo", "curl", "-fsSLo", "/usr/share/keyrings/brave-browser-archive-keyring.gpg", "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"])
    subprocess.run(["echo", "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main", "|", "sudo", "tee", "/etc/apt/sources.list.d/brave-browser-release.list"])
    subprocess.run(["sudo", "apt", "update", "-y"])
    subprocess.run(["sudo", "apt", "install", "brave-browser", "-y"])

def guestinst():
    subprocess.run(["sudo", "apt", "install", "liburing2", "-y"])
    subprocess.run(["sudo", "apt", "install", "qemu-guest-agent", "-y"])
    subprocess.run(["sudo", "apt-get", "install", "spice-vdagent", "-y"])

def gitinst():
    subprocess.run(["sudo", "apt", "install", "git", "-y"])

def aescryptinst():
    if shutil.which("aescrypt") is None:
        print("Aescrypt is not installed. Installing...")
        os.chdir("~/Downloads")
        subprocess.run(["wget", "https://github.com/navajogit/aescrypt/raw/main/aescrypt-3.16.tgz"])
        subprocess.run(["tar", "-xzf", "aescrypt-3.16.tgz"])
        os.chdir("aescrypt-3.16")
        subprocess.run(["make"])
        subprocess.run(["sudo", "make", "install"])
        subprocess.run(["shred", "-uz", "~/Downloads/aescrypt-3.16.tgz"])
        shutil.rmtree("~/Downloads/aescrypt-3.16")
        os.chdir("~")
        print("Aescrypt was installed.")
    else:
        print("Aescrypt is already installed on your system.")

def appearance():
    githubRepoUrl = "https://raw.githubusercontent.com/navajogit/vm_lin/main/sample_list.txt"
    wallpaperUrls = subprocess.check_output(["curl", "-s", githubRepoUrl]).decode().splitlines()

    while True:
        changeWallpaper = input("\033[0;32mDo you want to change the desktop wallpaper? (Y/N)\033[0m")
        if changeWallpaper.lower() == 'y':
            randomUrl = random.choice(wallpaperUrls)
            wallpaperPath = f"/home/{os.getenv('USER')}/Pictures/wallpaper.jpg"
            subprocess.run(["wget", "-progress=bar:force", "-O", wallpaperPath, randomUrl])
            subprocess.run(["gsettings", "set", "org.gnome.desktop.background", f"picture-uri-dark", f"file://{wallpaperPath}"])
            clear()
            print("DONE")
        else:
            clear()
            print("DONE")
            break

def torinst():
    subprocess.run(["wget", "https://www.torproject.org/dist/torbrowser/13.0/tor-browser-linux-x86_64-13.0.tar.xz", "-O", "tor-browser-linux-x86_64-13.0.tar.xz"])
    subprocess.run(["tar", "-xf", "tor-browser-linux-x86_64-13.0.tar.xz"])
    subprocess.run(["chmod", "+x", "tor-browser-linux-x86_64-13.0.tar.xz"])
    os.chdir("~/tor-browser")
    subprocess.run(["./start-tor-browser.desktop", "--register-app"])
    with open(os.path.expanduser("~/.bashrc"), "a") as bashrc:
        bashrc.write("\nalias tor='cd ~/tor-browser && ./start-tor-browser.desktop'\n")
    with open(os.path.expanduser("~/.zshrc"), "a") as zshrc:
        zshrc.write("\nalias tor='cd ~/tor-browser && ./start-tor-browser.desktop'\n")

def installhist():
    print("\ninstall history:")
    dpkg_logs = subprocess.check_output(["cat", "/var/log/dpkg.log.1", "/var/log/dpkg.log"]).decode().splitlines()
   
