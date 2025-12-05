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
	--needed --noconfirm

npm config set prefix "$HOME"/.local/npm-global
# npm version manager
npm i -g n

# Lua Specific -----------------------------------------------------------------
sudo pacman -S \
	lua \
	luajit \
	--needed --noconfirm

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

yay -S \
	grpcurl \
	--needed --noconfirm

# Autoenv / Direnv
# npm install -g '@hyperupcall/autoenv'
sudo pacman -S direnv --noconfirm

# Neovim -----------------------------------------------------------------------
sudo pacman -S \
     neovim \
     --needed --noconfirm

if [ ! -d "$HOME"/Projects/Personal/neovim-conf ]; then
	git clone https://github.com/polivera/neovim-conf.git "$HOME"/Projects/Personal/neovim-conf
	ln -s "$HOME"/Projects/Personal/neovim-conf "$HOME"/.config/nvim
	npm install -g neovim
fi

# Local AI Stuff
sudo pacman -S \
    rocm-hip-sdk rocm-opencl-runtime \
    ollama \
    ollama-rocmi \
    --needed --noconfirm

sudo usermod -aG video,render $USER
