#!/bin/bash
xterm -e "ssh -D 1080 hosting" &
sudo sh -c "/bin/cp /home/mperdikeas/.Xauthority /home/slash"
sudo sh -c "/bin/chown slash.slash /home/slash/.Xauthority"
sudo sh -c "/bin/chmod 640 /home/slash/.Xauthority"
sudo sh -c "/bin/su - slash"
