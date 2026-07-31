#!/bin/bash

BASE_PACKAGES=(
    "archlinux-xdg-menu"
    "base-devel"
    "brightnessctl"
    "docker-compose"
    "docker"
    "libpsl"
    "nano"
    "noto-fonts-emoji"
    "qt6ct"
    "tlp"
    "ttf-jetbrains-mono-nerd"
    "unrar"
    "unzip"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-kde"
    "zip"
)

ENVIRONMENT_PACKAGES=(
	"wlogout"
    "btop"
    "clipse"
    "dolphin"
    "hypridle"
    "hyprland"
    "hyprlock"
    "hyprpaper"
    "hyprshot"
    "kcalc"
    "kitty"
    "mako"
    "starship"
    "stow"
    "waybar"
)

APP_PACKAGES=(
    "google-chrome"
    "visual-studio-code-bin"
    "discord"
    "spotify"
    "spotify-adblock-git"
)

set -e # Exit on any error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
    read -p "$1 (Y/n): " -r
    [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
}

# Check if running as root (not recommended)
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root. Please run as a regular user."
    exit 1
fi

echo
print_info "Arch Linux Setup - Configuration Questions"
echo "================================================="
echo

PACMAN=false
BASE=false
FOLDERS=false
GRUB=false
AUTOLOGIN=false
YAY=false
NVIDIA=false
ENVIRONMENT=false
DOTFILES=false
APPLICATIONS=false
REBOOT=false

if confirm "Connect to Wi-Fi?"; then
    print_info "Available Wi-Fi networks:"
    nmcli device wifi list
    read -p "Enter SSID: " ssid
    read -s -p "Enter password: " password
    echo
    nmcli device wifi connect "$ssid" password "$password"
    print_success "Connected to Wi-Fi"
fi

if confirm "Configure pacman (enable ILoveCandy)?"; then
    PACMAN=true
fi

if confirm "Install base packages?"; then
    BASE=true
fi

if confirm "Create essential folders?"; then
    FOLDERS=true
fi

if confirm "Disable GRUB timeout?"; then
    GRUB=true
fi

if confirm "Enable auto login for user 'afonso'?"; then
    AUTOLOGIN=true
fi

if confirm "Install yay (AUR Helper)?"; then
    YAY=true
fi

if confirm "Setup NVIDIA support?"; then
    NVIDIA=true
fi

if confirm "Install environment packages?"; then
    ENVIRONMENT=true

    if confirm "Clone and setup dotfiles?"; then
        DOTFILES=true
    fi
fi

if confirm "Install applications?"; then
    APPLICATIONS=true
fi

if confirm "Reboot after completion?"; then
    REBOOT=true
fi

echo

if [ "$PACMAN" = true ]; then
    print_info "Configuring pacman..."
    if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
        sudo sed -i '/^#DisableSandbox/a ILoveCandy' /etc/pacman.conf
    fi
    print_success "Pacman configured"
fi

if [ "$BASE" = true ]; then
    print_info "Installing base packages..."
    sudo pacman -S --noconfirm "${BASE_PACKAGES[@]}"
    sudo systemctl enable --now tlp
    print_success "Base packages installed"
fi

if [ "$FOLDERS" = true ]; then
    print_info "Creating essential folders..."
    mkdir -p ~/Documents ~/Downloads
    print_success "Essential folders created"
fi

if [ "$GRUB" = true ]; then
    print_info "Disabling GRUB timeout..."
    sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    print_success "GRUB timeout disabled"
fi

if [ "$AUTOLOGIN" = true ]; then
    print_info "Enabling auto login..."
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
    sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf > /dev/null << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty -a afonso - $TERM
EOF
    print_success "Auto login enabled"
fi

if [ "$YAY" = true ]; then
    print_info "Installing yay..."
    git config --global user.name "AfonsoHJ1812"
    git config --global user.email "AfonsoHJ1812@gmail.com"
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~
    rm -fr ~/yay
    print_success "Yay installed"
fi

if [ "$NVIDIA" = true ]; then
    print_info "Installing NVIDIA packages..."
    yay -S --noconfirm nvidia-open nvidia-utils lib32-nvidia-utils nvidia-settings
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg    
    sudo sed -i 's/^MODULES=(\([^)]*\))/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    sudo systemctl enable nvidia-suspend.service nvidia-resume.service nvidia-hibernate.service
    print_success "NVIDIA packages installed"
fi

if [ "$ENVIRONMENT" = true ]; then
    print_info "Installing environment packages..."
    yay -S --noconfirm "${ENVIRONMENT_PACKAGES[@]}"
    print_success "Environment packages installed"
    
    if [ "$DOTFILES" = true ]; then
        print_info "Setting up dotfiles..."
        cd ~/Dotfiles
        PACKAGES=$(find . -maxdepth 1 -type d -not -name ".*" -printf "%f ")
        stow --adopt $PACKAGES
        git restore .
        systemctl --user daemon-reload
        systemctl --user enable --now colors-apply.path
        print_success "Dotfiles set up"

        print_info "Setting up Chrome cookie whitelist..."
        sudo install -d -o "$USER" -g "$USER" /etc/opt/chrome/policies/managed
        systemctl --user daemon-reload
        systemctl --user enable --now chrome-cookie-allowlist.path
        "$HOME/.local/bin/chrome-cookie-allowlist"
        print_success "Chrome cookie whitelist set up"
    fi
fi

if [ "$APPLICATIONS" = true ]; then
    print_info "Installing applications..."
    yay -S --noconfirm "${APP_PACKAGES[@]}"
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    print_success "Applications installed"
fi

if [ "$REBOOT" = true ]; then
    sudo reboot
else
    print_warning "Please reboot your system to ensure all changes take effect."
fi
