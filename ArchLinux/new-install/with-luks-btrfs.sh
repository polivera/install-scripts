#!/usr/bin/env bash

# :DONE: #1 Create an installation with grub and btrfs with 3 subvolumes (root, home, snapshots)
# :DONE: #2 Add Luks to the installation
# TODO: #3 Add secure boot to the installation

# Customization section
UCODE_TYPE=amd-ucode
DISK_DEVICE=/dev/nvme0n1
# Partitions (rember to add boot size to de desire sawp size)
BOOT_SIZE=1025MiB
BOOT_PARTITION="${DISK_DEVICE}p1"
ROOT_PARTITION="${DISK_DEVICE}p2"
BTRFS_MOUNT_OPTIONS="noatime,compress=zstd,discard=async"
BOOT_DIRECTORY=/boot
SWAP_SIZE_GB=16
LUKS_NAME=linuxroot
## Custom Vars
USERNAME="pablo"
TIME_ZONE="Europe/Madrid"
LOCALE="en_US.UTF-8"
KEYMAP="us"
HOSTNAME="otrave"
SUDO_WITH_PASSWORD=0

# ----------------------------------------------------------------------------#
ORIGINAL_ROOT_PARTITION="${ROOT_PARTITION}"
LUKS_MAPPER="/dev/mapper/${LUKS_NAME}"

# Remove all partitions on drive
parted $DISK_DEVICE mklabel gpt

# Create boot and root partitions
parted $DISK_DEVICE mkpart boot fat32 1MiB $BOOT_SIZE
parted $DISK_DEVICE set 1 esp on
parted $DISK_DEVICE mkpart root btrfs $BOOT_SIZE 100%

# GRUB only support --pbkdf pbkdf2 encryption
cryptsetup luksFormat --type luks2 --pbkdf pbkdf2 $ROOT_PARTITION
cryptsetup luksOpen $ROOT_PARTITION $LUKS_NAME
ROOT_PARTITION=$LUKS_MAPPER

# Format partitions
mkfs.vfat -F 32 -n EFI $BOOT_PARTITION
mkfs.btrfs -f -L $LUKS_NAME $ROOT_PARTITION

# Mount Partitions
mount $ROOT_PARTITION /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@opt
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@.snapshots
umount -R /mnt
# Mount new volumes
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@ $ROOT_PARTITION /mnt
mkdir -p /mnt/{boot,home,var,srv,opt,tmp,swap,.snapshots,$BOOT_DIRECTORY}
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@home $ROOT_PARTITION /mnt/home
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@srv $ROOT_PARTITION /mnt/srv
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@opt $ROOT_PARTITION /mnt/opt
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@tmp $ROOT_PARTITION /mnt/tmp
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@.snapshots $ROOT_PARTITION /mnt/.snapshots
mount -t btrfs -o nodatacow,subvol=@var $ROOT_PARTITION /mnt/var
mount -t btrfs -o nodatacow,subvol=@swap $ROOT_PARTITION /mnt/swap
mount $BOOT_PARTITION /mnt/$BOOT_DIRECTORY

# Set time
timedatectl set-ntp true

# Installing base system
pacman -S archlinux-keyring --noconfirm
pacstrap /mnt \
	base \
	linux linux-firmware linux-headers dkms $UCODE_TYPE \
	mesa \
	btrfs-progs cryptsetup terminus-font plymouth \
	networkmanager avahi bluez bluez-utils \
	sudo git neovim

# Create Swapfile
arch-chroot /mnt btrfs filesystem mkswapfile --size ${SWAP_SIZE_GB}g --uuid clear /swap/swapfile
chmod 600 /mnt/swap/swapfile
mkswap /mnt/swap/swapfile
swapon /mnt/swap/swapfile

# Generate fstabs
genfstab -U /mnt >>/mnt/etc/fstab

# Base config
# Set up locale
cp /mnt/etc/locale.gen /mnt/etc/locale.gen.back
echo $LOCALE >/mnt/etc/locale.gen
echo 'es_ES.UTF-8 UTF-8' >>/mnt/etc/locale.gen
locale-gen
# Set up timezone, hostname and keymap
systemd-firstboot --root /mnt \
	--locale=${LOCALE} \
	--keymap=${KEYMAP} \
	--timezone=${TIME_ZONE} \
	--hostname=${HOSTNAME}
# Set up hosts file
{
	echo '127.0.0.1    localhost'
	echo '::1          localhost'
	echo "127.0.1.1    ${HOSTNAME} ${HOSTNAME}.localhost"
} >>/etc/hosts

# Setting root password
echo "*** Setting root password ***"
arch-chroot /mnt passwd

# Create new user and set its password
echo "*** Setting ${USERNAME} user and password ***"
arch-chroot /mnt useradd -m $USERNAME -G wheel
arch-chroot /mnt passwd $USERNAME

# Update sudoers
cp /etc/sudoers /etc/sudoers.back
if [[ $SUDO_WITH_PASSWORD == 0 ]]; then
	echo '%wheel ALL=(ALL) NOPASSWD: ALL' >>/mnt/etc/sudoers
else
	echo '%wheel ALL=(ALL) ALL: ALL' >>/mnt/etc/sudoers
fi

# Configure initramfs
cp /mnt/etc/mkinitcpio.conf /mnt/etc/mkinitcpio.conf.back
echo "" >/mnt/etc/mkinitcpio.conf
{
	echo "MODULES=(amdgpu btrfs)"
	echo "BINARIES=()"
	echo "FILES=()"
	echo "HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck plymouth)"
} >>/mnt/etc/mkinitcpio.conf

# Run mkinitcpio
arch-chroot /mnt mkinitcpio -P

# Install bootloader
ROOT_PART_UUID=$(blkid | grep ${ORIGINAL_ROOT_PARTITION} | awk '{print $2}' | sed 's/UUID="\([^"]*\)"/\1/')
arch-chroot /mnt bootctl install --esp-path=/boot
cp /mnt/${BOOT_DIRECTORY}/loader/loader.conf /mnt/${BOOT_DIRECTORY}/loader/loader.conf.back
{
	echo "default  arch.conf"
	echo "timeout  1"
	echo "console-mode max"
	echo "editor   no"
} >/mnt/${BOOT_DIRECTORY}/loader/loader.conf

# Adding kernel image
{
	echo "title   Arch Linux"
	echo "linux   /vmlinuz-linux"
	echo "initrd  /amd-ucode.img"
	echo "initrd  /initramfs-linux.img"
	echo "options rs.luks.name=${ROOT_PART_UUID}=${LUKS_NAME} root=${LUKS_MAPPER} rootflags=subvol=@ rw quiet splash amdgpu.dc=1 video=2560x1440@60"
} >/mnt/${BOOT_DIRECTORY}/loader/entries/arch.conf

# Adding kernel fallback image
{
	echo "title   Arch Linux (fallback initramfs)"
	echo "linux   /vmlinuz-linux"
	echo "initrd  /amd-ucode.img"
	echo "initrd  /initramfs-linux-fallback.img"
	echo "options rs.luks.name=${ROOT_PART_UUID}=${LUKS_NAME} root=${LUKS_MAPPER} rootflags=subvol=@ rw quiet splash amdgpu.dc=1 video=2560x1440@60"
} >/mnt/${BOOT_DIRECTORY}/loader/entries/arch-fallback.conf

# Edit pacman.conf
cp /mnt/etc/pacman.conf /mnt/etc/pacman.conf.back
sed -i 's/#Color/Color/g' /mnt/etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/g' /mnt/etc/pacman.conf
echo '[multilib]' >>/mnt/etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >>/mnt/etc/pacman.conf

# Start services
systemctl --root /mnt enable systemd-resolved systemd-timesyncd NetworkManager bluetooth avahi-daemon
systemctl --root /mnt mask systemd-networkd

# Sync cache change to persistent storage
sync

# Cleaning
swapoff /mnt/swap/swapfile
umount -R /mnt
