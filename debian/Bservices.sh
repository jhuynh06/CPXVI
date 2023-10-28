#!/usr/bin/env bash

echo "Configuring services"
#-------------------------#
sudo systemctl enable chrony.service
sudo systemctl enable systemd-timesyncd.service
sudo systemctl enable ntp.service

sudo systemctl stop avahi-daemon.service
sudo systemctl stop avahi-daemon.socket
sudo apt purge avahi-daemon -y

declare -a service_names=("cups" "isc-dhcp-server" "slapd" "nfs-kernel-server" "bind9" "vsftpd" "pure-ftpd" "apache2" "dovecot-imapd" "dovecot-pop3d" "samba" "squid" "snmpd" "nis" "dnsmasq" "telnetd" "rsync" "rsh-server" "nis" "rsh-client" "talk" "telnet" "ldap-utils" "rpcbind")
for service in "${service_names[@]}"
do
    sudo systemctl stop $service.socket
    sudo systemctl stop $service.service
    sudo systemctl mask $service.socket
    sudo systemctl mask $service.service
done

sudo apt purge cups -y
sudo apt purge isc-dhcp-server -y
sudo apt purge slapd -y
sudo apt purge nfs-kernel-server -y
sudo apt purge bind9 -y
sudo apt purge vsftpd -y
sudo apt purge pure-ftpd -y
sudo apt purge apache2 -y
sudo apt purge dovecot-imapd dovecot-pop3d -y
sudo apt purge samba -y
sudo apt purge squid -y
sudo apt purge snmpd -y
sudo apt purge nis -y
sudo apt purge dnsmasq -y

# Configure post-fix:
# sudo gedit /etc/postfix/main.cf >> inet_interfaces = loopback-only >> sudo systemctl restart postfix

sudo apt-get remove telnetd -y
sudo apt purge rsync -y
sudo apt-get remove rsh-server -y
sudo apt purge nis -y
sudo apt purge rsh-client -y
sudo apt purge talk -y
sudo apt purge telnet -y
sudo apt purge ldap-utils -y
sudo apt purge rpcbind -y

ss -plntu
echo "common services configured"