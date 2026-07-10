# SPDX-FileCopyrightText: 2021-2023, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-FileCopyrightText: 2026, Stephan Lachnit <stephan.lachnit@desy.de>
# SPDX-License-Identifier: MIT

FROM ubuntu:24.04

# Build with "docker build --build-arg PETA_RUN_FILE=installers/petalinux-v2024.2-11062026-installer.run --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t docker_petalinux3:2024.2 ."

# Copy petalinux installer
ARG PETA_RUN_FILE
COPY installers/${PETA_RUN_FILE} /tmp
RUN chmod 755 /tmp/${PETA_RUN_FILE}

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y -q \
    adduser \
    autoconf \
    bc \
    build-essential \
    gcc-multilib \
    less \
    libncurses-dev \
    libtool \
    locales \
    lsb-release \
    nano \
    python3 \
    rsync \
    sudo \
    texinfo \
    xterm \
    zlib1g-dev \
    xz-utils \
    && apt-get clean

# Generates locales
RUN locale-gen en_US.UTF-8 && update-locale

# Make /bin/sh symlink to bash instead of dash
RUN rm /bin/sh && ln -s bash /bin/sh

# Add a petalinux user
ARG UID
ARG GID
RUN userdel --remove ubuntu
RUN groupadd --gid ${GID} petalinux
RUN adduser --uid ${UID} --gid ${GID} --disabled-password --gecos '' petalinux && \
    usermod -aG sudo petalinux && \
    echo "petalinux ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 

# Switch to petalinux user
USER petalinux

# Run the [etalinux installer
RUN cd /tmp && \
    mkdir -p /home/petalinux/petalinux && \
    sudo -u petalinux /tmp/${PETA_RUN_FILE} -y -d /home/petalinux/petalinux

# Source petalinux settings at login
RUN echo ". /home/petalinux/petalinux/settings.sh" >> /home/petalinux/.bashrc

# Switch back to root user
USER root

# Minimize image
RUN rm -rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/lintian/overrides/* /usr/share/info/* /tmp/*

# User settings
USER petalinux
ENV HOME=/home/petalinux
ENV LANG=en_US.UTF-8
ENV SHELL=/bin/bash
WORKDIR /home/petalinux

ENTRYPOINT ["/bin/bash"]

