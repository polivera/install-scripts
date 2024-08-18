#!/usr/bin/env bash

# Customization section
UCODE_TYPE=amd-ucode
DISK_DEVICE=/dev/nvme0n1
# Partitions (rember to add boot size to de desire sawp size)
MAKE_PARTITIONS=1
BOOT_SIZE=1025MiB
BOOT_PARTITION="${DISK_DEVICE}p1"
ROOT_PARTITION="${DISK_DEVICE}p2"
BTRFS_MOUNT_OPTIONS="noatime,compress=zstd,discard=async"
BOOT_DIRECTORY=/boot
SWAP_SIZE_GB=16
ROOT_PART_NAME=linuxroot
## Custom Vars
USERNAME="pablo"
TIME_ZONE="Europe/Madrid"
LOCALE="en_US.UTF-8"
KEYMAP="us"
HOSTNAME="otrave"
SUDO_WITH_PASSWORD=0

# ----------------------------------------------------------------------------#

if [[ $MAKE_PARTITIONS == 1 ]]; then
	# Remove all partitions on drive
	parted $DISK_DEVICE mklabel gpt

	# Create boot and root partitions
	parted $DISK_DEVICE mkpart boot fat32 1MiB $BOOT_SIZE
	parted $DISK_DEVICE set 1 esp on
	parted $DISK_DEVICE mkpart root btrfs $BOOT_SIZE 100%

	# Format partitions
	mkfs.vfat -F 32 -n EFI $BOOT_PARTITION
	mkfs.btrfs -f -L $ROOT_PART_NAME $ROOT_PARTITION
fi

# Mount Partitions
mount $ROOT_PARTITION /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@opt
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@.snapshots
umount -R /mnt
# Mount new volumes
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@root $ROOT_PARTITION /mnt
mkdir -p /mnt/{boot,home,var,srv,opt,tmp,swap,.snapshots,$BOOT_DIRECTORY}
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@home $ROOT_PARTITION /mnt/home
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@srv $ROOT_PARTITION /mnt/srv
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@opt $ROOT_PARTITION /mnt/opt
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@tmp $ROOT_PARTITION /mnt/tmp
mount -t btrfs -o $BTRFS_MOUNT_OPTIONS,subvol=@.snapshots $ROOT_PARTITION /mnt/.snapshots
mount -t btrfs -o nodatacow,subvol=@var $ROOT_PARTITION /mnt/var
mount -t btrfs -o nodatacow,subvol=@swap $ROOT_PARTITION /mnt/swap
mount $BOOT_PARTITION /mnt/$BOOT_DIRECTORY

# Update mirror list
reflector --country ES --age 24 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist

# Set time
timedatectl set-ntp true

# Installing base system
pacman -S archlinux-keyring --noconfirm
pacstrap /mnt \
	base \
	linux-zen linux-firmware linux-headers dkms $UCODE_TYPE \
	btrfs-progs grub grub-btrfs efibootmgr \
	networkmanager avahi bluez bluez-utils \
	sudo git neovim reflector

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
echo 'en_US.UTF-8 UTF-8' >/mnt/etc/locale.gen
echo 'es_ES.UTF-8 UTF-8' >>/mnt/etc/locale.gen
locale-gen
# Set up timezone, hostname and keymap
systemd-firstboot --root /mnt \
	--locale=${LOCALE} \
	--keymap=${KEYMAP} \
	--timezone=${TIME_ZONE} \
	--hostname=${HOSTNAME}
# Set up hosts file
echo '127.0.0.1    localhost' >>/etc/hosts
echo '::1          localhost' >>/etc/hosts
echo "127.0.1.1    ${HOSTNAME} ${HOSTNAME}.localhost" >>/etc/hosts

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
echo "MODULES=(btrfs)" >/mnt/etc/mkinitcpio.conf
echo "BINARIES=()" >>/mnt/etc/mkinitcpio.conf
echo "FILES=()" >>/mnt/etc/mkinitcpio.conf
echo "HOOKS=(base systemd autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)" >>/mnt/etc/mkinitcpio.conf

# Run mkinitcpio
arch-chroot /mnt mkinitcpio -P

# Install bootloader
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=$BOOT_DIRECTORY --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

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
