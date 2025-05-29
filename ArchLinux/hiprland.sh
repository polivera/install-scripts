#!/usr/bin/env bash

source ./aur-yay.sh

# Hyprland and core Wayland components
sudo pacman -S \
	hyprland \
	xdg-desktop-portal-hyprland \
	polkit-kde-agent \
	qt5-wayland \
	qt6-wayland \
	--needed --noconfirm

# Display manager and session management
sudo pacman -S \
	sddm \
	sddm-kcm \
	--needed --noconfirm

# Essential Wayland utilities
sudo pacman -S \
	waybar \
	wofi \
	swww \
	grim \
	slurp \
	wl-clipboard \
	cliphist \
	swaynotificationcenter \
	swaylock-effects \
	swayidle \
	brightnessctl \
	playerctl \
	pavucontrol \
	--needed --noconfirm

# File manager and basic apps
sudo pacman -S \
	dolphin \
	ark \
	gwenview \
	konsole \
	firefox \
	--needed --noconfirm

# Fonts and themes
sudo pacman -S \
	ttf-font-awesome \
	ttf-fira-code \
	ttf-dejavu \
	noto-fonts \
	noto-fonts-emoji \
	papirus-icon-theme \
	--needed --noconfirm

# Audio (PipeWire should already be installed from drivers.sh)
sudo pacman -S \
	wireplumber \
	pipewire-pulse \
	pipewire-jack \
	--needed --noconfirm

# Additional utilities
sudo pacman -S \
	network-manager-applet \
	blueman \
	thunar \
	thunar-volman \
	tumbler \
	ffmpegthumbnailer \
	--needed --noconfirm

# AUR packages for enhanced experience
yay -S \
	hyprpicker \
	grimblast-git \
	waybar-hyprland-git \
	wlogout \
	--needed --noconfirm

# Enable SDDM service
sudo systemctl enable sddm

echo ""
echo "Hyprland installation completed!"
echo ""

exit 0