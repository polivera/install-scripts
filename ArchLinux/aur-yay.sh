#!/usr/bin/env bash

if command -v yay; then
	return 0
fi

if ! command -v git; then
	sudo pacman -S git --noconfirm
fi

# Install yay
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

echo "[info] YAY installed"
return 0
