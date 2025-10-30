#!/usr/bin/env bash

source ./aur-yay.sh

sudo pacman -S \
	plasma \
	kde-applications \
	kalarm \
	libreoffice-fresh \
	sddm \
	sddm-kcm \
	plasma-workspace \
	wl-clipboard \
	qt6-multimedia-ffmpeg \
	pipewire-jack \
	pyside6 \
	cronie \
	ffmpeg \
	alacritty \
	firefox \
    vivaldi \
    vivaldi-ffmpeg-codecs \
	spotify-launcher \
	power-profiles-daemon \
	--needed --noconfirm

yay -S \
	1password \
	ttf-iosevkaterm-nerd \
	--needed --noconfirm

sudo systemctl enable sddm
