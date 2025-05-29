#!/usr/bin/env bash

source ./aur-yay.sh

# Install smartcard reader
sudo pacman -S \
    ccid \
    opensc \
    pcsc-tools \
    --needed --noconfirm

sudo systemctl enable --now pcscd.service

