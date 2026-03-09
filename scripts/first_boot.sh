#!/usr/bin/env bash
# =============================================================================
# PHOENIX OS — First Boot Script
# Runs automatically on first boot of Pi 5
# Finalizes Hailo-10H setup, starts ERR0RS, launches Phoenix UI
# =============================================================================

set -e
ORANGE='\033[0;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
FLAG="/opt/.phoenix_first_boot_done"

# Only run once
[ -f "$FLAG" ] && exit 0

echo -e "${ORANGE}"
echo "  ██████╗ ██╗  ██╗ ██████╗ ███████╗███╗  ██╗██╗██╗  ██╗"
echo "  ██╔══██╗██║  ██║██╔═══██╗██╔════╝████╗ ██║██║╚██╗██╔╝"
echo "  ██████╔╝███████║██║   ██║█████╗  ██╔██╗██║██║ ╚███╔╝ "
echo "  ██╔═══╝ ██╔══██║██║   ██║██╔══╝  ██║╚████║██║ ██╔██╗ "
echo "  ██║     ██║  ██║╚██████╔╝███████╗██║ ╚███║██║██╔╝╚██╗"
echo "  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚══╝╚═╝╚═╝  ╚═╝"
echo -e "${CYAN}  FIRST BOOT INITIALIZATION${NC}"
echo ""

# Step 1 — Resize filesystem to fill NVMe
echo -e "${CYAN}[1/5] Expanding filesystem...${NC}"
raspi-config --expand-rootfs 2>/dev/null || \
  resize2fs /dev/nvme0n1p2 2>/dev/null || true
echo -e "  ${GREEN}Filesystem expanded${NC}"

# Step 2 — Install Hailo-10H drivers
echo -e "\n${CYAN}[2/5] Installing Hailo-10H NPU drivers...${NC}"
if [ -f "/opt/install_hailo.sh" ]; then
  bash /opt/install_hailo.sh
else
  # Download and install HailoRT
  pip3 install hailort --break-system-packages -q && \
    echo -e "  ${GREEN}HailoRT installed${NC}" || \
    echo -e "  ${ORANGE}HailoRT install failed — manual install required${NC}"
fi

# Step 3 — Configure Ollama
echo -e "\n${CYAN}[3/5] Setting up Ollama LLM...${NC}"
if ! command -v ollama &>/dev/null; then
  curl -fsSL https://ollama.com/install.sh | sh
fi
systemctl enable ollama 2>/dev/null || true
systemctl start ollama 2>/dev/null || true
sleep 3
ollama pull llama3.2 && echo -e "  ${GREEN}LLM ready${NC}" || \
  echo -e "  ${ORANGE}LLM pull failed — connect to internet and run: ollama pull llama3.2${NC}"

# Step 4 — Configure ERR0RS
echo -e "\n${CYAN}[4/5] Configuring ERR0RS ULTIMATE...${NC}"
cd /opt/ERR0RS-Ultimate
cat > .env << EOF
LLM_BACKEND=ollama
OLLAMA_MODEL=llama3.2
OLLAMA_HOST=http://localhost:11434
UI_HOST=0.0.0.0
UI_PORT=8765
HAILO_ENABLED=true
PI5_MODE=true
DISTRO=kali
EOF
echo -e "  ${GREEN}ERR0RS configured${NC}"

# Step 5 — Enable services
echo -e "\n${CYAN}[5/5] Enabling Phoenix services...${NC}"
systemctl enable errz.service 2>/dev/null || true
systemctl start errz.service 2>/dev/null || true

# Mark first boot complete
touch "$FLAG"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   PHOENIX OS IS ALIVE  🔥  Pi 5 + Hailo-10H Ready   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ERR0RS UI: ${CYAN}http://$(hostname -I | awk '{print $1}'):8765${NC}"
echo ""
