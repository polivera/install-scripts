#!/usr/bin/env bash

# Go Specific ------------------------------------------------------------------
export GOPATH=$HOME/.local/share/go
sudo dnf -y install \
	golang \
	golang-x-tools-gopls \
	delve

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
sudo dnf -y install \
	php \
	composer \
	php-devel \
	php-pear \
	php-pecl-xdebug3 \
	php-cs-fixer

if command -v phpactor; then
	curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
	chmod a+x phpactor.phar
	mkdir ~/.local/bin 2>/dev/null
	mv phpactor.phar ~/.local/bin/phpactor
fi

# Shell Specific ---------------------------------------------------------------
sudo dnf -y install \
	nodejs-bash-language-server \
	shellcheck \
	shfmt

# Web Specific -----------------------------------------------------------------
sudo dnf -y install \
	nodejs \
	nodejs-npm

npm install -g @tailwindcss/language-server
npm install -g tailwindcss
npm install -g prettier
npm install -g typescript-language-server typescript
npm install -g vscode-css-languageservice
npm install -g vscode-json-languageservice

# Lua Specific -----------------------------------------------------------------
sudo dnf -y install \
	lua \
	luajit

if ! command -v stylua 2>/dev/null; then
	curl -Lo stylua-linux.zip https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64.zip
	unzip stylua-linux.zip
	mkdir -p "$HOME"/.local/bin 2>/dev/null
	mv stylua "$HOME"/.local/bin/
	rm stylua-linux.zip
fi

# C / C++ Specific -------------------------------------------------------------
sudo dnf -y install \
	clang-tools-extra

# Docker -----------------------------------------------------------------------
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin

sudo usermod -aG docker pablo

# Misc Tools -------------------------------------------------------------------
sudo dnf -y install \
	curl \
	wget2 \
	jq

# Autoenv
npm install -g '@hyperupcall/autoenv'

# Neovim -----------------------------------------------------------------------
sudo dnf -y install \
	neovim

if [ ! -d "$HOME"/Projects/Personal/nvim-conf ]; then
	git clone https://github.com/polivera/nvim-conf.git "$HOME"/Projects/Personal/nvim-conf
	ln -s "$HOME"/Projects/Personal/nvim-conf "$HOME"/.config/nvim
	npm install -g neovim
fi
