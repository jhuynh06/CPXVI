#! /bin/bash

echo "Disabling root login on ssh"

if grep -qF 'PermitRootLogin' /etc/ssh/sshd_config; then
	sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config
else
	echo 'PermitRootLogin no' >>/etc/ssh/sshd_config
fi

sudo ufw allow from 202.54.1.5/29 to any port 22
