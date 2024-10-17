#!/usr/bin/env bash

source ./aur-yay.sh

# Update repos
sudo pacman -Syu

# Install pacman
sudo pacman -S \
	archlinux-keyring \
	pacman-contrib \
	pacutils \
	--needed --noconfirm

# Automount and USB
sudo pacman -S \
	udisks2 \
	udiskie \
	usbutils \
	--needed --noconfirm

# Sound
sudo pacman -S \
	pipewire \
	lib32-pipewire \
	libpipewire \
	lib32-libpipewire \
	pipewire-audio \
	--needed --noconfirm

# Video
sudo pacman -S \
	mesa \
	lib32-mesa \
	vulkan-radeon \
	lib32-vulkan-radeon \
	vulkan-icd-loader \
	lib32-vulkan-icd-loader \
	libva-mesa-driver \
	lib32-libva-mesa-driver \
	mesa-vdpau \
	lib32-mesa-vdpau \
	mesa-demos \
	--needed --noconfirm

# Bluetooth
sudo pacman -S \
	bluez \
	bluez-utils \
	--needed --noconfirm

# Filesystems
sudo pacman -S \
	ntfs-3g \
	exfat-utils \
	--needed --noconfirm

# Misc
# (should put these somewhere else)
sudo pacman -S \
	openssh \
	zip \
	unzip \
	--needed --noconfirm

# Install missing firmware
yay -S mkinitcpio-firmware --needed --noconfirm

echo "'drivers' installed"
return 0
