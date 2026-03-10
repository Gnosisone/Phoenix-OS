#!/usr/bin/env bash
# =============================================================================
# Phoenix OS — MEGA TOOLS INSTALLER
# Combined Arsenal: Kali Linux + BlackArch + Parrot OS
# 500+ Security Tools Across All Categories
# Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
# Usage: sudo bash scripts/install_tools.sh
# =============================================================================

set -e
ORANGE='\033[0;33m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
LOG="/var/log/phoenix-tools.log"
PASS=0; FAIL=0; SKIP=0

log()     { echo -e "${GREEN}[+]${NC} $1" | tee -a "$LOG"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1" | tee -a "$LOG"; }
err()     { echo -e "${RED}[-]${NC} $1" | tee -a "$LOG"; }
section() { echo -e "\n${ORANGE}${BOLD}╔══ $1 ══╗${NC}" | tee -a "$LOG"; }

banner() {
  clear
  echo -e "${ORANGE}"
  echo "  ██████╗ ██╗  ██╗ ██████╗ ███████╗███╗  ██╗██╗██╗  ██╗"
  echo "  ██╔══██╗██║  ██║██╔═══██╗██╔════╝████╗ ██║██║╚██╗██╔╝"
  echo "  ██████╔╝███████║██║   ██║█████╗  ██╔██╗██║██║ ╚███╔╝ "
  echo "  ██╔═══╝ ██╔══██║██║   ██║██╔══╝  ██║╚████║██║ ██╔██╗ "
  echo "  ██║     ██║  ██║╚██████╔╝███████╗██║ ╚███║██║██╔╝╚██╗"
  echo "  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚══╝╚═╝╚═╝  ╚═╝"
  echo -e "${YELLOW}  MEGA TOOLS INSTALLER — Kali + BlackArch + Parrot OS${NC}"
  echo -e "${CYAN}  500+ Tools | All Categories | $(date)${NC}"
  echo -e "${ORANGE}══════════════════════════════════════════════════════${NC}\n"
}

# Install helpers — never stop on failure
pkg() {
  if apt install -y "$1" -qq 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $1"; ((PASS++))
  else
    echo -e "  ${YELLOW}✗${NC} $1 (not found)"; ((FAIL++))
  fi
}

pipx() {
  if pip3 install "$1" --break-system-packages -q 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $1 (pip)"; ((PASS++))
  else
    echo -e "  ${YELLOW}✗${NC} $1 (pip fail)"; ((FAIL++))
  fi
}

goinst() {
  if command -v go &>/dev/null; then
    if go install "$1" 2>/dev/null; then
      echo -e "  ${GREEN}✓${NC} $1 (go)"; ((PASS++))
    else
      echo -e "  ${YELLOW}✗${NC} $1 (go fail)"; ((FAIL++))
    fi
  fi
}

gitinst() {
  local name="$1" url="$2" dir="/opt/tools/$1"
  if [ -d "$dir" ]; then
    echo -e "  ${CYAN}~${NC} $name (already cloned)"; ((SKIP++)); return
  fi
  mkdir -p /opt/tools
  if git clone --depth=1 "$url" "$dir" -q 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $name (git)"; ((PASS++))
  else
    echo -e "  ${YELLOW}✗${NC} $name (clone fail)"; ((FAIL++))
  fi
}

# =============================================================================
# REPO SETUP
# =============================================================================
setup_repos() {
  section "Setting Up Repositories"
  log "Updating package lists..."
  apt update -qq 2>&1 | tail -1

  # Add BlackArch repo
  if ! grep -rq "blackarch" /etc/apt/sources.list* 2>/dev/null; then
    log "Adding BlackArch repository..."
    curl -fsSL https://blackarch.org/strap.sh -o /tmp/strap.sh 2>/dev/null && \
      chmod +x /tmp/strap.sh && bash /tmp/strap.sh 2>&1 | tail -3 || \
      warn "BlackArch bootstrap failed — continuing with Kali/Parrot repos"
    rm -f /tmp/strap.sh
  else
    log "BlackArch repo already configured"
  fi

  # Parrot tools repo (works on Debian-based)
  if ! grep -rq "parrot" /etc/apt/sources.list* 2>/dev/null; then
    log "Adding Parrot Security repo..."
    wget -qO /etc/apt/trusted.gpg.d/parrot.gpg \
      https://deb.parrot.sh/parrot/misc/parrot.gpg 2>/dev/null || true
  fi

  apt update -qq 2>&1 | tail -1
  log "Repos ready"
}

# =============================================================================
# 01 — INFORMATION GATHERING & OSINT
# =============================================================================
install_recon() {
  section "01 — Information Gathering & OSINT"

  log "Network discovery..."
  for t in nmap masscan unicornscan netdiscover arp-scan nbtscan p0f \
    zmap rustscan onesixtyone snmp-check; do pkg "$t"; done

  log "DNS tools..."
  for t in dnsrecon dnsenum dnsmap fierce dnsx dnstracer dnsutils \
    host bind9-dnsutils; do pkg "$t"; done

  log "Web fingerprinting..."
  for t in whatweb wafw00f wapiti nikto httprint \
    blindsql uniscan; do pkg "$t"; done

  log "Directory fuzzing..."
  for t in dirb dirbuster feroxbuster gobuster ffuf wfuzz \
    dirb wordlists; do pkg "$t"; done

  log "OSINT frameworks..."
  for t in theharvester maltego recon-ng spiderfoot \
    metagoofil eyewitness; do pkg "$t"; done

  log "Subdomain enumeration..."
  for t in amass subfinder sublist3r assetfinder findomain; do pkg "$t"; done

  log "Shodan / Censys..."
  for t in shodan censys; do pipx "$t"; done

  log "Go recon tools..."
  goinst "github.com/projectdiscovery/httpx/cmd/httpx@latest"
  goinst "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
  goinst "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
  goinst "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
  goinst "github.com/tomnomnom/waybackurls@latest"
  goinst "github.com/tomnomnom/gf@latest"
  goinst "github.com/tomnomnom/anew@latest"
  goinst "github.com/lc/gau/v2/cmd/gau@latest"

  log "Git OSINT..."
  gitinst "gitjacker"   "https://github.com/liamg/gitjacker"
  gitinst "gitrob"      "https://github.com/michenriksen/gitrob"
  gitinst "trufflehog"  "https://github.com/trufflesecurity/trufflehog"
  gitinst "gitleaks"    "https://github.com/gitleaks/gitleaks"
}

# =============================================================================
# 02 — VULNERABILITY SCANNING
# =============================================================================
install_vuln_scan() {
  section "02 — Vulnerability Scanning"

  log "Core scanners..."
  for t in openvas gvm lynis unix-privesc-check checksec \
    vulnscan nmap-scripts; do pkg "$t"; done

  log "Web app scanners..."
  for t in sqlmap xsser commix wpscan joomscan droopescan \
    skipfish w3af nikto zaproxy; do pkg "$t"; done

  log "CMS scanners..."
  for t in cms-explorer plecost wpscan joomscan; do pkg "$t"; done

  log "Nuclei templates..."
  goinst "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
  if command -v nuclei &>/dev/null; then
    nuclei -update-templates 2>/dev/null || true
    log "Nuclei templates updated"
  fi

  log "Pip scanners..."
  pipx "vulners"
  pipx "dnstwist"
  pipx "testssl"
}

# =============================================================================
# 03 — EXPLOITATION FRAMEWORKS
# =============================================================================
install_exploitation() {
  section "03 — Exploitation Frameworks"

  log "Core frameworks..."
  for t in metasploit-framework exploitdb beef-xss \
    powershell-empire; do pkg "$t"; done

  log "Exploit tools..."
  for t in pwntools pwndbg gdb gdb-peda ropper \
    one_gadget; do pkg "$t"; done

  log "Python exploit tools..."
  pipx "pwntools"
  pipx "ropper"
  pipx "one_gadget"

  log "Post-exploitation..."
  for t in empire covenant starkiller; do pkg "$t"; done

  gitinst "impacket"     "https://github.com/fortra/impacket"
  gitinst "sliver"       "https://github.com/BishopFox/sliver"
  gitinst "havoc"        "https://github.com/HavocFramework/Havoc"
  gitinst "covenant"     "https://github.com/cobbr/Covenant"

  log "MSF extensions..."
  for t in metasploit-payloads metasploit-nightly; do pkg "$t"; done
}

# =============================================================================
# 04 — WEB APPLICATION ATTACKS
# =============================================================================
install_web_attacks() {
  section "04 — Web Application Attacks"

  log "Injection tools..."
  for t in sqlmap sqlninja bbqsql havij commix \
    xsser dalfox; do pkg "$t"; done

  log "Proxies & interceptors..."
  for t in burpsuite zaproxy mitmproxy proxychains-ng \
    proxychains4; do pkg "$t"; done

  log "Fuzzing..."
  for t in ffuf wfuzz radamsa; do pkg "$t"; done

  log "JWT / Auth attacks..."
  pipx "jwt_tool"
  pipx "flask-unsign"
  gitinst "jwt_tool"    "https://github.com/ticarpi/jwt_tool"
  gitinst "graphw00f"   "https://github.com/dolevf/graphw00f"
  gitinst "graphql-cop" "https://github.com/nicholasaleks/graphql-cop"

  log "Browser tools..."
  for t in chromium firefox-esr; do pkg "$t"; done

  log "API attack tools..."
  gitinst "arjun"       "https://github.com/s0md3v/Arjun"
  gitinst "403bypasser" "https://github.com/yunemse48/403bypasser"
  goinst  "github.com/hakluke/hakrawler@latest"
  goinst  "github.com/s0md3v/uro@latest"
}

# =============================================================================
# 05 — PASSWORD ATTACKS
# =============================================================================
install_passwords() {
  section "05 — Password Attacks"

  log "Cracking engines..."
  for t in hashcat john hydra medusa ncrack; do pkg "$t"; done

  log "Hash tools..."
  for t in hash-identifier hashid hashcat-utils \
    statsprocessor maskprocessor; do pkg "$t"; done

  log "Rainbow tables..."
  for t in ophcrack rainbowcrack; do pkg "$t"; done

  log "Wordlists..."
  for t in wordlists crunch rsmangler cupp seclists; do pkg "$t"; done
  if [ ! -f /usr/share/wordlists/rockyou.txt ]; then
    apt install -y wordlists -qq 2>/dev/null
    gunzip /usr/share/wordlists/rockyou.txt.gz 2>/dev/null || true
    log "rockyou.txt extracted"
  fi

  log "Online attack tools..."
  for t in patator crowbar brutespray; do pkg "$t"; done

  log "Password generators..."
  pipx "pydictor"
  gitinst "mentalist"  "https://github.com/sc0tfree/mentalist"
  gitinst "cewl"       "https://github.com/digininja/CeWL"
}

# =============================================================================
# 06 — WIRELESS ATTACKS
# =============================================================================
install_wireless() {
  section "06 — Wireless Attacks"

  log "WiFi attack suite..."
  for t in aircrack-ng airgeddon wifite2 wifiphisher \
    hostapd hostapd-wpe freeradius-wpe; do pkg "$t"; done

  log "WiFi tools..."
  for t in kismet wireshark tshark tcpdump bettercap \
    reaver bully pixiewps mdk3 mdk4 wifijammer; do pkg "$t"; done

  log "Bluetooth attacks..."
  for t in bluez bluez-tools btscanner bluesnarfer \
    spooftooph ubertooth bluehydra; do pkg "$t"; done

  log "RF / SDR tools..."
  for t in gqrx rtl-sdr gr-osmosdr gnuradio \
    hackrf kalibrate-rtl; do pkg "$t"; done

  log "RFID / NFC..."
  for t in libnfc-bin libnfc-examples mfoc mfcuk \
    nfcutils; do pkg "$t"; done

  gitinst "eaphammer"   "https://github.com/s0lst1c3/eaphammer"
  gitinst "airpwn-ng"   "https://github.com/ICSec/airpwn-ng"
}

# =============================================================================
# 07 — NETWORK ATTACKS
# =============================================================================
install_network() {
  section "07 — Network Attacks"

  log "MitM tools..."
  for t in ettercap-graphical ettercap-text-only arpspoof \
    bettercap dsniff mitmproxy sslstrip responder; do pkg "$t"; done

  log "Packet tools..."
  for t in scapy hping3 nemesis yersinia nmap \
    tcpreplay netcat-openbsd socat; do pkg "$t"; done

  log "Routing attacks..."
  for t in loki thc-ipv6 chisel iodine \
    dnscat2; do pkg "$t"; done

  log "VPN / Tunnel tools..."
  for t in openvpn vpnc openconnect \
    proxychains4 sshuttle; do pkg "$t"; done

  log "Sniffing tools..."
  for t in wireshark tshark tcpdump driftnet \
    urlsnarf mailsnarf; do pkg "$t"; done

  pipx "scapy"
  gitinst "responder"  "https://github.com/lgandx/Responder"
  gitinst "mitm6"      "https://github.com/dirkjanm/mitm6"
  gitinst "bettercap"  "https://github.com/bettercap/bettercap"
}

# =============================================================================
# 08 — ACTIVE DIRECTORY & WINDOWS ATTACKS
# =============================================================================
install_active_directory() {
  section "08 — Active Directory & Windows Attacks"

  log "AD attack tools..."
  for t in bloodhound neo4j crackmapexec \
    enum4linux enum4linux-ng smbclient smbmap; do pkg "$t"; done

  log "Kerberos attacks..."
  for t in krb5-user; do pkg "$t"; done

  log "Impacket tools (Python AD suite)..."
  pipx "impacket"
  # Individual impacket scripts
  for script in GetADUsers GetUserSPNs GetNPUsers secretsdump \
    psexec smbexec wmiexec dcomexec atexec lookupsid \
    samrdump rpcdump; do
    log "  impacket-$script"
  done

  log "PowerShell attack tools..."
  for t in powershell crackmapexec evil-winrm; do pkg "$t"; done

  log "LDAP tools..."
  for t in ldap-utils ldapscripts; do pkg "$t"; done

  gitinst "bloodhound.py" "https://github.com/dirkjanm/BloodHound.py"
  gitinst "kerbrute"      "https://github.com/ropnop/kerbrute"
  gitinst "ldapdomaindump" "https://github.com/dirkjanm/ldapdomaindump"
  gitinst "adidnsdump"    "https://github.com/dirkjanm/adidnsdump"
  gitinst "ntlmrelayx"    "https://github.com/fortra/impacket"
  gitinst "pypykatz"      "https://github.com/skelsec/pypykatz"
}

# =============================================================================
# 09 — POST EXPLOITATION & PIVOTING
# =============================================================================
install_post_exploit() {
  section "09 — Post Exploitation & Pivoting"

  log "C2 frameworks..."
  for t in metasploit-framework empire; do pkg "$t"; done

  log "Pivoting tools..."
  for t in chisel sshuttle proxychains4 \
    socat netcat-openbsd; do pkg "$t"; done

  log "Lateral movement..."
  for t in crackmapexec evil-winrm; do pkg "$t"; done

  log "Data exfil..."
  for t in dnscat2 iodine icmpsh; do pkg "$t"; done

  log "Persistence tools..."
  for t in weevely; do pkg "$t"; done

  gitinst "ligolo-ng"  "https://github.com/nicocha30/ligolo-ng"
  gitinst "chisel"     "https://github.com/jpillora/chisel"
  gitinst "pwncat"     "https://github.com/calebstewart/pwncat"
  gitinst "sliver"     "https://github.com/BishopFox/sliver"
}

# =============================================================================
# 10 — PRIVILEGE ESCALATION
# =============================================================================
install_privesc() {
  section "10 — Privilege Escalation"

  log "Linux privesc..."
  for t in unix-privesc-check linux-exploit-suggester \
    pspy linpeas; do pkg "$t"; done

  log "Windows privesc scripts..."
  gitinst "linpeas-winpeas" "https://github.com/carlospolop/PEASS-ng"
  gitinst "linux-smart-enumeration" "https://github.com/diego-treitos/linux-smart-enumeration"
  gitinst "pspy"            "https://github.com/DominicBreuker/pspy"
  gitinst "sudo_killer"     "https://github.com/TH3xACE/SUDO_KILLER"
  gitinst "gtfobins"        "https://github.com/GTFOBins/GTFOBins.github.io"
  gitinst "suid3num"        "https://github.com/Anon-Exploiter/SUID3NUM"

  pipx "privesc"
}

# =============================================================================
# 11 — FORENSICS & REVERSE ENGINEERING
# =============================================================================
install_forensics() {
  section "11 — Forensics & Reverse Engineering"

  log "Disk & memory forensics..."
  for t in autopsy sleuthkit volatility3 foremost scalpel \
    bulk-extractor dc3dd dcfldd guymager; do pkg "$t"; done

  log "File analysis..."
  for t in binwalk foremost exiftool file strings \
    hexedit ghex xxd; do pkg "$t"; done

  log "Reverse engineering..."
  for t in ghidra radare2 cutter rizin gdb gdb-peda \
    peda pwndbg; do pkg "$t"; done

  log "Disassemblers..."
  for t in nasm objdump readelf ltrace strace; do pkg "$t"; done

  log "Malware analysis..."
  for t in clamav yara; do pkg "$t"; done

  log "Network forensics..."
  for t in wireshark tshark tcpdump networkminer \
    xplico; do pkg "$t"; done

  log "Mobile forensics..."
  for t in adb fastboot android-tools-adb \
    libimobiledevice-utils ideviceinstaller; do pkg "$t"; done

  gitinst "volatility3"    "https://github.com/volatilityfoundation/volatility3"
  gitinst "autopsy"        "https://github.com/sleuthkit/autopsy"
  pipx "yara-python"
  pipx "angr"
}

# =============================================================================
# 12 — SOCIAL ENGINEERING
# =============================================================================
install_social_engineering() {
  section "12 — Social Engineering"

  for t in set beef-xss gophish; do pkg "$t"; done

  gitinst "setoolkit"     "https://github.com/trustedsec/social-engineer-toolkit"
  gitinst "gophish"       "https://github.com/gophish/gophish"
  gitinst "evilginx2"     "https://github.com/kgretzky/evilginx2"
  gitinst "evilginx3"     "https://github.com/kgretzky/evilginx"
  gitinst "modlishka"     "https://github.com/drk1wi/Modlishka"
  gitinst "king-phisher"  "https://github.com/securestate/king-phisher"
  gitinst "zphisher"      "https://github.com/htr-tech/zphisher"
  gitinst "blackeye"      "https://github.com/An0nUD4Y/blackeye"
}

# =============================================================================
# 13 — HARDWARE & PHYSICAL ATTACKS
# =============================================================================
install_hardware() {
  section "13 — Hardware & Physical Attacks"

  log "BadUSB / HID attacks..."
  for t in rubber-ducky; do pkg "$t"; done
  gitinst "ducky-script"   "https://github.com/hak5/usbrubberducky-payloads"
  gitinst "bash-bunny"     "https://github.com/hak5/bashbunny-payloads"

  log "JTAG / Debug interfaces..."
  for t in openocd flashrom; do pkg "$t"; done

  log "Serial tools..."
  for t in minicom screen picocom cu cutecom; do pkg "$t"; done

  log "Chip tools..."
  for t in avrdude binwalk flashrom; do pkg "$t"; done

  log "Power analysis..."
  gitinst "chipwhisperer" "https://github.com/newaetech/chipwhisperer"
}

# =============================================================================
# 14 — CLOUD & CONTAINER ATTACKS
# =============================================================================
install_cloud() {
  section "14 — Cloud & Container Attacks"

  log "AWS tools..."
  pipx "awscli"
  pipx "pacu"
  gitinst "pacu"        "https://github.com/RhinoSecurityLabs/pacu"
  gitinst "cloudfox"    "https://github.com/BishopFox/cloudfox"
  gitinst "s3scanner"   "https://github.com/sa7mon/S3Scanner"

  log "Azure tools..."
  gitinst "stormspotter" "https://github.com/Azure/Stormspotter"
  gitinst "roadtools"    "https://github.com/dirkjanm/ROADtools"

  log "GCP tools..."
  gitinst "gcp_scanner" "https://github.com/google/gcp_scanner"

  log "Kubernetes / Docker..."
  for t in kubectl docker.io docker-compose; do pkg "$t"; done
  gitinst "kube-hunter"  "https://github.com/aquasecurity/kube-hunter"
  gitinst "trivy"        "https://github.com/aquasecurity/trivy"
  gitinst "deepce"       "https://github.com/stealthcopter/deepce"
}

# =============================================================================
# 15 — MALWARE DEVELOPMENT & EVASION (EDUCATIONAL)
# =============================================================================
install_malware_dev() {
  section "15 — Malware Dev & AV Evasion (Educational)"

  log "Payload generators..."
  for t in msfvenom veil shellter; do pkg "$t"; done

  log "Obfuscation tools..."
  gitinst "veil-evasion"    "https://github.com/Veil-Framework/Veil"
  gitinst "scarecrow"       "https://github.com/optiv/ScareCrow"
  gitinst "donut"           "https://github.com/TheWover/donut"
  gitinst "artifact-kit"    "https://github.com/Cobalt-Strike/ArtifactKit"

  log "Shellcode tools..."
  pipx "shellcraft"
  for t in nasm mingw-w64 gcc; do pkg "$t"; done

  log "Sandbox evasion research..."
  gitinst "al-khaser"    "https://github.com/LordNoteworthy/al-khaser"
  gitinst "pafish"       "https://github.com/a0rtega/pafish"
}

# =============================================================================
# 16 — CRYPTOGRAPHY & STEGANOGRAPHY
# =============================================================================
install_crypto_stego() {
  section "16 — Cryptography & Steganography"

  log "Crypto tools..."
  for t in openssl gpg hashcat john \
    ssldump sslscan testssl.sh; do pkg "$t"; done

  log "Steganography..."
  for t in steghide outguess stegosuite \
    stegdetect exiftool; do pkg "$t"; done

  gitinst "stegseek"   "https://github.com/RickdeJager/stegseek"
  gitinst "stegcracker" "https://github.com/Paradoxis/StegCracker"
  pipx "stegcracker"
}

# =============================================================================
# 17 — SNIFFING & TRAFFIC ANALYSIS
# =============================================================================
install_sniffing() {
  section "17 — Sniffing & Traffic Analysis"

  for t in wireshark tshark tcpdump driftnet urlsnarf \
    mailsnarf msgsnarf filesnarf p0f netsniff-ng \
    tcpflow tcpick ngrep; do pkg "$t"; done

  pipx "pyshark"
  gitinst "pcapy"       "https://github.com/helpsystems/pcapy-ng"
}

# =============================================================================
# 18 — BLACKARCH EXCLUSIVE TOOLS
# =============================================================================
install_blackarch_tools() {
  section "18 — BlackArch Exclusive Tools"

  log "BlackArch recon..."
  for t in blackarch-recon dnsbrute dnsenum fierce \
    enum4linux-ng maltego metagoofil; do pkg "$t"; done

  log "BlackArch exploitation..."
  for t in blackarch-exploitation ropgadget \
    ropper pwndbg peda; do pkg "$t"; done

  log "BlackArch crypto..."
  for t in blackarch-crypto hashcat-utils \
    stegsolve; do pkg "$t"; done

  log "BlackArch forensics..."
  for t in blackarch-forensic chkrootkit rkhunter \
    unhide; do pkg "$t"; done

  log "BlackArch fuzzers..."
  for t in blackarch-fuzzer radamsa zzuf \
    honggfuzz afl; do pkg "$t"; done

  log "BlackArch backdoors..."
  for t in blackarch-backdoor weevely \
    b374k; do pkg "$t"; done

  log "Misc BlackArch..."
  for t in blackarch-misc metasploit-framework \
    armitage; do pkg "$t"; done
}

# =============================================================================
# 19 — PARROT OS EXCLUSIVE TOOLS
# =============================================================================
install_parrot_tools() {
  section "19 — Parrot OS Exclusive Tools"

  log "Parrot recon suite..."
  for t in recon-ng maltego theharvester \
    spiderfoot; do pkg "$t"; done

  log "Parrot anonymity tools..."
  for t in tor torbrowser-launcher tor-browser \
    proxychains4 anonsurf; do pkg "$t"; done

  log "Parrot forensics..."
  for t in autopsy sleuthkit foremost \
    guymager; do pkg "$t"; done

  log "Parrot dev tools..."
  for t in python3-pip ruby-full nodejs npm \
    golang default-jdk; do pkg "$t"; done

  gitinst "anonsurf"     "https://github.com/ParrotSec/anonsurf"
}

# =============================================================================
# 20 — DEVELOPER & UTILITY TOOLS
# =============================================================================
install_dev_tools() {
  section "20 — Developer & Utility Tools"

  log "Core dev tools..."
  for t in git curl wget python3 python3-pip ruby ruby-dev \
    nodejs npm golang default-jdk cargo; do pkg "$t"; done

  log "Editors..."
  for t in vim neovim tmux screen; do pkg "$t"; done

  log "Network utils..."
  for t in net-tools iputils-ping traceroute whois \
    dnsutils iproute2 iptables nftables; do pkg "$t"; done

  log "Build tools..."
  for t in build-essential cmake make gcc g++ \
    libssl-dev libffi-dev python3-dev; do pkg "$t"; done

  log "Python security libs..."
  for p in requests beautifulsoup4 paramiko cryptography \
    pycryptodome scapy impacket ldap3 pyOpenSSL \
    dnspython netaddr boto3 azure-identity \
    google-cloud-storage kubernetes; do pipx "$p"; done
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================
main() {
  banner

  # Check root
  if [ "$EUID" -ne 0 ]; then
    err "Must run as root: sudo bash install_tools.sh"
    exit 1
  fi

  mkdir -p /opt/tools /var/log
  touch "$LOG"

  log "Starting Phoenix OS Mega Tools Installer..."
  log "Log: $LOG"
  log "This will take 30-90 minutes depending on internet speed"
  echo ""

  # Run all categories
  setup_repos
  install_recon
  install_vuln_scan
  install_exploitation
  install_web_attacks
  install_passwords
  install_wireless
  install_network
  install_active_directory
  install_post_exploit
  install_privesc
  install_forensics
  install_social_engineering
  install_hardware
  install_cloud
  install_malware_dev
  install_crypto_stego
  install_sniffing
  install_blackarch_tools
  install_parrot_tools
  install_dev_tools

  # Final summary
  TOTAL=$((PASS + FAIL + SKIP))
  echo ""
  echo -e "${ORANGE}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${ORANGE}║         PHOENIX OS TOOLS INSTALL COMPLETE           ║${NC}"
  echo -e "${ORANGE}╠══════════════════════════════════════════════════════╣${NC}"
  echo -e "${ORANGE}║${NC} ${GREEN}Installed:${NC} $PASS tools                                  ${ORANGE}║${NC}"
  echo -e "${ORANGE}║${NC} ${YELLOW}Skipped:${NC}   $SKIP tools (already present)               ${ORANGE}║${NC}"
  echo -e "${ORANGE}║${NC} ${RED}Failed:${NC}    $FAIL tools (not in repos)                 ${ORANGE}║${NC}"
  echo -e "${ORANGE}║${NC} ${CYAN}Total:${NC}     $TOTAL tools processed                         ${ORANGE}║${NC}"
  echo -e "${ORANGE}║${NC} ${CYAN}Log:${NC}       $LOG                  ${ORANGE}║${NC}"
  echo -e "${ORANGE}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  Tools installed to: ${CYAN}/usr/bin, /usr/local/bin, /opt/tools${NC}"
  echo -e "  ${ORANGE}Born from the ashes of every failed boot. 🔥${NC}"
  echo ""
}

main "$@"
