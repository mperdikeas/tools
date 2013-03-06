#!/bin/bash
cd /tmp
rm NeuroCode.tar.gz
wget http://172.31.128.119/NeuroCode/NeuroCode.tar.gz || exit 1
sudo rm -rf /opt/NeuroCode.old || exit 1
sudo mv /opt/NeuroCode /opt/NeuroCode.old || exit 1
sudo tar -C /opt/ -xvf NeuroCode.tar.gz || exit 1
sudo rm /opt/NeuroCode/bin/Mono.Security.dll
