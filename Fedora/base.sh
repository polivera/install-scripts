#!/usr/bin/env bash

sudo dnf -y install \
	git \
	openssl \
	openssl-devel \
	automake \
	autoconf \
	libtool

sudo dnf -y groupinstall "Development Tools"

# RPM Fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf config-manager --enable fedora-cisco-openh264
sudo dnf update @core

# Change to full ffmpeg
sudo dnf swap ffmpeg-free ffmpeg --allowerasing

# Additional codecs
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Hardware codecs (amd)
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

# Firmware
sudo dnf install rpmfusion-nonfree-release-tainted
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"
