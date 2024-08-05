#!/usr/bin/env bash

USER=pablo

source ./aur-yay.sh

# Go Specific ------------------------------------------------------------------
sudo pacman -S \
	go \
	gopls \
	delve \
	--needed --noconfirm

go install github.com/rinchsan/gosimports/cmd/gosimports@latest
go install github.com/fatih/gomodifytags@latest

# PHP Specific -----------------------------------------------------------------
sudo pacman -S \
	php \
	composer \
	--needed --noconfirm

yay -S \
	php-cs-fixer \
	--needed --noconfirm

# Web Specific -----------------------------------------------------------------
sudo pacman -S \
	nodejs \
	npm \
	prettier \
	--needed --noconfirm

# Docker -----------------------------------------------------------------------
sudo pacman -S \
	docker \
	--needed --noconfirm
sudo chmod -aG docker $USER

# Misc Tools -------------------------------------------------------------------
sudo pacman -S \
	curl \
	mariadb-clients \
	tree-sitter \
	jq \
	--needed --noconfirm

yay -S \
	grpcurl \
	--needed --noconfirm

# Neovim -----------------------------------------------------------------------
sudo pacman -S \
	neovim \
	--needed --noconfirm

if [ ! -d $HOME/Projects/Personal/nvim-conf ]; then
	git clone https://gitlab.com/xapitan/nvim-conf.git $HOME/Projects/Personal/nvim-conf
	ln -s $HOME/Projects/Personal/nvim-conf $HOME/.config/nvim
fi
