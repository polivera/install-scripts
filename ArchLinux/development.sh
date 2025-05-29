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

# Shell Specific ---------------------------------------------------------------
sudo pacman -S \
	bash-language-server \
	shellcheck \
	shfmt \
	--needed --noconfirm

# Web Specific -----------------------------------------------------------------
sudo pacman -S \
	nodejs \
	npm \
	tailwindcss-language-server \
	typescript-language-server \
	yaml-language-server \
	vscode-css-languageserver \
	vscode-html-languageserver \
	vscode-json-languageserver \
	prettier \
	--needed --noconfirm

yay -S tailwindcss \
	--needed --noconfirm

npm config set prefix "$HOME"/.local/npm-global

# Lua Specific -----------------------------------------------------------------
sudo pacman -S \
	lua \
	luajit \
	stylua \
	lua-language-server \
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
	sql-language-server \
	--needed --noconfirm

# Autoenv
npm install -g '@hyperupcall/autoenv'

# Neovim -----------------------------------------------------------------------
sudo pacman -S \
     neovim \
     --needed --noconfirm

if [ ! -d "$HOME"/Projects/Personal/nvim-conf ]; then
	git clone https://github.com/polivera/nvim-conf.git "$HOME"/Projects/Personal/nvim-conf
	ln -s "$HOME"/Projects/Personal/nvim-conf "$HOME"/.config/nvim
	npm install -g neovim
fi

# Emacs -----------------------------------------------------------------------
sudo pacman -S \
     emacs-wayland \
     --needed --noconfirm

if [ ! -d "$HOME"/Projects/Personal/emacs-conf ]; then
	git clone https://github.com/polivera/emacs-conf.git "$HOME"/Projects/Personal/emacs-conf
	ln -s "$HOME"/Projects/Personal/emacs-conf "$HOME"/.config/emacs
fi
