#!/usr/bin/env bash

source ./aur-yay.sh

# Install terminal tools
sudo pacman -S \
	zsh \
	zoxide \
	bat \
	exa \
	tree \
	xclip \
	curl \
	wget \
	fzf \
	fd \
	ripgrep \
	tldr \
	tmux \
	--needed --noconfirm

yay -S spaceship-prompt --needed --noconfirm

mkdir -p $HOME/Projects/Personal 2>/dev/null
git clone https://gitlab.com/xapitan/dotfiles.git $HOME/Projects/Personal/dotfiles
$HOME/Projects/Personal/dotfiles/install.sh
