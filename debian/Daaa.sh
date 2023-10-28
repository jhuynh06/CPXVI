#!/usr/bin/env bash

echo "Configuring AAA policies"
#-----------------------------#

# 4.1.1
serviceName = "cron"
if { systemctl --all --type service || service --status-all; } 2>/dev/null | grep -q "$serviceName"; then
    sudo systemctl unmask cron
    sudo systemctl --now enable cron
    sudo chown root:root /etc/crontab
    sudo chmod og-rwx /etc/crontab
    sudo chown root:root /etc/cron.hourly/
    sudo chmod og-rwx /etc/cron.hourly/
    sudo chown root:root /etc/cron.daily/
    sudo chmod og-rwx /etc/cron.daily/
    sudo chown root:root /etc/cron.weekly/
    sudo chmod og-rwx /etc/cron.weekly/
    sudo chown root:root /etc/cron.monthly/
    sudo chmod og-rwx /etc/cron.monthly/
    sudo chown root:root /etc/cron.d/
    sudo chmod og-rwx /etc/cron.d/
    sudo chown root:crontab /etc/cron.allow
    sudo chmod u-x,g-wx,o-rwx /etc/cron.allow
else
  echo "$serviceName does NOT exist."
done

# 4.2.* SSHD CONFIG (only use if SSHD is required)
sudo apt install ssh
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
sudo{
 chmod u-x,og-rwx /etc/ssh/sshd_config
 chown root:root /etc/ssh/sshd_config
 while IFS= read -r -d $'\0' l_file; do
 if [ -e "$l_file" ]; then
 chmod u-x,og-rwx "$l_file"
 chown root:root "$l_file"
 fi
 done < <(find /etc/ssh/sshd_config.d -type f -print0)
}

sudo gedit /etc/ssh/sshd_config
: <<'END'
PermitRootLogin no
HostbasedAuthentication no
PermitEmptyPasswords no
PermitUserEnvironment no
IgnoreRhosts yes
X11Forwarding no
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128-etm@openssh.com,umac-128@openssh.com
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
AllowTcpForwarding no
Banner /etc/issue.net
MaxAuthTries 4
MaxStartups 10:30:60
LoginGraceTime 60
MaxSessions 10
ClientAliveInterval 15
ClientAliveCountMax 3
ClientAliveCountMax 1
ClientAliveInterval 600
MACs hmac-sha2-512,hmac-sha2-256
Ciphers aes256-ctr,aes192-ctr,aes128-ctr
X11UseLocalhost yes
systemctl reload sshd.service
systemctl restart sshd.service
END

# 4.2.26 [UNCONFIGURED]

# 4.3.1-7 [UNCONFIGURED]

# 4.3.8 PAM - RUN WITH CAUTION
# sudo printf "auth required pam_wheel.so use_uid group=sugroup" >> /etc/pam.d/su
# sudo printf "password requisite pam_pwquality.so retry=3" >> /etc/pam.d/common-password
# sudo printf "password required pam_pwhistory.so remember=5 use_authtok" >> /etc/pam.d/common-password
# sudo printf "account required pam_faillock.so" >> /etc/pam.d/common-account (END OF FILE)
# sudo printf "auth [success=2 default=ignore] pam_pkcs11.so" >> /etc/ssh/sshd_config
# sudo printf "cert_policy = ca,signature,ocsp_on, crl_auto;" >> /etc/pam/_pkcs11/pam_pkcs11.conf
# sudo printf "session required pam_lastlog.so showfailed" >> /etc/pam.d/login
# sudo printf "auth required pam_faildelay.so delay=400000" >> /etc/pam.d/common-auth
# sudo printf "session optional pam_umask.so" >> /etc/login.defs


# 4.4.1 PASSWORDS
sudo apt-get install libpam-pwquality -y
sudo gedit /etc/security/pwquality.conf
: <<'END'
enforcing = 1
minlen = 15
minclass = 4
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
maxrepeat = 3
difok = 8
dictcheck = 1
END

# 4.4.3 
sudo gedit /etc/security/faillock.conf
: <<'END'
deny=5
unlock_time=900
fail_interval = 900
even_deny_root
END

# 4.4.5.1
# add "offline_credentials_expiration = 1" below line that says [pam]

# 4.4.6.1
sudo apt install libpam-pkcs11 -y
sudo apt-get install opensc-pkcs11 -y

# 4.4.6.3 [UNCONFIGURED]

# 4.4.6.4 
# add "PubkeyAuthentication yes" to /etc/ssh/sshd_config

sudo{
 UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
 awk -F: -v UID_MIN="${UID_MIN}" '( $3 >= UID_MIN && $1 != "nfsnobody" ) { 
print $1 }' /etc/passwd | xargs -n 1 chage -d 0
}

# 4.5.1.1
sudo gedit /etc/login.defs
: <<'END'
PASS_MIN_DAYS 1
PASS_MAX_DAYS 60
PASS_WARN_AGE 7
ENCRYPT_METHOD SHA512
END

# 4.5.1.4
sudo useradd -D -f 30
# sudo chage -E $(date -d "+3 days" +%F) system_account_name #TEMP ACCOUNT
sudo passwd -l root
# sudo chage -E $(date -d "+3 days" +%F) account_name #TEMP ACCOUNT
# sudo passwd -e [username of newly created user]

# 4.5.2 lock non-root accounts
# usermod -L <user>

# 4.5.3
sudo usermod -g 0 root
# 4.5.5* [UNCONFIGURED]

sudo sed -iE 's/^([^!#]+)/!\1/' /etc/ca-certificates.conf
sudo update-ca-certificates
