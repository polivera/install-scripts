#!/usr/bin/env bash

source ./aur-yay.sh

pacman -S \
    gnome \
    gnome-circle \
    gdm \
    spotify-launcher \
    vivaldi \
    vivaldi-ffmpeg-codecs \
    --needed --noconfirm

yay -S \
	1password \
	ttf-iosevkaterm-nerd \
	--needed --noconfirm

