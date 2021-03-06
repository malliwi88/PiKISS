#!/bin/bash
#
# Description : Portable ZX-Spectrum emulator by JFroco
# Author      : Jose Cerrejon Gonzalez (ulysess@gmail_dot._com)
# Version     : 1.4 (18/Apr/16)
# Compatible  : Raspberry Pi 1 & 2 (tested)
#
# To do       : Add ZEsarUX: http://sourceforge.net/projects/zesarux/files/ZEsarUX-2.1/ZEsarUX_bin-2.1-raspbian7.tar.gz/download
#
clear

INSTALL_DIR="/home/$USER/games/"
URL_FILE="https://bitbucket.org/djdron/unrealspeccyp/downloads/unreal-speccy-portable_0.0.64_rpi.zip"

mkDesktopEntry() {
	if [[ ! -e /usr/share/applications/speccy.desktop ]]; then
        sudo wget http://quantum-bits.org/tango/icons/computer-sinclair-zx-spectrum.png -O /usr/share/pixmaps/spectrum.png
		sudo sh -c 'echo "[Desktop Entry]\nName=Speccy (ZX Spectrum)\nComment=Speccy emulates some versions of Sinclair ZX Spectrum.\nExec='$INSTALL_DIR'/usp_0.0.64/unreal_speccy_portable\nIcon=/usr/share/pixmaps/spectrum.png\nTerminal=false\nType=Application\nCategories=Application;Game;\nPath='$HOME'/usp_0.0.64/unreal_speccy_portable/" > /usr/share/applications/speccy.desktop'
	fi
}

validate_url()
{
    if [[ `wget -S --spider $1 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true"; fi
}

playgame()
{
    if [[ -f $INSTALL_DIR/usp_0.0.64/ninjajar.tap ]]; then
        read -p "Do you want to play NinJaJar now? [y/n] " option
        case "$option" in
            y*) cd $INSTALL_DIR/usp_0.0.64/ && ./unreal_speccy_portable ninjajar.tap ;;
        esac
    fi
}

changeInstallDir()
{
    echo "Enter new full path:"
    read INSTALL_DIR
    echo "New path: $INSTALL_DIR"
}

install()
{
    if [[ ! -f $INSTALL_DIR/usp_0.0.64/unreal_speccy_portable ]]; then
        mkdir -p $INSTALL_DIR && cd $_
        wget -qO- -O tmp.zip $URL_FILE && unzip -o tmp.zip && rm tmp.zip
        cd us*
        chmod +x unreal_speccy_portable
        wget -O $INSTALL_DIR/usp_0.0.64/ninjajar.tap http://www.mojontwins.com/juegos/mojon-twins--ninjajar-eng-v1.1.tap
        mkDesktopEntry
    fi
    echo "Done!. To play go to install path, copy any .tap file to directory and type: ./unreal_speccy_portable <game name>"
    playgame
    read -p "Press [Enter] to continue..."
    exit
}

echo -e "Portable ZX-Spectrum emulator (unrealspeccyp ver. 0.0.64)\n=========================================================\n\n· More Info: https://bitbucket.org/djdron/unrealspeccyp\n· Add Ninjajar\n\nInstall path: $INSTALL_DIR/usp_0.0.64"
while true; do
    echo " "
    read -p "Is it right? [y/n] " yn
    case $yn in
    [Yy]* ) echo "Installing, please wait..." && install;;
    [Nn]* ) changeInstallDir;;
    [Ee]* ) exit;;
    * ) echo "Please answer (y)es, (n)o or (e)xit.";;
    esac
done
