"""
Phoenix OS — Pi 5 Hardware Manager
Manages Raspberry Pi 5 specific hardware:
- Hailo-10H AI HAT+ via PCIe
- Geekworm X1004 dual NVMe HAT
- Waveshare PCIe splitter
- PiSquare RP2040 + ESP-12E wireless MCU
- GPIO, I2C, SPI, UART interfaces
"""

import os
import subprocess
import logging
from typing import Optional

logger = logging.getLogger(__name__)


class Pi5HardwareManager:
    """Central hardware manager for Phoenix OS Pi 5 build"""

    def __init__(self):
        self.pi5_mode = os.getenv("PI5_MODE", "false").lower() == "true"
        self.components = {}
        if self.pi5_mode:
            self._detect_hardware()

    def _detect_hardware(self):
        """Auto-detect all Pi 5 HAT components"""
        logger.info("Phoenix OS hardware detection starting...")

        self.components = {
            "hailo_npu":   self._check_hailo(),
            "nvme_primary":   self._check_nvme("/dev/nvme0"),
            "nvme_secondary": self._check_nvme("/dev/nvme1"),
            "rp2040":      self._check_rp2040(),
            "esp12e":      self._check_esp12e(),
        }

        for name, status in self.components.items():
            icon = "✓" if status else "✗"
            logger.info(f"  {icon} {name}: {'detected' if status else 'not found'}")

    def _check_hailo(self) -> bool:
        """Check if Hailo-10H is detected on PCIe"""
        try:
            result = subprocess.run(
                ["lspci"], capture_output=True, text=True, timeout=5
            )
            return "hailo" in result.stdout.lower() or "1e60" in result.stdout.lower()
        except Exception:
            return False

    def _check_nvme(self, path: str) -> bool:
        return os.path.exists(path)

    def _check_rp2040(self) -> bool:
        """Check if PiSquare RP2040 is connected via USB"""
        try:
            result = subprocess.run(
                ["lsusb"], capture_output=True, text=True, timeout=5
            )
            return "2e8a" in result.stdout.lower()  # Raspberry Pi USB vendor ID
        except Exception:
            return False

    def _check_esp12e(self) -> bool:
        """Check for ESP-12E via serial"""
        return os.path.exists("/dev/ttyUSB0") or os.path.exists("/dev/ttyAMA0")

    def get_status(self) -> dict:
        return {
            "pi5_mode": self.pi5_mode,
            "components": self.components,
            "hailo_tops": 26 if self.components.get("hailo_npu") else 0,
            "storage": {
                "nvme0": self._get_nvme_info("/dev/nvme0") if self.components.get("nvme_primary") else None,
                "nvme1": self._get_nvme_info("/dev/nvme1") if self.components.get("nvme_secondary") else None,
            }
        }

    def _get_nvme_info(self, device: str) -> Optional[dict]:
        """Get NVMe drive info"""
        try:
            result = subprocess.run(
                ["nvme", "id-ctrl", device, "-o", "json"],
                capture_output=True, text=True, timeout=5
            )
            import json
            data = json.loads(result.stdout)
            return {
                "model": data.get("mn", "Unknown").strip(),
                "serial": data.get("sn", "Unknown").strip(),
                "size": data.get("tnvmcap", 0),
            }
        except Exception:
            return {"device": device, "status": "detected"}

    def get_cpu_temp(self) -> Optional[float]:
        """Get Pi 5 CPU temperature"""
        try:
            with open("/sys/class/thermal/thermal_zone0/temp") as f:
                return int(f.read().strip()) / 1000.0
        except Exception:
            return None

    def get_system_info(self) -> dict:
        """Get full Pi 5 system stats"""
        info = {"pi5_mode": self.pi5_mode}
        temp = self.get_cpu_temp()
        if temp:
            info["cpu_temp_c"] = temp
            info["cpu_temp_f"] = round(temp * 9/5 + 32, 1)
        return info
