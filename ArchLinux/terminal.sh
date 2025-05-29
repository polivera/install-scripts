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

# Install dotfiles
mkdir -p "$HOME"/Projects/Personal 2>/dev/null
git clone https://github.com/polivera/dotfiles.git "$HOME"/Projects/Personal/dotfiles
"$HOME"/Projects/Personal/dotfiles/install.sh

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Change default shell to zsh
chsh -s /usr/bin/zsh

# We have to log in against to finish the installation
exit
