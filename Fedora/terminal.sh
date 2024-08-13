#!/usr/bin/env bash

source ./env.sh

sudo dnf -y install \
	zsh \
	zoxide \
	bat \
	exa \
	tree \
	xclip \
	curl \
	wget \
	fzf \
	fd-find \
	ripgrep \
	tldr \
	tmux

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install dotfiles
mkdir -p "$HOME"/Projects/Personal 2>/dev/null
git clone https://gitlab.com/xapitan/dotfiles.git "$HOME"/Projects/Personal/dotfiles
"$HOME"/Projects/Personal/dotfiles/install.sh

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Change default shell to zsh
chsh -s /usr/bin/zsh

# We have to log in againt to finish the installation
exit
