# Rails, Nginx and Postgres Stack

- [ ] Upgrade installed packages.

  `apt-get update && apt-get upgrade -y`

- [ ] Install dependencies.

  `apt-get install -y curl unzip ntp software-properties-common libpq-dev`

- [ ] Get inscripts.

  ```bash
  wget https://github.com/hadibadjian/inscripts/archive/master.zip
  unzip master.zip
  cd isncripts-master/scripts/
  ```

- [ ] Install and configure required applications.

  ```bash
  ./install-ntp.sh
  ./install-nginx.sh
  ./install-fail2ban.sh
  ./install-git.sh
  ./install-nodejs.sh
  ./install-unattended-upgrades.sh
  ./config-logrotate.sh
  ```

- [ ] Setup firewall (allow HTTP, HTPS and SSH). You may want to whitelist IP addresses for SSH connection.

  __Note__: Remember to modify the IP address before executing the command.

  `./config-firewall.sh`

- [ ] Install rvm, ruby and bundler.

  __Note__: Remember to set the required ruby version before executing the command.

  `./install-ruby.sh`

- [ ] Create non-privileged _deploy_ user.

  ```bash
  sudo adduser deploy
  # Add deploy to rvm group
  sudo adduser deploy rvm
  ```

- [ ] Setup / Configure SSH daemon.

  + Once OpenSSH daemon is configured, root access via SSH is blocked.
  + Configure _deploy_'s SSH access via public key.
  + Disable SSH password authentication and restart SSH daemon service (`ChallengeResponseAuthentication no`).

  `./install-openssh-server.sh`

- [ ] Configure Nginx

  ```bash
  ./config-nginx-conf.sh
  ./config-nginx-vhost.sh
  ```

- [ ] Create _postgres_ user.

  `sudo adduser postgres`

- [ ] Install postgres.

  `./install-postgres.sh`

__Note__: For deployments using Capistrano, use `cap ENVIRONMENT deploy:initial` on the first instance.

## Puma systemd Service

__Note__: You may need to modify `WorkingDirectory` and `ExecStart` options based on your deployment.

```bash
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/var/vhosts/railsapp/current
ExecStart=/bin/bash -lc 'RAILS_ENV=production bundle exec puma -C /var/vhosts/railsapp/shared/puma.rb'

Restart=always

[Install]
WantedBy=multi-user.target

```

## Delayed Job systemd Service

__Note__: You may need to modify `WorkingDirectory`, `ExecStart` and `ExecStop` options based on your deployment.

```bash
[Unit]
Description=Delayed Jobs Cron
After=network.target

[Service]
Type=forking
User=deploy
WorkingDirectory=/var/vhosts/railsapp/current
ExecStart=/bin/bash -lc 'RAILS_ENV=production bundle exec bin/delayed_job start'
ExecStop=/bin/bash -lc 'RAILS_ENV=production bundle exec bin/delayed_job stop'

Restart=always

[Install]
WantedBy=multi-user.target

```
