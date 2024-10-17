#!/usr/bin/env bash

source ./env.sh

sudo dnf -y install \
	git \
	openssl \
	openssl-devel \
	automake \
	autoconf \
	libtool

sudo dnf -y groupinstall "Development Tools"

# RPM Fusion
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf config-manager --enable fedora-cisco-openh264
sudo dnf update @core

# Change to full ffmpeg
sudo dnf -y swap ffmpeg-free ffmpeg --allowerasing

# Additional codecs
sudo dnf -y update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Hardware codecs (amd)
sudo dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

# Firmware
sudo dnf -y install rpmfusion-nonfree-release-tainted
sudo dnf -y --repo=rpmfusion-nonfree-tainted install "*-firmware"

# Nodejs (for dependencies)
sudo dnf -y install \
	nodejs \
	nodejs-npm

npm config set prefix "$HOME"/.local/npm-global

# File System
sudo dnf -y install \
	nfs-utils \
	btrfs-assistant \
	snapper \
	dnf-plugin-snapper
