"""
Phoenix OS — Core System Manager
Central orchestrator for all Phoenix OS subsystems
Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import sys
import logging
from typing import Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(name)s] %(levelname)s: %(message)s',
    datefmt='%H:%M:%S'
)
logger = logging.getLogger("PhoenixOS")

PI5_MODE   = os.getenv("PI5_MODE",    "false").lower() == "true"
HAILO_MODE = os.getenv("HAILO_ENABLED","false").lower() == "true"
ERRZ_PATH  = os.getenv("ERRZ_PATH",   "/home/kali/ERR0RS-Ultimate")
UI_PORT    = int(os.getenv("UI_PORT", "8765"))


class PhoenixSystem:
    """
    Central system manager — boots and monitors all Phoenix OS subsystems:
    - Hardware (Pi 5, Hailo-10H, NVMe, RP2040)
    - AI Bridge (Hailo NPU ↔ Ollama routing)
    - Wireless Stack (WiFi/BLE attack modules)
    - Vault (encrypted evidence storage)
    - ERR0RS UI (web interface on :8765)
    """

    def __init__(self):
        self.hardware  = None
        self.ai_bridge = None
        self.wireless  = None
        self.vault     = None
        self.errz_proc = None
        self.tool_executor = None
        self._init_subsystems()

    def _init_subsystems(self):
        """Initialize all subsystems with graceful fallback"""

        # Hardware manager
        try:
            from src.hardware.pi5_manager import Pi5HardwareManager
            self.hardware = Pi5HardwareManager()
            logger.info("✓ Hardware manager online")
        except Exception as e:
            logger.warning(f"Hardware manager unavailable: {e}")

        # AI bridge
        try:
            from src.ai.hailo_bridge import get_bridge
            self.ai_bridge = get_bridge()
            logger.info("✓ AI bridge online")
        except Exception as e:
            logger.warning(f"AI bridge unavailable: {e}")

        # Wireless stack
        try:
            from src.network.wireless import WirelessStack
            self.wireless = WirelessStack()
            logger.info(f"✓ Wireless stack online | iface: {self.wireless.interface}")
        except Exception as e:
            logger.warning(f"Wireless stack unavailable: {e}")

        # Vault
        try:
            from src.security.vault import PhoenixVault
            self.vault = PhoenixVault()
            logger.info("✓ Vault online")
        except Exception as e:
            logger.warning(f"Vault unavailable: {e}")

        # Tool registry + executor
        try:
            from src.tools import ToolExecutor, tool_count, list_phases
            self.tool_executor = ToolExecutor()
            logger.info(f"✓ Tool registry loaded — {tool_count()} tools across {len(list_phases())} phases")
        except Exception as e:
            self.tool_executor = None
            logger.warning(f"Tool registry unavailable: {e}")

    def launch_errz(self) -> bool:
        """Launch ERR0RS ULTIMATE web UI as subprocess"""
        import subprocess
        launcher = os.path.join(ERRZ_PATH, "src", "ui", "errorz_launcher.py")
        if not os.path.exists(launcher):
            logger.error(f"ERR0RS launcher not found at {launcher}")
            logger.error(f"Clone ERR0RS: git clone https://github.com/Gnosisone/ERR0RS-Ultimate.git {ERRZ_PATH}")
            return False
        try:
            self.errz_proc = subprocess.Popen(
                [sys.executable, launcher],
                cwd=ERRZ_PATH,
                env={**os.environ, "PI5_MODE": str(PI5_MODE), "HAILO_ENABLED": str(HAILO_MODE)}
            )
            logger.info(f"✓ ERR0RS ULTIMATE launched (PID {self.errz_proc.pid})")
            logger.info(f"  Web UI: http://0.0.0.0:{UI_PORT}")
            return True
        except Exception as e:
            logger.error(f"ERR0RS launch failed: {e}")
            return False

    def get_status(self) -> dict:
        """Full system status snapshot"""
        status = {
            "pi5_mode":    PI5_MODE,
            "hailo_mode":  HAILO_MODE,
            "errz_running": self.errz_proc is not None and self.errz_proc.poll() is None,
            "ui_port":     UI_PORT,
        }
        if self.hardware:
            status["hardware"] = self.hardware.get_status()
        if self.ai_bridge:
            status["ai"] = self.ai_bridge.status()
        if self.wireless:
            status["wireless"] = self.wireless.get_status()
        if self.vault:
            status["vault"] = self.vault.get_vault_stats()
        if self.tool_executor:
            from src.tools import tool_count, list_phases
            status["tools"] = {
                "total_registered": tool_count(),
                "phases": list_phases(),
                "phase_count": len(list_phases()),
            }
        return status

    def shutdown(self):
        """Clean shutdown of all subsystems"""
        logger.info("Phoenix OS shutting down...")
        if self.errz_proc and self.errz_proc.poll() is None:
            self.errz_proc.terminate()
            logger.info("ERR0RS stopped")
        logger.info("Phoenix OS offline.")
