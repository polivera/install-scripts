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
	ttf-joypixels \
	pyside6 \
	cronie \
	phonon-qt5-gstreamer \
	ffmpeg \
	alacritty \
	firefox \
	spotify-launcher \
	power-profiles-daemon \
	--needed --noconfirm

sudo pacman -R kmix --noconfirm

yay -S \
	1password \
	ttf-iosevkaterm-nerd \
	--needed --noconfirm

sudo systemctl enable sddm
