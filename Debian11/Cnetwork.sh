#!/bin/bash

echo "Configuring network secure policies"
#----------------------------------------#

# 3.1.1
sudo printf "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
# [UNCONFIGURED] 3.1.2
# 3.1.3
sudo systemctl stop bluetooth.service
sudo apt purge bluez -y

# [UNCONFIGERED] 3.2.*

# 3.3.1
#sudo printf "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
sudo sysctl -w net.ipv4.ip_forward=0
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.2
#sudo printf "net.ipv4.conf.all.send_redirects = 0
#net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf
sudo sysctl -w net.ipv4.conf.all.send_redirects=0
sudo sysctl -w net.ipv4.conf.default.send_redirects=0
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.3
#sudo printf "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
sudo sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.4
#sudo printf "net.ipv4.icmp_echo_ignore_broadcasts = 1" >>  /etc/sysctl.conf
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
# 3.3.5
#sudo printf "net.ipv4.conf.all.accept_redirects = 0
#net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.default.accept_redirects=0
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.6
# sudo printf "net.ipv4.conf.all.secure_redirects = 0
# net.ipv4.conf.default.secure_redirects = 0" >>  /etc/sysctl.conf
sudo sysctl -w net.ipv4.conf.all.secure_redirects=0
sudo sysctl -w net.ipv4.conf.default.secure_redirects=0
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.7
sudo sysctl -w net.ipv4.conf.all.rp_filter=1
sudo sysctl -w net.ipv4.conf.default.rp_filter=1
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.8
sudo sysctl -w net.ipv4.ip_forward=0
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.9
sudo sysctl -w net.ipv4.conf.all.accept_source_route=0
sudo sysctl -w net.ipv4.conf.default.accept_source_route=0
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.10
sudo sysctl -w net.ipv4.conf.all.log_martians=1
sudo sysctl -w net.ipv4.conf.default.log_martians=1
sudo sysctl -w net.ipv4.route.flush=1
# 3.3.11
sudo sysctl -w net.ipv6.conf.all.accept_ra=0
sudo sysctl -w net.ipv6.conf.default.accept_ra=0
sudo sysctl -w net.ipv6.route.flush=1

# 3.4.1 Configuring Firewall!!
sudo apt install ufw -y
sudo apt purge iptables-persistent -y
sudo apt purge nftables -y
sudo ufw allow proto tcp from any to any port 22
sudo ufw --force enable
sudo ufw allow in on lo
sudo ufw allow out on lo
sudo ufw deny in from 127.0.0.0/8
sudo ufw deny in from ::1
sudo ufw allow out on all
sudo ufw allow from 192.168.1.0/24 to any proto tcp port 443
sudo ufw allow git
sudo ufw allow in http
sudo ufw allow out http
sudo ufw allow in https
sudo ufw allow out https 
sudo ufw allow out 53
sudo ufw logging on
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw default deny routed

# 3.4.2 nftables [SKIPPED] clashes with ufw
# 3.4.3 iptables [SKIPPED] clashes with ufw
