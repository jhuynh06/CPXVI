#! /bin/bash

echo "Updating..."

apt-get update && apt-get upgrade && apt-get dist-upgrade
sudo dpkg-reconfigure -plow unattended-upgrades
