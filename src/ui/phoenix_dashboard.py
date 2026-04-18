"""
Phoenix OS — Boot Dashboard
Animated terminal-style boot screen with Phoenix mascot HUD
Shows hardware status, ERR0RS status, system stats
Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import sys
import time
import threading
from datetime import datetime

# Add parent to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))

ORANGE = '\033[0;33m'
YELLOW = '\033[1;33m'
RED    = '\033[0;31m'
GREEN  = '\033[0;32m'
CYAN   = '\033[0;36m'
PURPLE = '\033[0;35m'
WHITE  = '\033[1;37m'
DIM    = '\033[2m'
NC     = '\033[0m'
BOLD   = '\033[1m'


PHOENIX_ASCII = f"""
{ORANGE}        .         .        {NC}
{ORANGE}      .  \\ . . /  .      {NC}
{YELLOW}    .    .'     '.    .    {NC}
{YELLOW}  .   . /  PHOENIX \\ . .  {NC}
{RED}   .  / /___________\\ \\  . {NC}
{RED}    / /  ___________  \\ \\   {NC}
{ORANGE}   / / /    Pi 5    \\ \\ \\  {NC}
{ORANGE}  / / / ___________  \\ \\ \\ {NC}
{YELLOW} ( ( (  Hailo  NPU  ) ) )  {NC}
{RED}  \\ \\ \\_______________/ / /  {NC}
{ORANGE}   \\ \\_______________/ /   {NC}
{YELLOW}    \\_______________/      {NC}
{RED}      |||  |||  |||         {NC}
{ORANGE}      |||  |||  |||         {NC}
"""

BOOT_MESSAGES = [
    (GREEN,  "✓", "Kernel loaded — Linux aarch64 6.6+"),
    (GREEN,  "✓", "PCIe bus initialized"),
    (GREEN,  "✓", "Hailo-10H NPU detected — 26 TOPS ready"),
    (GREEN,  "✓", "NVMe primary mounted — /dev/nvme0n1"),
    (GREEN,  "✓", "NVMe secondary mounted — /dev/nvme1n1"),
    (GREEN,  "✓", "RP2040 wireless MCU online"),
    (GREEN,  "✓", "ESP-12E WiFi module ready"),
    (GREEN,  "✓", "Network interfaces up"),
    (CYAN,   "~", "Starting Ollama LLM service..."),
    (GREEN,  "✓", "Ollama ready — llama3.2 loaded"),
    (CYAN,   "~", "Initializing ERR0RS ULTIMATE..."),
    (GREEN,  "✓", "ERR0RS AI agents online"),
    (GREEN,  "✓", "ChromaDB knowledge base loaded"),
    (GREEN,  "✓", "Web UI starting on :8765"),
    (ORANGE, "🔥", "PHOENIX OS READY"),
]


def clear():
    os.system('clear' if os.name != 'nt' else 'cls')


def print_header():
    print(f"{ORANGE}{'═' * 60}{NC}")
    print(f"{ORANGE}  ██████╗ ██╗  ██╗ ██████╗ ███████╗███╗  ██╗██╗██╗  ██╗{NC}")
    print(f"{YELLOW}  ██╔══██╗██║  ██║██╔═══██╗██╔════╝████╗ ██║██║╚██╗██╔╝{NC}")
    print(f"{ORANGE}  ██████╔╝███████║██║   ██║█████╗  ██╔██╗██║██║ ╚███╔╝ {NC}")
    print(f"{YELLOW}  ██╔═══╝ ██╔══██║██║   ██║██╔══╝  ██║╚████║██║ ██╔██╗ {NC}")
    print(f"{RED}  ██║     ██║  ██║╚██████╔╝███████╗██║ ╚███║██║██╔╝╚██╗{NC}")
    print(f"{ORANGE}  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚══╝╚═╝╚═╝  ╚═╝{NC}")
    print(f"{YELLOW}  OS v1.0 | Pi 5 16GB | Hailo-10H 26 TOPS | ERR0RS ULTIMATE{NC}")
    print(f"{ORANGE}{'═' * 60}{NC}\n")


def print_hardware_hud(hw_status: dict):
    """Print live hardware status HUD"""
    components = hw_status.get("components", {})
    temp = hw_status.get("cpu_temp_c")

    print(f"\n{CYAN}┌─ HARDWARE STATUS {'─' * 40}┐{NC}")

    # Hailo NPU
    hailo = components.get("hailo_npu", False)
    icon = f"{GREEN}●{NC}" if hailo else f"{RED}○{NC}"
    tops = "26 TOPS" if hailo else "NOT DETECTED"
    print(f"{CYAN}│{NC}  {icon} Hailo-10H NPU       {YELLOW}{tops:<20}{NC}              {CYAN}│{NC}")

    # NVMe drives
    nvme0 = components.get("nvme_primary", False)
    nvme1 = components.get("nvme_secondary", False)
    icon0 = f"{GREEN}●{NC}" if nvme0 else f"{RED}○{NC}"
    icon1 = f"{GREEN}●{NC}" if nvme1 else f"{RED}○{NC}"
    print(f"{CYAN}│{NC}  {icon0} NVMe Primary        {'MOUNTED' if nvme0 else 'NOT FOUND':<20}              {CYAN}│{NC}")
    print(f"{CYAN}│{NC}  {icon1} NVMe Secondary      {'MOUNTED' if nvme1 else 'NOT FOUND':<20}              {CYAN}│{NC}")

    # Wireless
    rp2040 = components.get("rp2040", False)
    esp = components.get("esp12e", False)
    icon_r = f"{GREEN}●{NC}" if rp2040 else f"{RED}○{NC}"
    icon_e = f"{GREEN}●{NC}" if esp else f"{RED}○{NC}"
    print(f"{CYAN}│{NC}  {icon_r} RP2040 MCU          {'ONLINE' if rp2040 else 'NOT FOUND':<20}              {CYAN}│{NC}")
    print(f"{CYAN}│{NC}  {icon_e} ESP-12E WiFi        {'READY' if esp else 'NOT FOUND':<20}              {CYAN}│{NC}")

    # Temperature
    if temp:
        color = GREEN if temp < 60 else YELLOW if temp < 75 else RED
        print(f"{CYAN}│{NC}  {color}◈{NC} CPU Temperature     {color}{temp:.1f}°C{NC}                            {CYAN}│{NC}")

    print(f"{CYAN}└{'─' * 58}┘{NC}\n")

def animated_boot():
    """Full animated Phoenix OS boot sequence"""
    clear()
    print_header()
    print(PHOENIX_ASCII)
    time.sleep(1)

    print(f"\n{CYAN}[ BOOT SEQUENCE INITIATED ]{NC}\n")
    time.sleep(0.5)

    for color, icon, msg in BOOT_MESSAGES:
        time.sleep(0.3)
        print(f"  {color}[{icon}]{NC} {msg}")

    time.sleep(0.5)

    # Try to show real hardware status
    try:
        from src.hardware.pi5_manager import Pi5HardwareManager
        hw = Pi5HardwareManager()
        status = hw.get_status()
        status.update(hw.get_system_info())
        print_hardware_hud(status)
    except Exception:
        # Not on Pi 5 — show placeholder
        print(f"\n{DIM}  (Hardware HUD available on Pi 5 hardware){NC}\n")

    # Show access info
    try:
        import socket
        ip = socket.gethostbyname(socket.gethostname())
    except Exception:
        ip = "127.0.0.1"

    print(f"\n{ORANGE}{'═' * 60}{NC}")
    print(f"{GREEN}  ERR0RS ULTIMATE is ONLINE{NC}")
    print(f"{CYAN}  Web UI:  http://{ip}:8765{NC}")
    print(f"{CYAN}  CLI:     python3 /home/kali/ERR0RS-Ultimate/main.py{NC}")
    print(f"{ORANGE}{'═' * 60}{NC}")
    print(f"\n{DIM}  Born from the ashes of every failed boot.{NC}")
    print(f"  {ORANGE}PHOENIX OS{NC} — {DIM}Gnosisone/Phoenix-OS{NC}\n")


def live_hud():
    """Live updating HUD — shows stats while ERR0RS runs"""
    try:
        from src.hardware.pi5_manager import Pi5HardwareManager
        hw = Pi5HardwareManager()
        while True:
            clear()
            print_header()
            status = hw.get_status()
            status.update(hw.get_system_info())
            print_hardware_hud(status)
            print(f"  {DIM}Updated: {datetime.now().strftime('%H:%M:%S')} | Ctrl+C to exit{NC}")
            time.sleep(3)
    except KeyboardInterrupt:
        print(f"\n{ORANGE}Phoenix HUD closed.{NC}\n")
    except Exception as e:
        print(f"\n{RED}HUD error: {e}{NC}\n")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Phoenix OS Dashboard")
    parser.add_argument("--hud", action="store_true", help="Live hardware HUD mode")
    parser.add_argument("--boot", action="store_true", help="Animated boot sequence")
    args = parser.parse_args()

    if args.hud:
        live_hud()
    else:
        animated_boot()
