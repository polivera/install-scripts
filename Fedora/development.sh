#!/usr/bin/env bash

# Go Specific ------------------------------------------------------------------
sudo dnf -y install \
	golang \
	golang-x-tools-gopls \
	delve

go install github.com/rinchsan/gosimports/cmd/gosimports@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/a-h/templ/cmd/templ@latest

# PHP Specific -----------------------------------------------------------------
sudo dnf -y install \
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
sudo dnf -y install \
	nodejs-bash-language-server \
	shellcheck \
	shfmt

# Web Specific -----------------------------------------------------------------
sudo dnf -y install \
	nodejs \
	nodejs-npm

sudo npm install -g @tailwindcss/language-server
sudo npm install -g typescript-language-server typescript
sudo npm install -g vscode-css-languageservice
sudo npm install -g vscode-json-languageservice
# Lua Specific -----------------------------------------------------------------
sudo dnf -y install \
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
sudo dnf -y install \
	docker
sudo usermod -aG docker pablo

# Misc Tools -------------------------------------------------------------------
sudo dnf -y install \
	curl \
	wget2 \
	jq

# Neovim -----------------------------------------------------------------------
sudo dnf -y install \
	neovim \
	--needed --noconfirm

if [ ! -d "$HOME"/Projects/Personal/nvim-conf ]; then
	git clone https://gitlab.com/xapitan/nvim-conf.git "$HOME"/Projects/Personal/nvim-conf
	ln -s "$HOME"/Projects/Personal/nvim-conf "$HOME"/.config/nvim
	sudo npm install -g neovim
fi
