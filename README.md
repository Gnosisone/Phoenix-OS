# 🔥 at this point Phoenix OS has 1717 tools from both sudo and pacman repos all in one places and groing as we speak! 4/19/26 11:12am

**Phoenix OS** is the Raspberry Pi 5 field deployment build of the ERR0RS ULTIMATE penetration testing framework. Purpose-built for the Pi 5 16GB + Hailo-10H AI HAT+ hardware stack, Phoenix OS turns a $100 single-board computer into a professional-grade, AI-powered red team field unit.

---

## 🧠 What Is Phoenix OS?

Phoenix OS is **not** just Kali on a Pi. It is a fully custom OS image built on Kali Linux ARM64 that:

- Boots directly into the **ERR0RS ULTIMATE** AI pentest assistant
- Leverages the **Hailo-10H NPU (26 TOPS)** for on-device AI inference
- Runs fully **air-gapped** — zero data leaves the device
- Deploys in seconds via a **single NVMe boot image**
- Designed for **professional client engagements** and **field operations**

---

## ⚡ Hardware Target

| Component | Spec |
|-----------|------|
| SBC | Raspberry Pi 5 16GB |
| Storage | Dual NVMe via Geekworm X1004 v1.1 HAT |
| AI Accelerator | Hailo-10H AI HAT+ (26 TOPS) |
| PCIe Splitter | Waveshare PCIe Splitter |
| Wireless MCU | PiSquare RP2040 + ESP-12E |
| OS Base | Kali Linux ARM64 (Rolling) |

---

## 🔥 Features

- 🤖 **ERR0RS AI Assistant** — Local LLM-powered pentest co-pilot
- 🧠 **Hailo NPU Integration** — Hardware-accelerated AI inference (26 TOPS)
- 🌐 **Full Tool Suite** — Nmap, Metasploit, Hydra, Hashcat, SQLMap + 150 more
- 📡 **Wireless Attack Stack** — WiFi, BLE, Zigbee, BadUSB ready
- 🔒 **Air-Gapped by Design** — No cloud, no telemetry, no data leaks
- 🐱 **ERR0RS + Phoenix Mascots** — Because vibe matters on a field op
- 📦 **One-Shot Deployment** — Flash NVMe and go

---

## 🚀 Quick Start

```bash
# Build Phoenix OS image from source
git clone https://github.com/Gnosisone/Phoenix-OS.git
cd Phoenix-OS
sudo bash scripts/build_image.sh

# Flash to NVMe
sudo bash scripts/flash.sh /dev/nvme0n1

# First boot (automatic)
# Phoenix boots → ERR0RS launches → You're operational
```

---

## 📁 Repository Structure

```
Phoenix-OS/
├── src/
│   ├── core/          # OS core — boot, init, service manager
│   ├── ui/            # Phoenix dashboard + mascot HUD
│   ├── ai/            # Hailo NPU integration + LLM bridge
│   ├── tools/         # Security tool wrappers
│   ├── hardware/      # Pi 5 hardware drivers + HAT support
│   ├── network/       # Network stack + wireless modules
│   └── security/      # Encryption, key mgmt, audit logging
├── config/            # System config files
├── scripts/           # Build, flash, deploy scripts
├── docs/              # Documentation + assets
└── tests/             # Test suite
```

---

## 👤 Author

**Gary Holden Schneider (Eros)**
GitHub: [@Gnosisone](https://github.com/Gnosisone)

Part of the **ERR0RS ULTIMATE** ecosystem.
Sister repo: [ERR0RS-Ultimate](https://github.com/Gnosisone/ERR0RS-Ultimate)

---

## ⚠️ Legal

For authorized penetration testing and educational use only.
Always obtain written permission before testing any system you do not own.

---

*Phoenix OS — The soul of ERR0RS, running on silicon and fire.* 🔥
