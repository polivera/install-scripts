#!/usr/bin/env bash

USER=pablo

source ./aur-yay.sh

# Go Specific ------------------------------------------------------------------
export GOPATH=$HOME/.local/share/go
sudo pacman -S \
	go \
	gopls \
	delve \
	--needed --noconfirm

go install github.com/rinchsan/gosimports/cmd/gosimports@latest

# Rust Specific ----------------------------------------------------------------
export CARGO_HOME=$HOME/.local/share/cargo
sudo pacman -S \
	rust \
	cargo \
	--needed --noconfirm

# Web Specific -----------------------------------------------------------------
sudo pacman -S \
	nodejs \
	npm \
	prettier \
	--needed --noconfirm
npm config set prefix "$HOME"/.local/npm-global

# Docker -----------------------------------------------------------------------
sudo pacman -S \
	docker \
	--needed --noconfirm
sudo usermod -aG docker $USER

# C / C++ Specific -------------------------------------------------------------
sudo dnf -y install \
	clang-tools-extra

# Misc Tools -------------------------------------------------------------------
sudo pacman -S \
	curl \
	mariadb-clients \
	tree-sitter \
	jq \
	less \
	--needed --noconfirm

# Autoenv
npm install -g '@hyperupcall/autoenv'

yay -S \
	grpcurl \
	phpenv-git \
	--needed --noconfirm
