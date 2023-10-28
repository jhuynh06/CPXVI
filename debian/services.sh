#!/usr/bin/env bash

echo "Configuring services"
#-----------------------#
sudo systemctl enable chrony.service
sudo systemctl enable systemd-timesyncd.service
sudo systemctl enable ntp.service

sudo systemctl stop avahi-daemon.service
sudo systemctl stop avahi-daemon.socket
sudo apt purge avahi-daemon

declare -a service_names=("cups" "isc-dhcp-server" "slapd" "nfs-kernel-server" "bind9" "vsftpd" "pure-ftpd" "apache2" "dovecot-imapd" "dovecot-pop3d" "samba" "squid" "snmpd" "nis" "dnsmasq" "telnetd" "rsync" "rsh-server" "nis" "rsh-client" "talk" "telnet" "ldap-utils" "rpcbind")
for service in "${service_names[@]}"
do
    sudo systemctl stop $service.socket
    sudo systemctl stop $service.service
    sudo systemctl mask $service.socket
    sudo systemctl mask $service.service
done

sudo apt purge cups
sudo apt purge isc-dhcp-server
sudo apt purge slapd
sudo apt purge nfs-kernel-server
sudo apt purge bind9
sudo apt purge vsftpd
sudo apt purge pure-ftpd
sudo apt purge apache2
sudo apt purge dovecot-imapd dovecot-pop3d
sudo apt purge samba
sudo apt purge squid
sudo apt purge snmpd
sudo apt purge nis
sudo apt purge dnsmasq

# Configure post-fix:
# sudo gedit /etc/postfix/main.cf >> inet_interfaces = loopback-only >> sudo systemctl restart postfix

sudo apt-get remove telnetd
sudo apt purge rsync
sudo apt-get remove rsh-server
sudo apt purge nis
sudo apt purge rsh-client
sudo apt purge talk
sudo apt purge telnet
sudo apt purge ldap-utils
sudo apt purge rpcbind

ss -plntu
echo "common services configured"