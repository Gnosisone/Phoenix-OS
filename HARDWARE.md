# 🔥 Phoenix OS — Hardware Build Guide

> Complete parts list and assembly guide for the ERR0RS ULTIMATE Pi 5 field unit.
> Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone

---

## 🧠 The Vision

Phoenix OS runs on a Raspberry Pi 5 16GB transformed into a professional-grade,
AI-powered penetration testing field unit. The Hailo-10H NPU handles on-device
AI inference at 26 TOPS — no cloud, no internet required, fully air-gapped.

---

## 📦 Complete Parts List

### Core Unit
| Component | Model | Purpose |
|-----------|-------|---------|
| SBC | Raspberry Pi 5 16GB | Main compute |
| AI Accelerator | Hailo-10H AI HAT+ | 26 TOPS NPU inference |
| NVMe HAT | Geekworm X1004 v1.1 | Dual NVMe M.2 storage |
| PCIe Splitter | Waveshare PCIe Splitter | Split Pi 5 PCIe lane |
| Wireless MCU | PiSquare RP2040 + ESP-12E | WiFi/BLE attack MCU |

### Storage
| Component | Recommended Spec | Purpose |
|-----------|-----------------|---------|
| NVMe Primary | 500GB+ M.2 2280 NVMe | OS + ERR0RS install |
| NVMe Secondary | 256GB+ M.2 2280 NVMe | Evidence + loot storage |

### Power + Cooling
| Component | Spec | Notes |
|-----------|------|-------|
| PSU | 27W USB-C PD | Pi 5 requires 5A @ 5V |
| Active Cooler | Pi 5 Official Active Cooler | Required under Hailo load |
| Case | Open frame or custom | Needs HAT clearance |

---

## 🔌 PCIe Architecture

The Pi 5 has a single PCIe Gen 2 x1 lane via the FFC connector.
The Waveshare PCIe splitter splits this into two lanes:

```
Pi 5 PCIe FFC
      │
      ▼
Waveshare PCIe Splitter
      │
      ├──► Slot 1 → Hailo-10H AI HAT+ (NPU)
      │
      └──► Slot 2 → Geekworm X1004 v1.1 (Dual NVMe)
                          │
                          ├──► nvme0 → OS Drive (Kali ARM64)
                          └──► nvme1 → Data Drive
```

> ⚠️ NOTE: PCIe splitter reduces bandwidth per device.
> Hailo-10H and NVMe both operate at PCIe Gen 2 x1 speeds.
> For most pentest workloads this is sufficient.

---

## 🛠️ Assembly Order

### Step 1 — Flash OS to NVMe (before assembly)
```bash
# On a separate Linux machine
sudo dd if=Phoenix-OS-Pi5.img of=/dev/nvme0n1 bs=4M status=progress
sync
```

### Step 2 — Install Geekworm X1004 HAT
1. Insert both NVMe drives into X1004 M.2 slots
2. Attach X1004 to Pi 5 GPIO header
3. Connect X1004 PCIe FFC cable to Pi 5 PCIe connector
4. Secure with standoffs

### Step 3 — Install Waveshare PCIe Splitter
1. Connect splitter between Pi 5 PCIe and X1004
2. Route Hailo-10H to splitter slot 1
3. Route X1004 to splitter slot 2

### Step 4 — Install Hailo-10H AI HAT+
1. Mount Hailo-10H on splitter slot 1
2. Ensure thermal pad is seated on Hailo chip
3. Secure with screws

### Step 5 — Install PiSquare RP2040
1. Connect PiSquare to Pi 5 GPIO (sits on top)
2. Flash BadUSB/wireless attack firmware
3. Connect ESP-12E module to PiSquare UART

### Step 6 — Power on
1. Connect 27W USB-C PD power supply
2. Pi 5 boots from NVMe automatically
3. Phoenix OS first boot script runs
4. ERR0RS launches at http://[IP]:8765

---

## 🔍 Verifying Hardware Detection

After boot, run in Phoenix OS terminal:

```bash
# Check Hailo NPU detected
lspci | grep -i hailo

# Check NVMe drives
lsblk | grep nvme

# Check RP2040 via USB
lsusb | grep 2e8a

# Check ESP-12E via serial
ls /dev/ttyUSB* /dev/ttyAMA*

# Full Phoenix hardware status
cd /opt/ERR0RS-Ultimate
python3 -c "
from src.hardware.pi5_manager import Pi5HardwareManager
hw = Pi5HardwareManager()
import json
print(json.dumps(hw.get_status(), indent=2))
"
```

---

## ⚡ Performance Expectations

| Task | Backend | Speed |
|------|---------|-------|
| LLM inference (7B) | Ollama CPU | ~3-8 tok/s |
| Vision/classification | Hailo-10H NPU | ~100+ FPS |
| NVMe read | PCIe Gen2 x1 | ~400 MB/s |
| NVMe write | PCIe Gen2 x1 | ~350 MB/s |
| WiFi scanning | ESP-12E | 2.4GHz b/g/n |

---

## 🐛 Known Issues + Fixes

### Hailo-10H not detected
```bash
# Requires Debian Trixie or Kali 2024.3+
uname -r  # Need 6.6+ kernel
# Install HailoRT
pip3 install hailort --break-system-packages
```

### NVMe not detected
```bash
# Check PCIe splitter is seated
dmesg | grep nvme
# Enable PCIe Gen 3 in config.txt
echo "dtparam=pciex1_gen=3" >> /boot/config.txt
```

### RP2040 not detected
```bash
# Check USB connection
lsusb
# May need udev rule
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", MODE="0666"' \
  > /etc/udev/rules.d/99-rp2040.rules
udevadm control --reload-rules
```

---

## 📐 Dimensions + Field Notes

- Full stack height: ~45mm (Pi 5 + splitter + HATs)
- Weight: ~180g assembled
- Power draw: ~8-15W typical, ~22W peak (Hailo + NVMe + WiFi)
- Operating temp: 0-50°C (active cooling required under load)
- Field battery: Any 65W USB-C PD powerbank = ~4-6hr runtime

---

*Phoenix OS Hardware Guide — Gnosisone/Phoenix-OS*
