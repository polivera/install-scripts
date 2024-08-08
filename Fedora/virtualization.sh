#!/usr/bin/env bash

USER=pablo

# Install virtualization tools
sudo dnf group install -y --with-optional virtualization

# Create libvirt group
sudo group add libvirt

# Add user to libvirt group
sudo usermod -aG libvirt $USER

# Enable
sudo systemctl enable libvirtd

# Start service
sudo systemctl start libvirtd
