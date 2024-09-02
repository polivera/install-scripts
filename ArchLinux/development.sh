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
go install github.com/fatih/gomodifytags@latest
go install github.com/a-h/templ/cmd/templ@latest
go install github.com/bufbuild/buf-language-server/cmd/bufls@latest

# Rust Specific ----------------------------------------------------------------
export CARGO_HOME=$HOME/.local/share/cargo
sudo dnf -y install \
	rust \
	cargo

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

if command -v phpactor; then
	curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
	chmod a+x phpactor.phar
	mkdir ~/.local/bin 2>/dev/null
	mv phpactor.phar ~/.local/bin/phpactor
fi

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

# C / C++ Specific -------------------------------------------------------------
sudo dnf -y install \
	clang-tools-extra

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
