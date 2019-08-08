#!/bin/bash
# pyRAT v1.0
# Coded by @linux_choice (Don't change! Read the License!)
# Github: https://github.com/thelinuxchoice/pyRAT
# Changed by: Nat-As
# Github: https://github.com/Nat-As/pyRAT

if [[ "$(id -u)" -ne 0 ]]; then
    printf "\e[1;77mPlease, run this program as root!\n\e[0m"
    exit 1
fi

#Install/Update Wine
apt-get update && apt-get install wine 

if [[ ! -d ~/.wine/drive_c/Python37/ ]]; then

    # This could have all been done with: winetricks python2.7
    # However Python2.7 is Deprecated, merge to Python3 to follow best programming practices

    #printf "\e[1;93mDownloading Python2.7\e[0m\n"
    #wget https://www.python.org/ftp/python/2.7.15/python-2.7.15.msi
    #printf "\e[1;93mInstalling Python2.7, you must continue the installation manually\e[0m\n"
    #wine msiexec /i python-2.7.15.msi /L*v log.txt
    #printf "\e[1;93mInstalling wine32\e[0m\n"

    # local installation of wine 64 with Python3 support
    sudo apt-get install git
    sudo git clone https://github.com/bitranox/lib_bash_wine.git /usr/local/lib_bash_wine
    sudo chmod -R 0755 /usr/local/lib_bash_wine
    sudo chmod -R +x /usr/local/lib_bash_wine/*.sh
    sudo /usr/local/lib_bash_wine/install_or_update.sh
    export wine_release="devel"

    # Install wine
    /usr/local/lib_bash_wine/001_000_install_wine.sh

    #############################################
    # Install Wine Machine 2 (64 Bit)
    #############################################
    # set Wine Prefix for Machine_1 (64 Bit)
    export WINEPREFIX=${HOME}/wine/wine64_machine_1
    # set Architecture to 64 Bit
    export WINEARCH="win64"
    export DISPLAY=:0
    # set winetricks_windows_version to report, defaults to "win10"
    export winetricks_windows_version="win10"
    /usr/local/lib_bash_wine/002_000_install_wine_machine.sh

    #############################################
    # install python 3.7 64 Bit Version on Machine
    #############################################
    # set Wine Prefix for Machine 2 (64 Bit)
    export WINEPREFIX=${HOME}/wine/wine64_machine_1
    # set Architecture to 64 Bit
    export WINEARCH="win64"
    export DISPLAY=:0
    # next step is to install python 3.7 on the Wine Machine
    printf "\e[1;93mInstalling Python3.7 dependencies\e[0m\n"
    /usr/local/lib_bash_wine/003_000_install_win_python3_preinstalled.sh
    wine python3.exe Scripts/pip3.exe install pyinstaller paramiko


    # Deprecated: use 64 bit win10 machine instead
    #dpkg --add-architecture i386 && apt-get update && apt-get install wine32
    #cd ~/.wine/drive_c/Python27/
    #printf "\e[1;93mInstalling Python2.7 dependencies\e[0m\n"
    #wine python.exe Scripts/pip.exe install pyinstaller paramiko

else
    exit 1
fi

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Configuring PHP (php.ini)\n"
sed -i -e 's+upload_max_filesize = 2M+upload_max_filesize = 100M+g' $(php -i | grep -i "loaded configuration file" | cut -d ">" -f2)

printf "\e[1;92mDone!\e[0m\n"
