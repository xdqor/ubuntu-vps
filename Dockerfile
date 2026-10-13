FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    git \
    nano \
    htop \
    tmux \
    ca-certificates \
    nodejs \
    npm \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd /root/.ssh /home/dev \
    && chmod 700 /root/.ssh

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 2222

CMD ["/start.sh"]
