#!/usr/bin/env bash

export GOPATH=$HOME/.local/share/go

if ! command -v yay; then
	if ! command -v git; then
		sudo pacman -S git --noconfirm
	fi

	sudo pacman -S base-devel --needed --noconfirm

	cd ~ || exit
	git clone https://aur.archlinux.org/yay.git
	cd yay || exit
	makepkg -si --noconfirm
	cd ..
	rm -rf yay

	echo "[info] YAY installed"
fi
