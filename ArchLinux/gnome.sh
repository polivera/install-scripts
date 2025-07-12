#!/usr/bin/env bash

USER=pablo

source ./aur-yay.sh

sudo pacman -S \
  gnome \
  gnome-extra \
  gdm \
  --needed --noconfirm

sudo systemctl enable gdm