#!/usr/bin/env bash
set -e
printf "\n\n\n\nSource:\n\t\http://ubuntuhandbook.org/index.php/2014/10/emacs-24-4-released-install-in-ubuntu-14-04/\n\n"
sudo apt-get install build-essential
sudo apt-get build-dep emacs24
cd ~/Downloads
wget http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.xz
tar -xf emacs-24.5.tar.xz
cd emacs-24.5
./configure
make
sudo make install
cd ..
sudo rm -fr emacs-24.5
rm emacs-24.5.tar.xz
