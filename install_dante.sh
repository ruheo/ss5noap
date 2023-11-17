#!/bin/bash

# Install Dante server
sudo apt-get update
sudo apt-get install dante-server -y

# Create and configure Dante server
cat <<EOL | sudo tee /etc/danted.conf
logoutput: syslog
internal: eth0 port = 1080
external: eth0

method: none
user.privileged: root
user.unprivileged: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

client block {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
}

block {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}
EOL

# Restart Dante service
sudo systemctl restart danted

echo "Dante SOCKS5 server installed and configured. No authentication required."
