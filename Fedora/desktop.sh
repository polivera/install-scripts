#!/usr/bin/env bash

source ./env.sh

# Brave Browser ----------------------------------------------------------------
# Install dnf plugins
sudo dnf -y install dnf-plugins-core
# Add brave repository to dnf repo list
sudo dnf config-manager --add-repo \
	https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
# Import something (maybe use for pgp but I don't know)
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
# Install browser
sudo dnf -y install brave-browser

# Add Flathub ------------------------------------------------------------------
sudo flatpak remote-add --if-not-exists flathub \
	https://dl.flathub.org/repo/flathub.flatpakrepo

# Obsidiab
sudo flatpak install -y flathub md.obsidian.Obsidian

# Spotify
sudo flatpak install -y flathub com.spotify.Client

# Flatseal
sudo flatpak install -y flathub com.github.tchx84.Flatseal

# Timeshift --------------------------------------------------------------------
sudo dnf -y install \
    timeshift \
    alacritty

