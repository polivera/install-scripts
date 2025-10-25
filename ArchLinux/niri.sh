
#!/usr/bin/env bash

source ./aur-yay.sh

sudo pacman -S \
    niri \
    wofi \
    mako \
    waybar \
    grim \
    slurp \
    swappy \
    wf-recorder \
    xdg-desktop-portal-gtk xdg-desktop-portal-gnome \
    alacritty \
    swaybg \
    xwayland-satellite \
    network-manager-applet \
    pavucontrol \
    brave \
    --needed --noconfirm

# Application launcher: wofi
# Top Bar: waybar
# Notification: mako
# Screenshot: (screenshot: grim | area: slurp | edit: swappy | video record: wf-recorder)
# Screen Sharing: (xdg-desktop-portal-gtk, xdg-desktop-portal-gnome)
# Terminal: alacritty
# Background: swaybg
# X11 Compatibility: xwayland-satellite
# Browser: Brave
# Network: network-manager-applet
# Sound: pavucontrol
