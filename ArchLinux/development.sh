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
go install github.com/a-h/templ/cmd/templ@latest

# PHP Specific -----------------------------------------------------------------
sudo pacman -S \
	php \
	composer \
	xdebug \
	--needed --noconfirm

yay -S \
	php-cs-fixer \
	phpactor \
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

# Misc Tools -------------------------------------------------------------------
sudo pacman -S \
	curl \
	mariadb-clients \
	tree-sitter \
	jq \
	--needed --noconfirm

yay -S \
	grpcurl \
	sql-language-server \
	--needed --noconfirm

# Neovim -----------------------------------------------------------------------
sudo pacman -S \
	neovim \
	--needed --noconfirm

if [ ! -d "$HOME"/Projects/Personal/nvim-conf ]; then
	git clone https://gitlab.com/xapitan/nvim-conf.git "$HOME"/Projects/Personal/nvim-conf
	ln -s "$HOME"/Projects/Personal/nvim-conf "$HOME"/.config/nvim
	npm install -g neovim
fi
