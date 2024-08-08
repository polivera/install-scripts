#!/usr/bin/env bash

# Go Specific ------------------------------------------------------------------
sudo -y dnf install \
	golang \
	golang-x-tools-gopls \
	delve

go install github.com/rinchsan/gosimports/cmd/gosimports@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/a-h/templ/cmd/templ@latest

# PHP Specific -----------------------------------------------------------------
sudo -y dnf install \
	php \
	composer \
	php-devel \
	php-pecl-xdebug3 \
	php-cs-fixer

if command -v phpactor; then
	curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
	chmod a+x phpactor.phar
	mkdir ~/.local/bin 2>/dev/null
	mv phpactor.phar ~/.local/bin/phpactor
fi

# Shell Specific ---------------------------------------------------------------
sudo -y dnf install \
	nodejs-bash-language-server \
	shellcheck \
	shfmt

# Web Specific -----------------------------------------------------------------
sudo -y dnf install \
	nodejs \
	nodejs-npm

npm install -g @tailwindcss/language-server
npm install -g typescript-language-server typescript
npm install -g vscode-css-languageservice
npm install -g vscode-json-languageservice
# Lua Specific -----------------------------------------------------------------
sudo -y dnf install \
	lua \
	luajit \
	stylua

if ! command -v stylua; then
	curl -Lo stylua-linux.zip https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64.zip
	unzip stylua-linux
	mkdir -p "$HOME"/.local/bin 2>/dev/null
	mv stylua "$HOME"/.local/bin/
fi
# Docker -----------------------------------------------------------------------
sudo -y dnf -y install \
	docker
sudo usermod -aG docker pablo

# Misc Tools -------------------------------------------------------------------
sudo -y dnf -y install \
	curl \
	wget2 \
	jq
