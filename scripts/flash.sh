#!/usr/bin/env bash
# =============================================================================
# PHOENIX OS — NVMe Flash Script
# Flashes Phoenix OS image to target NVMe drive
# Usage: sudo bash scripts/flash.sh /dev/nvme0n1
# =============================================================================

set -e
ORANGE='\033[0;33m'; GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'

TARGET="${1:-}"
BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/build"
IMAGE=$(ls "$BUILD_DIR"/Phoenix-OS-*.img 2>/dev/null | tail -1)

[ -z "$TARGET" ] && { echo -e "${RED}Usage: sudo bash scripts/flash.sh /dev/nvme0n1${NC}"; exit 1; }
[ -z "$IMAGE" ]  && { echo -e "${RED}No image found in $BUILD_DIR — run build_image.sh first${NC}"; exit 1; }
[ "$EUID" -ne 0 ] && { echo -e "${RED}Run as root${NC}"; exit 1; }

echo -e "${ORANGE}🔥 PHOENIX OS FLASH UTILITY${NC}"
echo -e "  Image:  ${IMAGE}"
echo -e "  Target: ${TARGET}"
echo -e "${RED}  WARNING: This will ERASE all data on ${TARGET}${NC}"
echo -n "  Type 'PHOENIX' to confirm: "
read -r confirm
[ "$confirm" != "PHOENIX" ] && { echo "Aborted."; exit 1; }

echo -e "\n  Flashing..."
dd if="$IMAGE" of="$TARGET" bs=4M status=progress conv=fsync
sync

echo -e "\n${GREEN}✓ Phoenix OS flashed to $TARGET${NC}"
echo -e "  Insert NVMe into Pi 5 and power on — Phoenix will rise! 🔥"
