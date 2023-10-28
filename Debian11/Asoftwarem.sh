#!/bin/bash

echo "Configuring software and patch management"
#----------------------------------------------#

secure_pass = "@hF!mPj8,RdpcBK4"
root_pass = "T3ws5@DjUagP"

# [NOT CONFIGURED] 1.2.4
# [NOT CONFIGURED] 1.2.5

# 1.3.*
sudo grub-mkpasswd-pbkdf2
$secure_pass
$secure_pass
chown root:root /boot/grub/grub.cfg
chmod u-x,go-rwx /boot/grub/grub.cfg
passwd root
$root_pass
$root_pass

# [NOT CONFIGURED] 1.4.1

# 1.4.2-4
sudo sysctl -w kernel.randomize_va_space=2
sudo sysctl -w kernel.yama.ptrace_scope=1
sudo prelink -ua
sudo apt purge prelink -y

# 1.4.5 congfiguring max logins
grep maxlogins /etc/security/limits.conf | grep -v '^* hard maxlogins'
sed -i -e '1i* hard maxlogins 10\' /etc/security/limits.conf
# 1.4.6*
sudo apt purge apport -y
sudo systemctl disable kdump.service
echo "* hard core 0" >> /etc/security/limits.conf
sudo sysctl -w fs.suid_dumpable=0
sudo systemctl mask ctrl-alt-del.target
sudo systemctl daemon-reload
sudo sysctl -w kernel.dmesg_restrict=1

# 1.5.1
sudo apt install apparmor apparmor-utils -y
grep -F "GRUB_CMDLINE_LINUX=" /etc/default/grub | sed -ie 's/$/& "apparmor=1 security=apparmor"/g'
sudo update-grub
sudo apt-get install apparmor -y
sudo systemctl enable apparmor.service
sudo systemctl start apparmor.service
sudo aa-enforce /etc/apparmor.d/*

# 1.6.1 Intializing MOD
#echo "Authorized use only. All activity may be monitored and reported." > /etc/issue.net
sudo chown root:root $(readlink -e /etc/motd)
sudo chmod u-x,go-wx $(readlink -e /etc/motd)
sudo chown root:root $(readlink -e /etc/issue)
sudo chmod u-x,go-wx $(readlink -e /etc/issue)
sudo chown root:root $(readlink -e /etc/issue.net)
sudo chmod u-x,go-wx $(readlink -e /etc/issue.net)

# 1.7.1
sudo apt purge gdm3 -y
# [NOT CONFIGURED] 1.7.4-6
# 1.7.7
sudo gsettings set org.gnome.desktop.screensaver lock-enabled true
# [NOT CONFIGURED] 1.7.8-10
# 1.7.11
sudo sed -i "/\bEnable=true\b/d" myfile
# [NOT CONFIGURED] 1.7.12
sudo echo "logout=''" >> /etc/dconf/db/local.d/*

# 1.8.1
sudo apt install vlock -y
sudo apt-get install mcafeetp -y