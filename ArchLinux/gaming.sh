#!/usr/bin/env bash

source ./aur-yay.sh

sudo pacman -S \
	steam \
	amdvlk \
	lib32-amdvlk \
	--needed --noconfirm
