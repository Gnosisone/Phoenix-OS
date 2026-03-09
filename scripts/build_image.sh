#!/usr/bin/env bash
# =============================================================================
# PHOENIX OS — Master Build Script
# Builds a bootable Kali Linux ARM64 image for Raspberry Pi 5
# with ERR0RS ULTIMATE pre-installed and Hailo-10H NPU support
# Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
# Usage: sudo bash scripts/build_image.sh
# =============================================================================

set -e
ORANGE='\033[0;33m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$REPO_DIR/build"
IMAGE_NAME="Phoenix-OS-Pi5-$(date +%Y%m%d).img"
IMAGE_SIZE="16G"
KALI_BASE_URL="https://kali.download/arm-images/kali-2024.4/kali-linux-2024.4-raspberry-pi5-arm64.img.xz"

banner() {
  echo -e "${ORANGE}"
  echo "  ██████╗ ██╗  ██╗ ██████╗ ███████╗███╗  ██╗██╗██╗  ██╗"
  echo "  ██╔══██╗██║  ██║██╔═══██╗██╔════╝████╗ ██║██║╚██╗██╔╝"
  echo "  ██████╔╝███████║██║   ██║█████╗  ██╔██╗██║██║ ╚███╔╝ "
  echo "  ██╔═══╝ ██╔══██║██║   ██║██╔══╝  ██║╚████║██║ ██╔██╗ "
  echo "  ██║     ██║  ██║╚██████╔╝███████╗██║ ╚███║██║██╔╝╚██╗"
  echo "  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚══╝╚═╝╚═╝  ╚═╝"
  echo -e "${YELLOW}  Image Builder v1.0 | Pi 5 + Hailo-10H + ERR0RS${NC}"
  echo ""
}

check_deps() {
  echo -e "${CYAN}[CHECK] Verifying build dependencies...${NC}"
  local deps="qemu-user-static debootstrap xz-utils wget parted kpartx"
  for dep in $deps; do
    if ! command -v "$dep" &>/dev/null && ! dpkg -l "$dep" &>/dev/null; then
      echo -e "  Installing $dep..."
      apt install -y "$dep" -qq
    fi
  done
  echo -e "  ${GREEN}Dependencies OK${NC}"
}

download_base() {
  echo -e "\n${CYAN}[1/6] Downloading Kali ARM64 base image...${NC}"
  mkdir -p "$BUILD_DIR"
  cd "$BUILD_DIR"
  if [ ! -f "kali-base.img.xz" ]; then
    wget -O kali-base.img.xz "$KALI_BASE_URL" --progress=bar
  else
    echo -e "  ${YELLOW}Base image already downloaded${NC}"
  fi
  echo -e "  Extracting..."
  xz -dk kali-base.img.xz
  mv kali-linux-*.img kali-base.img 2>/dev/null || true
  echo -e "  ${GREEN}Base image ready${NC}"
}

mount_image() {
  echo -e "\n${CYAN}[2/6] Mounting image for customization...${NC}"
  cd "$BUILD_DIR"
  LOOP_DEV=$(losetup -f --show -P kali-base.img)
  mkdir -p mnt/root mnt/boot
  mount "${LOOP_DEV}p2" mnt/root
  mount "${LOOP_DEV}p1" mnt/boot
  # Set up QEMU for ARM64 chroot on x86
  cp /usr/bin/qemu-aarch64-static mnt/root/usr/bin/
  echo -e "  ${GREEN}Image mounted at $BUILD_DIR/mnt${NC}"
}

install_errz() {
  echo -e "\n${CYAN}[3/6] Installing ERR0RS ULTIMATE into image...${NC}"
  # Chroot into the image and install ERR0RS
  chroot "$BUILD_DIR/mnt/root" /bin/bash << 'CHROOT'
    set -e
    # Update system
    apt update -qq
    # Install ERR0RS dependencies
    apt install -y python3 python3-pip git curl wget \
      nmap metasploit-framework hydra hashcat \
      sqlmap nikto gobuster -qq
    # Clone ERR0RS Ultimate
    cd /opt
    git clone https://github.com/Gnosisone/ERR0RS-Ultimate.git
    cd ERR0RS-Ultimate
    pip3 install requests fastapi uvicorn python-dotenv rich \
      chromadb sentence-transformers --break-system-packages -q
    echo "ERR0RS installed"
CHROOT
  echo -e "  ${GREEN}ERR0RS ULTIMATE installed${NC}"
}

install_hailo() {
  echo -e "\n${CYAN}[4/6] Installing Hailo-10H NPU drivers...${NC}"
  chroot "$BUILD_DIR/mnt/root" /bin/bash << 'CHROOT'
    set -e
    # Hailo runtime requires Debian Trixie / bookworm backports
    apt install -y dkms linux-headers-$(uname -r) -qq 2>/dev/null || true
    # Install HailoRT
    pip3 install hailort --break-system-packages -q 2>/dev/null || \
      echo "HailoRT pip install failed — will install from .deb on first boot"
    echo "Hailo drivers staged"
CHROOT
  # Copy Hailo first-boot installer
  cp "$REPO_DIR/scripts/install_hailo_firstboot.sh" \
     "$BUILD_DIR/mnt/root/opt/install_hailo.sh"
  chmod +x "$BUILD_DIR/mnt/root/opt/install_hailo.sh"
  echo -e "  ${GREEN}Hailo drivers staged${NC}"
}

configure_autostart() {
  echo -e "\n${CYAN}[5/6] Configuring Phoenix OS autostart...${NC}"
  # Copy Phoenix config files
  cp -r "$REPO_DIR/config/"* "$BUILD_DIR/mnt/root/etc/phoenix/" 2>/dev/null || true
  # Install systemd service for ERR0RS
  cp "$REPO_DIR/config/systemd/errz.service" \
     "$BUILD_DIR/mnt/root/etc/systemd/system/"
  chroot "$BUILD_DIR/mnt/root" systemctl enable errz.service 2>/dev/null || true
  # Copy first boot script
  cp "$REPO_DIR/scripts/first_boot.sh" "$BUILD_DIR/mnt/root/opt/"
  chmod +x "$BUILD_DIR/mnt/root/opt/first_boot.sh"
  echo -e "  ${GREEN}Autostart configured${NC}"
}

finalize_image() {
  echo -e "\n${CYAN}[6/6] Finalizing image...${NC}"
  # Cleanup chroot
  rm -f "$BUILD_DIR/mnt/root/usr/bin/qemu-aarch64-static"
  # Unmount
  umount "$BUILD_DIR/mnt/boot" 2>/dev/null || true
  umount "$BUILD_DIR/mnt/root" 2>/dev/null || true
  losetup -d "$LOOP_DEV" 2>/dev/null || true
  # Rename final image
  mv "$BUILD_DIR/kali-base.img" "$BUILD_DIR/$IMAGE_NAME"
  echo -e "  ${GREEN}Image saved: $BUILD_DIR/$IMAGE_NAME${NC}"
}

main() {
  banner
  [ "$EUID" -ne 0 ] && { echo -e "${RED}Run as root: sudo bash scripts/build_image.sh${NC}"; exit 1; }
  check_deps
  download_base
  mount_image
  install_errz
  install_hailo
  configure_autostart
  finalize_image

  echo ""
  echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║   PHOENIX OS IMAGE BUILT SUCCESSFULLY  🔥            ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  Image: ${CYAN}$BUILD_DIR/$IMAGE_NAME${NC}"
  echo -e "  Flash: ${CYAN}sudo bash scripts/flash.sh /dev/nvme0n1${NC}"
  echo ""
}

main
