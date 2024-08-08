#!/usr/bin/env bash

# Brave Browser ----------------------------------------------------------------
# Install dnf plugins
sudo dnf install dnf-plugins-core
# Add brave repository to dnf repo list
sudo dnf config-manager --add-repo \
	https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
# Import something (maybe use for pgp but I don't know)
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
# Install browser
sudo dnf install brave-browser

# Add Flathub ------------------------------------------------------------------
flatpak remote-add --if-not-exists flathub \
	https://dl.flathub.org/repo/flathub.flatpakrepo

# Obsidiab
flatpak install flathub md.obsidian.Obsidian

# Spotify
flatpak install flathub com.spotify.Client

# Flatseal
flatpak install flathub com.github.tchx84.Flatseal

# Timeshift --------------------------------------------------------------------
sudo dnf -y install timeshift
