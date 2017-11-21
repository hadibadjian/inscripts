# inscripts
A collection of scripts to automate installation and configuration of tools and applications.

  > __NOTE__:
  > These scripts are not fully automated. Minimal user input is required.

## Installations
- [fail2ban](scripts/install-fail2ban.sh)
- [Git](scripts/install-git.sh)
- [Nginx](scripts/install-nginx.sh)
- [Node.js](scripts/install-nodejs.sh)
- [NTP](scripts/install-ntp.sh)
- [OpenSSH](scripts/install-openssh-server.sh)
- [postgres](scripts/install-postgres.sh)
- [Ruby](scripts/install-ruby.sh)

## Configurations
- [Nginx Proxy](scripts/config-nginx-proxy.sh)
- [Nginx vhost](scripts/config-nginx-vhost.sh)
- [UFW](scripts/config-firewall.sh)

# Rails, Nginx and Postgres Stack

Tested on __Ubuntu Server Xenial 16.04__.

```bash
# Upgrade installed packages.
apt-get update && apt-get upgrade -y

# Install dependencies.
apt-get install -y curl unzip ntp software-properties-common libpq-dev

# Get inscripts.
wget https://github.com/hadibadjian/inscripts/archive/master.zip
unzip master.zip

cd isncripts-master/scripts/

install-ntp.sh
install-fail2ban.sh
install-nginx.sh
install-git.sh
install-nodejs.sh

# Whitelist IPs for incoming SSH connection.
config-firewall.sh

install-ruby.sh

# create deploy user
sudo adduser deploy
# Add deploy to rvm group
sudo adduser deploy rvm

install-openssh-server.sh
# Once OpenSSH daemon is configured, root access via SSH is blocked.
# Configure deploy's SSH access via public key.
# Disable SSH password authentication and restart SSH daemon service.

config-nginx-conf.sh
config-nginx-vhost.sh

sudo adduser postgres
install-postgres.sh
```
