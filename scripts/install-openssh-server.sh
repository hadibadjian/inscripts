#!/usr/bin/env bash

LISTEN_ADDRESS=0.0.0.0
SSHD_CONFIG_PATH='/etc/ssh/sshd_config'

sudo apt-get install -y openssh-server

sudo mv ${SSHD_CONFIG_PATH} /etc/ssh/sshd_config.original
sudo chmod a-w /etc/ssh/sshd_config.original

touch ${SSHD_CONFIG_PATH}

config="
Protocol 2
ListenAddress ${LISTEN_ADDRESS}
Port 22

Ciphers aes256-cbc,aes256-ctr
HostKeyAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-rsa,ssh-dss
KexAlgorithms ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521
MACs hmac-sha2-256,hmac-sha2-512

HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

UsePrivilegeSeparation yes

SyslogFacility AUTH
LogLevel VERBOSE

LoginGraceTime 30
PermitRootLogin no
StrictModes yes

PubkeyAuthentication yes
AuthorizedKeysFile /etc/ssh/authorized-keys/%u

IgnoreRhosts yes
HostbasedAuthentication no
IgnoreUserKnownHosts yes

PermitEmptyPasswords no

UsePAM yes
ChallengeResponseAuthentication yes
PasswordAuthentication no

X11Forwarding no
PrintLastLog yes
TCPKeepAlive yes

Banner /etc/issue.net

Subsystem sftp /usr/lib/openssh/sftp-server
"

echo "${config}" | sudo tee "${SSHD_CONFIG_PATH}"

sudo systemctl restart sshd.service
