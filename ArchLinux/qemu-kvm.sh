#!/usr/bin/env bash

# Install QEMU virtualization on Arch

USER=pablo
LIBVIRT_CONFIG_FILE=/etc/libvirt/libvirtd.conf

sudo pacman -S \
    qemu-full \
    virt-manager \
    virt-viewer \
    dnsmasq \
    vde2 \
    bridge-utils \
    openbsd-netcat \
    ebtables \
    iptables \
    swtpm \
    libguestfs \
    --needed 

sudo cp $LIBVIRT_CONFIG_FILE $LIBVIRT_CONFIG_FILE.back
sudo sed -i -e 's/#unix_sock_group/unix_sock_group/' $LIBVIRT_CONFIG_FILE
sudo sed -i -e 's/#unix_sock_rw_perms/unix_sock_rw_perms/' $LIBVIRT_CONFIG_FILE

sudo usermod -aG libvirt $USER

sudo systemctl enable libvirtd

echo "You should restart your system"

