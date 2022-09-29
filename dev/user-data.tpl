#!/bin/bash

##### replace PHP Session redis endpoint ##########################
echo "======Updating the package==="
apt update
apt install apache2
apt install openjdk-11-jdk
#####services####
echo "======installing the paache==="
systemctl status apache2
systemctl enable apache2
systemctl start apache2
systemctl status apache2
