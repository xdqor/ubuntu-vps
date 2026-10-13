#!/bin/bash
set -e

: "${FRIEND_USERNAME:?Set FRIEND_USERNAME in Railway Variables}"
: "${FRIEND_PASSWORD:?Set FRIEND_PASSWORD in Railway Variables}"

if ! [[ "$FRIEND_USERNAME" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; then
    echo "Invalid username"
    exit 1
fi

apt-get update
apt-get install -y openssh-server sudo
mkdir -p /run/sshd /home/dev

if ! id "$FRIEND_USERNAME" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$FRIEND_USERNAME"
fi

printf '%s:%s\n' "$FRIEND_USERNAME" "$FRIEND_PASSWORD" | chpasswd

mkdir -p "/home/$FRIEND_USERNAME/.ssh"
chown -R "$FRIEND_USERNAME:$FRIEND_USERNAME" "/home/$FRIEND_USERNAME"

ssh-keygen -A

cat > /etc/ssh/sshd_config <<'EOF'
Port 2222
PermitRootLogin no
PasswordAuthentication yes
KbdInteractiveAuthentication no
UsePAM yes
PubkeyAuthentication yes
AllowTcpForwarding no
X11Forwarding no
EOF

exec /usr/sbin/sshd -D -e
