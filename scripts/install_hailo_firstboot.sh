#!/usr/bin/env bash
# =============================================================================
# Phoenix OS — Hailo-10H First Boot Installer
# Installs HailoRT drivers and firmware on Pi 5
# Requires: Kali Linux ARM64, kernel 6.6+
# Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
# =============================================================================

set -e
ORANGE='\033[0;33m'; GREEN='\033[0;32m'; RED='\033[0;31m'
CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'

log()  { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[-]${NC} $1"; }

echo -e "${ORANGE}🔥 Phoenix OS — Hailo-10H Driver Installer${NC}\n"

# ── Check kernel version ──────────────────────────────────────────────────────
KERNEL=$(uname -r)
MAJOR=$(echo "$KERNEL" | cut -d. -f1)
MINOR=$(echo "$KERNEL" | cut -d. -f2)
log "Kernel: $KERNEL"

if [ "$MAJOR" -lt 6 ] || ([ "$MAJOR" -eq 6 ] && [ "$MINOR" -lt 6 ]); then
  err "Hailo-10H requires kernel 6.6+ (found $KERNEL)"
  err "Update kernel: sudo apt install linux-image-6.6-arm64"
  exit 1
fi

# ── Check PCIe detection ──────────────────────────────────────────────────────
log "Checking PCIe bus for Hailo-10H..."
if lspci 2>/dev/null | grep -qi "hailo\|1e60"; then
  log "Hailo-10H detected on PCIe bus ✓"
else
  warn "Hailo-10H not detected on PCIe — check physical connection"
  warn "Ensure PCIe splitter is seated and HAT power is connected"
  warn "Continuing anyway — may succeed after reboot"
fi

# ── Install HailoRT Python package ───────────────────────────────────────────
log "Installing HailoRT Python runtime..."
pip3 install hailort --break-system-packages -q && \
  log "HailoRT Python package installed ✓" || \
  warn "HailoRT pip install failed — trying alternative method"

# ── Install DKMS kernel module ────────────────────────────────────────────────
log "Installing Hailo DKMS kernel module..."
apt install -y dkms linux-headers-$(uname -r) -qq 2>/dev/null || \
  warn "DKMS install failed — manual kernel module installation may be needed"

# ── Try to download HailoRT .deb from Hailo developer zone ───────────────────
HAILO_DEB_URL="https://hailo-hailort.s3.amazonaws.com/Hailo8/4.18.0/hailort_4.18.0_arm64.deb"
HAILO_DEB="/tmp/hailort.deb"

log "Attempting HailoRT .deb download..."
if wget -q --timeout=30 -O "$HAILO_DEB" "$HAILO_DEB_URL" 2>/dev/null; then
  dpkg -i "$HAILO_DEB" 2>/dev/null && \
    log "HailoRT .deb installed ✓" || \
    warn ".deb install failed — may need manual install from hailo.ai developer zone"
  rm -f "$HAILO_DEB"
else
  warn "HailoRT .deb download failed"
  warn "Manual install: https://hailo.ai/developer-zone/software-downloads/"
fi

# ── Enable PCIe Gen 3 for better bandwidth ────────────────────────────────────
CONFIG="/boot/config.txt"
if [ -f "$CONFIG" ]; then
  if ! grep -q "pciex1_gen=3" "$CONFIG"; then
    echo "" >> "$CONFIG"
    echo "# Phoenix OS — Enable PCIe Gen 3 for Hailo-10H" >> "$CONFIG"
    echo "dtparam=pciex1_gen=3" >> "$CONFIG"
    log "PCIe Gen 3 enabled in config.txt ✓"
  else
    log "PCIe Gen 3 already enabled"
  fi
fi

# ── Test Hailo ────────────────────────────────────────────────────────────────
log "Testing Hailo-10H connection..."
python3 -c "
import hailo_platform as hp
devices = hp.Device.scan()
if devices:
    print(f'  Hailo devices found: {devices}')
else:
    print('  No Hailo devices found — reboot may be required')
" 2>/dev/null || warn "Hailo Python test failed — reboot and try again"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Hailo-10H Install Complete — Reboot Recommended   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  After reboot verify with: ${CYAN}lspci | grep -i hailo${NC}"
echo -e "  Or run: ${CYAN}python3 -c 'import hailo_platform as hp; print(hp.Device.scan())'${NC}"
echo ""
