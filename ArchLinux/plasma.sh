#!/usr/bin/env bash

source ./aur-yay.sh

sudo pacman -S \
	plasma \
	kde-applications \
	kalarm \
	libreoffice-fresh \
	sddm \
	plasma-workspace \
	wl-clipboard \
	ffmpeg \
	--needed --noconfirm

sudo pacman -R kmix --noconfirm

yay -S \
	1password \
	spotify \
	google-chrome \
	--needed --noconfirm
