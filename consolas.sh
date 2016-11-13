#!/bin/sh

# http://www.rushis.com/consolas-font-on-ubuntu/
# basic procedure is:
#  1. $ sudo apt-get install font-manager
#  2. $ sudo apt-get install cabextract
#  3. $ cd
#  4. $ consolas.sh   # (i.e. run this script)
#  5. $ cd temp       # the above command has created a [temp] directory: cd into it.
#  5. $ sudo mkdir -p /usr/share/fonts/truetype/consolas
#  6. $ sudo cp CONSOLA*.TTF /usr/share/fonts/truetype/consolas
#  7. $ sudo fc-cache -fv
#  8. launch LibreOffice to verify that the new font (consolas) is visible
#  9. if need be, reboot
# 10. cd && rm -fr temp

set -e
set -x
mkdir temp
cd temp
wget http://download.microsoft.com/download/E/6/7/E675FFFC-2A6D-4AB0-B3EB-27C9F8C8F696/PowerPointViewer.exe
cabextract -L -F ppviewer.cab PowerPointViewer.exe
cabextract ppviewer.cab
