#!/bin/bash
set -e

mkdir -p /run/sshd /root/.ssh
chmod 700 /root/.ssh

if [ -z "${SSH_PUBLIC_KEY:-}" ]; then
    echo "ERROR: SSH_PUBLIC_KEY variable is missing."
    exit 1
fi

printf '%s\n' "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

ssh-keygen -A

cat > /etc/ssh/sshd_config <<'EOF'
Port 2222
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
UsePAM no
AuthorizedKeysFile .ssh/authorized_keys
AllowTcpForwarding no
X11Forwarding no
PrintMotd no
EOF

exec /usr/sbin/sshd -D -e
