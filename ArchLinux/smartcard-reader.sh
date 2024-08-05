#!/usr/bin/env bash

# Install smartcard readeer

sudo pacman -S \
    ccid \
    opensc \
    pcsc-tools \
    --needed --noconfirm

sudo systemctl enable --now pcscd.service

