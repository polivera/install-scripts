#!/usr/bin/env bash

source ./aur-yay.sh

# Core gaming platform
sudo pacman -S \
	steam \
	--needed --noconfirm

# Graphics drivers (AMD-specific)
sudo pacman -S \
	amdvlk \
	lib32-amdvlk \
	vulkan-tools \
	--needed --noconfirm

# Wine/Proton ecosystem
sudo pacman -S \
	wine \
	winetricks \
	--needed --noconfirm

# Gaming performance tools
sudo pacman -S \
	gamemode \
	lib32-gamemode \
	mangohud \
	lib32-mangohud \
	--needed --noconfirm

# Audio support for games
sudo pacman -S \
	lib32-pipewire \
	lib32-pipewire-jack \
	--needed --noconfirm