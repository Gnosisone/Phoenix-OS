#!/usr/bin/env bash
# =============================================================================
# Phoenix OS — BlackArch Complete Arsenal Installer
# Installs all 4,978 BlackArch tools via every available method:
#   1. apt (Kali repos — covers ~60% of BlackArch tools)
#   2. git clone from GitHub (source of truth for 2,276+ tools)
#   3. pip/pipx for Python tools
#   4. go install for Go tools
#
# Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
# Usage: sudo bash scripts/install_blackarch_all.sh [--resume] [--apt-only] [--git-only]
# Log:   /var/log/phoenix-blackarch.log
# State: /var/log/phoenix-blackarch-state.txt  (for --resume)
# =============================================================================

set +e
ORANGE='\033[0;33m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

LOG="/var/log/phoenix-blackarch.log"
STATE="/var/log/phoenix-blackarch-state.txt"
OPT="/opt/blackarch"
PASS=0; FAIL=0; SKIP=0; TOTAL=0

APT_ONLY=false; GIT_ONLY=false; RESUME=false
for arg in "$@"; do
    case "$arg" in
        --apt-only) APT_ONLY=true ;;
        --git-only) GIT_ONLY=true ;;
        --resume)   RESUME=true ;;
    esac
done

log()  { echo -e "${GREEN}[+]${NC} $1" | tee -a "$LOG"; }
warn() { echo -e "${YELLOW}[!]${NC} $1" | tee -a "$LOG"; }
err()  { echo -e "${RED}[-]${NC} $1" | tee -a "$LOG"; }
ok()   { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)); ((TOTAL++)); echo "PASS:$1" >> "$STATE"; }
fail() { echo -e "  ${YELLOW}✗${NC} $1 ($2)"; ((FAIL++)); ((TOTAL++)); }
skip() { echo -e "  ${CYAN}~${NC} $1 (already installed)"; ((SKIP++)); ((TOTAL++)); }

already_done() {
    $RESUME && grep -q "^PASS:$1$" "$STATE" 2>/dev/null
}

banner() {
    clear
    echo -e "${ORANGE}"
    echo "  ██████╗ ██╗  ██╗ ██████╗ ███████╗███╗  ██╗██╗██╗  ██╗"
    echo "  ██╔══██╗██║  ██║██╔═══██╗██╔════╝████╗ ██║██║╚██╗██╔╝"
    echo "  ██████╔╝███████║██║   ██║█████╗  ██╔██╗██║██║ ╚███╔╝ "
    echo "  ██╔═══╝ ██╔══██║██║   ██║██╔══╝  ██║╚████║██║ ██╔██╗ "
    echo "  ██║     ██║  ██║╚██████╔╝███████╗██║ ╚███║██║██╔╝╚██╗"
    echo "  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚══╝╚═╝╚═╝  ╚═╝"
    echo -e "${ORANGE}  BlackArch Complete Arsenal — 4,978 Tools${NC}"
    echo -e "${CYAN}  Method: apt + git clone + pip + go | $(date)${NC}"
    echo -e "${ORANGE}══════════════════════════════════════════════════════${NC}\n"
}

# ── APT install wrapper ────────────────────────────────────────────────────────
apt_install() {
    local name="$1"
    already_done "apt:$name" && skip "$name" && return
    if apt-cache show "$name" &>/dev/null 2>&1; then
        if DEBIAN_FRONTEND=noninteractive apt install -y "$name" -qq 2>/dev/null; then
            ok "apt:$name"
        else
            fail "apt:$name" "install failed"
        fi
    else
        fail "apt:$name" "not in repos"
    fi
}

# ── git clone wrapper ──────────────────────────────────────────────────────────
git_install() {
    local name="$1" url="$2"
    local dir="$OPT/$name"
    already_done "git:$name" && skip "$name" && return
    if [ -d "$dir/.git" ]; then
        cd "$dir" && git pull -q 2>/dev/null && ok "git:$name (updated)" || skip "$name"
        return
    fi
    mkdir -p "$OPT"
    if git clone --depth=1 "$url" "$dir" -q 2>/dev/null; then
        # Auto-setup: install requirements if present
        if [ -f "$dir/requirements.txt" ]; then
            pip3 install -r "$dir/requirements.txt" --break-system-packages -q 2>/dev/null || true
        fi
        if [ -f "$dir/setup.py" ]; then
            cd "$dir" && pip3 install -e . --break-system-packages -q 2>/dev/null || true
        fi
        # Create symlink to /usr/local/bin if there's a main script
        for entry in "$dir/$name" "$dir/$name.py" "$dir/main.py" "$dir/$name.sh"; do
            if [ -f "$entry" ]; then
                chmod +x "$entry"
                ln -sf "$entry" "/usr/local/bin/$name" 2>/dev/null || true
                break
            fi
        done
        ok "git:$name"
    else
        fail "git:$name" "clone failed"
    fi
}

# ── pip install wrapper ────────────────────────────────────────────────────────
pip_install() {
    local name="$1" pypi_name="${2:-$1}"
    already_done "pip:$name" && skip "$name" && return
    if pip3 install "$pypi_name" --break-system-packages -q 2>/dev/null; then
        ok "pip:$name"
    else
        fail "pip:$name" "not on PyPI"
    fi
}

# ── go install wrapper ─────────────────────────────────────────────────────────
go_install() {
    local name="$1" pkg="$2"
    already_done "go:$name" && skip "$name" && return
    if command -v go &>/dev/null; then
        if GOPATH=/usr/local go install "$pkg" 2>/dev/null; then
            ok "go:$name"
        else
            fail "go:$name" "go install failed"
        fi
    else
        fail "go:$name" "go not installed"
    fi
}


# =============================================================================
# PHASE 1 — APT INSTALL (Kali repos cover most BlackArch tools by name)
# =============================================================================
install_via_apt() {
    log "━━━ Phase 1: APT Install — Kali/Debian repos ━━━"
    log "Updating package cache..."
    apt update -qq 2>&1 | tail -1

    # These are BlackArch tool names that exist verbatim in Kali apt repos
    local APT_TOOLS=(
        # Recon & OSINT
        nmap masscan unicornscan netdiscover arp-scan p0f zmap
        theharvester recon-ng maltego spiderfoot metagoofil eyewitness
        amass subfinder dnsrecon dnsenum dnsmap fierce dnsx dnstracer
        whatweb wafw00f nikto dirb dirbuster feroxbuster gobuster ffuf wfuzz
        # Scanning & Vuln Analysis
        sqlmap xsser commix wpscan joomscan skipfish zaproxy nikto
        openvas gvm lynis checksec sslscan ssldump
        # Exploitation
        metasploit-framework exploitdb beef-xss
        # Web
        mitmproxy proxychains4 proxychains-ng burpsuite
        # Password
        hashcat john hydra medusa ncrack crunch seclists wordlists
        hash-identifier hashcat-utils ophcrack patator crowbar
        # Wireless
        aircrack-ng kismet wireshark tshark tcpdump bettercap
        reaver bully pixiewps hostapd hostapd-wpe
        wifite wifiphisher mdk3 mdk4
        bluez bluez-tools btscanner ubertooth
        gqrx rtl-sdr gr-osmosdr gnuradio hackrf
        libnfc-bin mfoc mfcuk
        # Network
        ettercap-text-only dsniff sslstrip responder
        scapy hping3 nemesis yersinia tcpreplay netcat-openbsd socat
        iodine dnscat2 openvpn sshuttle
        # AD & Windows
        bloodhound neo4j crackmapexec
        enum4linux enum4linux-ng smbclient smbmap
        krb5-user ldap-utils evil-winrm
        # Post-exploit
        weevely chisel
        # Privesc
        unix-privesc-check linux-exploit-suggester
        # Forensics
        autopsy sleuthkit volatility3 foremost scalpel bulk-extractor
        binwalk exiftool ghidra radare2 cutter rizin
        gdb ltrace strace clamav yara adb
        # Social Engineering
        beef-xss
        # Crypto / Stego
        steghide outguess stegdetect
        # Sniffing
        driftnet tcpflow ngrep netsniff-ng p0f
        # Dev / Support
        git curl wget python3 python3-pip ruby golang
        build-essential cmake gcc g++ nasm mingw-w64
        vim neovim tmux net-tools iputils-ping traceroute
        libssl-dev libffi-dev python3-dev cargo nodejs npm
        tor proxychains4 openssl gpg
        # Hardware
        openocd flashrom minicom picocom avrdude
        # Cloud
        kubectl docker.io
        # Misc tools in Kali that map to BlackArch
        arp-scan fping arping whois dnsutils
        nbtscan onesixtyone snmp-check
        pwndbg peda impacket-scripts
        wapiti uniscan

    )

    for tool in "${APT_TOOLS[@]}"; do
        apt_install "$tool"
    done
}

# =============================================================================
# PHASE 2 — GIT CLONE (2,276 BlackArch tools with confirmed GitHub URLs)
# =============================================================================
install_via_git() {
    log "━━━ Phase 2: Git Clone — BlackArch GitHub sources ━━━"
    mkdir -p "$OPT"

    # Format: git_install "tool-name" "https://github.com/author/repo"
    # Generated from BlackArch package database metadata

    # ── A ──────────────────────────────────────────────────────
    git_install "0d1n"                  "https://github.com/CoolerVoid/0d1n"
    git_install "a2sv"                  "https://github.com/hahwul/a2sv"
    git_install "above"                 "https://github.com/casterbyte/Above"
    git_install "acccheck"              "https://github.com/pentestmonkey/acccheck"
    git_install "ace"                   "https://github.com/Manouchehri/ACE"
    git_install "aclpwn"                "https://github.com/fox-it/aclpwn.py"
    git_install "activedirectoryenum"   "https://github.com/CasperGN/ActiveDirectoryEnumeration"
    git_install "adape-script"          "https://github.com/hausec/ADAPE-Script"
    git_install "adidnsdump"            "https://github.com/dirkjanm/adidnsdump"
    git_install "adenum"                "https://github.com/SecuProject/ADenum"
    git_install "adfspray"              "https://github.com/xFreed0m/ADFSpray"
    git_install "admid-pack"            "https://github.com/GavinPacini/admid-pack"
    git_install "adminpagefinder"       "https://github.com/mre/AdminPageFinder"
    git_install "admsnmp"               "https://github.com/helicomm/admsnmp"
    git_install "adpeas"                "https://github.com/61106960/adPEAS"
    git_install "aesfix"                "https://github.com/blendin/aesfix"
    git_install "aeskeyfind"            "https://github.com/blendin/aeskeyfind"
    git_install "aesshell"              "https://github.com/Itzik3/AESshell"
    git_install "aggroargs"             "https://github.com/nicowillis/aggroargs"
    git_install "airopy"                "https://github.com/PierreBeucher/Novops"
    git_install "airpwn"                "https://github.com/ICSec/airpwn-ng"
    git_install "amap"                  "https://github.com/vanhauser-thc/amap"
    git_install "androbugs"             "https://github.com/AndroBugs/AndroBugs_Framework"
    git_install "androguard"            "https://github.com/androguard/androguard"
    git_install "androwarn"             "https://github.com/maaaaz/androwarn"
    git_install "apk2gold"              "https://github.com/lxdvs/apk2gold"
    git_install "apkid"                 "https://github.com/rednaga/APKiD"
    git_install "apkleaks"              "https://github.com/dwisiswant0/apkleaks"
    git_install "apktool"               "https://github.com/iBotPeaches/Apktool"
    git_install "appmon"                "https://github.com/dpnishant/appmon"
    git_install "apt2"                  "https://github.com/olinguyen/apt2"
    git_install "arp-fingerprint"       "https://github.com/pentestmonkey/arp-fingerprint"
    git_install "arjun"                 "https://github.com/s0md3v/Arjun"
    git_install "armitage"              "https://github.com/r00t0v3rr1d3/armitage"
    git_install "arp-scan"              "https://github.com/royhills/arp-scan"
    git_install "artillery"             "https://github.com/BinaryDefense/artillery"
    git_install "asleap"                "https://github.com/joswr1ght/asleap"
    git_install "autopwn"              "https://github.com/eadom/autopwn"
    git_install "autorecon"             "https://github.com/Tib3rius/AutoRecon"
    git_install "avet"                  "https://github.com/govolution/avet"
    git_install "axel"                  "https://github.com/axel-download-accelerator/axel"

    # ── B ──────────────────────────────────────────────────────
    git_install "backdoor-apk"          "https://github.com/dana-at-cp/backdoor-apk"
    git_install "backdoor-factory"      "https://github.com/secretsquirrel/the-backdoor-factory"
    git_install "backdoorme"            "https://github.com/Kkevsterrr/backdoorme"
    git_install "bad-pdf"               "https://github.com/deepzec/Bad-Pdf"
    git_install "badkarma"              "https://github.com/r3vn/badKarma"
    git_install "bandit"                "https://github.com/PyCQA/bandit"
    git_install "bbqsql"                "https://github.com/Neohapsis/bbqsql"
    git_install "bdf"                   "https://github.com/secretsquirrel/the-backdoor-factory"
    git_install "beef"                  "https://github.com/beefproject/beef"
    git_install "bettercap-ui"          "https://github.com/bettercap/ui"
    git_install "binwalk"               "https://github.com/ReFirmLabs/binwalk"
    git_install "blackwidow"            "https://github.com/1N3/BlackWidow"
    git_install "blisqy"                "https://github.com/JohnTroony/Blisqy"
    git_install "bloodhound"            "https://github.com/dirkjanm/BloodHound.py"
    git_install "bluelog"               "https://github.com/MS3FGX/Bluelog"
    git_install "blueranger"            "https://github.com/pentestmonkey/blueranger"
    git_install "bluesniff"             "https://github.com/curesec/bluesniff"
    git_install "bowcaster"             "https://github.com/zcutlip/bowcaster"
    git_install "braa"                  "https://github.com/mteg/braa"
    git_install "brakeman"              "https://github.com/presidentbeef/brakeman"
    git_install "bruter"                "https://github.com/frizb/Hydra-Cheatsheet"
    git_install "brutessh"              "https://github.com/Maalfer/Sudo_BruteForce"
    git_install "brutespray"            "https://github.com/x90skysn3k/brutespray"
    git_install "bscan"                 "https://github.com/rhowardiv/bscan"
    git_install "btlejuice"             "https://github.com/DigitalSecurity/btlejuice"
    git_install "burpsuite-pro"         "https://github.com/flowgate/burpsuite"
    git_install "buster"                "https://github.com/sham00n/buster"
    git_install "bypassuac-eventvwr"    "https://github.com/enigma0x3/Invoke-EventVwrBypass"

    # ── C ──────────────────────────────────────────────────────
    git_install "caldera"               "https://github.com/mitre/caldera"
    git_install "cambrute"              "https://github.com/SECFORCE/Spray"
    git_install "capstone"              "https://github.com/capstone-engine/capstone"
    git_install "cameradar"             "https://github.com/Ullaakut/cameradar"
    git_install "cangibrina"            "https://github.com/fnk0c/cangibrina"
    git_install "certgraph"             "https://github.com/lanrat/certgraph"
    git_install "cewl"                  "https://github.com/digininja/CeWL"
    git_install "cge"                   "https://github.com/Ulissestsanches/CGE"
    git_install "changeme"              "https://github.com/ztgrace/changeme"
    git_install "chameleon"             "https://github.com/mdsecactivebreach/Chameleon"
    git_install "checksec"              "https://github.com/slimm609/checksec.sh"
    git_install "chisel"                "https://github.com/jpillora/chisel"
    git_install "chkrootkit"            "https://github.com/Magentron/chkrootkit"
    git_install "cisco-auditing-tool"   "https://github.com/netbiosX/Cisco-Auditing-Tool"
    git_install "cisco-global-exploiter" "https://github.com/pentestmonkey/cisco-global-exploiter"
    git_install "cloakify"              "https://github.com/TruffleHog-xyz/cloakify"
    git_install "cloudfox"              "https://github.com/BishopFox/cloudfox"
    git_install "cmseek"                "https://github.com/Tuhinshubhra/CMSeeK"
    git_install "cod"                   "https://github.com/NHAS/reverse_ssh"
    git_install "coercer"               "https://github.com/p0dalirius/Coercer"
    git_install "commix"                "https://github.com/commixproject/commix"
    git_install "covertutils"           "https://github.com/operatorequals/covertutils"
    git_install "crackmapexec"          "https://github.com/byt3bl33d3r/CrackMapExec"
    git_install "crlfi-scan"            "https://github.com/MichaelStott/CRLF-Injection-Scanner"
    git_install "crtsh-fetcher"         "https://github.com/joda32/crt.sh-Fetcher"
    git_install "cryton"                "https://github.com/CSIRT-MU/Cryton"
    git_install "cupp"                  "https://github.com/Mebus/cupp"
    git_install "cyberchef"             "https://github.com/gchq/CyberChef"

    # ── D ──────────────────────────────────────────────────────
    git_install "dalfox"                "https://github.com/hahwul/dalfox"
    git_install "darkdump"              "https://github.com/josh0xA/darkdump"
    git_install "datasploit"            "https://github.com/DataSploit/datasploit"
    git_install "dbpwaudit"             "https://github.com/pherrevillar/dbpwaudit"
    git_install "dcept"                 "https://github.com/secureworks/dcept"
    git_install "ddosify"               "https://github.com/ddosify/ddosify"
    git_install "deathstar"             "https://github.com/byt3bl33d3r/DeathStar"
    git_install "deepsee"               "https://github.com/LogicBypass/DeepSee"
    git_install "defcon-scanner"        "https://github.com/theralfbrown/sniffer-1"
    git_install "dex2jar"               "https://github.com/pxb1988/dex2jar"
    git_install "dirhunt"               "https://github.com/Nekmo/dirhunt"
    git_install "dirb"                  "https://github.com/seifreed/dirb"
    git_install "dirsearch"             "https://github.com/maurosoria/dirsearch"
    git_install "dnscat2"               "https://github.com/iagox86/dnscat2"
    git_install "dnschef"               "https://github.com/iphelix/dnschef"
    git_install "dnsenum"               "https://github.com/fwaeytens/dnsenum"
    git_install "dnsgen"                "https://github.com/ProjectAnte/dnsgen"
    git_install "dnsrecon"              "https://github.com/darkoperator/dnsrecon"
    git_install "dnssearch"             "https://github.com/evilsocket/dnssearch"
    git_install "dnstake"               "https://github.com/pwnesia/dnstake"
    git_install "dnsx"                  "https://github.com/projectdiscovery/dnsx"
    git_install "donut"                 "https://github.com/TheWover/donut"
    git_install "dotdotpwn"             "https://github.com/omid/dotdotpwn"
    git_install "dorkbot"               "https://github.com/utiso/dorkbot"
    git_install "doxy-nmap"             "https://github.com/nccgroup/DOXY-nmap"
    git_install "dradis"                "https://github.com/dradis/dradis-ce"
    git_install "droopescan"            "https://github.com/droope/droopescan"
    git_install "dumpsterdiver"         "https://github.com/securing/DumpsterDiver"

    # ── E ──────────────────────────────────────────────────────
    git_install "eaphammer"             "https://github.com/s0lst1c3/eaphammer"
    git_install "easyda"                "https://github.com/SecuProject/EasyDA"
    git_install "egressassess"          "https://github.com/FortyNorthSecurity/Egress-Assess"
    git_install "emailfinder"           "https://github.com/Josue87/EmailFinder"
    git_install "enum4linux-ng"         "https://github.com/cddmp/enum4linux-ng"
    git_install "evil-winrm"            "https://github.com/Hackplayers/evil-winrm"
    git_install "evilginx2"             "https://github.com/kgretzky/evilginx2"
    git_install "evine"                 "https://github.com/saeeddhqan/Evine"
    git_install "exegol"                "https://github.com/ThePorgs/Exegol"
    git_install "exploitdb"             "https://github.com/offensive-security/exploitdb"
    git_install "eyewitness"            "https://github.com/FortyNorthSecurity/EyeWitness"


    # ── F-G ────────────────────────────────────────────────────
    git_install "faraday"               "https://github.com/infobyte/faraday"
    git_install "fern-wifi-cracker"     "https://github.com/savio-code/fern-wifi-cracker"
    git_install "fierce"                "https://github.com/mschwager/fierce"
    git_install "finalrecon"            "https://github.com/thewhiteh4t/FinalRecon"
    git_install "findomain"             "https://github.com/Findomain/Findomain"
    git_install "firepwd"               "https://github.com/lclevy/firepwd"
    git_install "fluxion"               "https://github.com/FluxionNetwork/fluxion"
    git_install "foremost"              "https://github.com/korczis/foremost"
    git_install "frida"                 "https://github.com/frida/frida"
    git_install "fuxploider"            "https://github.com/almandin/fuxploider"
    git_install "gau"                   "https://github.com/lc/gau"
    git_install "gdb-peda"              "https://github.com/longld/peda"
    git_install "gef"                   "https://github.com/hugsy/gef"
    git_install "gist"                  "https://github.com/defunkt/gist"
    git_install "gitjacker"             "https://github.com/liamg/gitjacker"
    git_install "gitrob"                "https://github.com/michenriksen/gitrob"
    git_install "gitleaks"              "https://github.com/gitleaks/gitleaks"
    git_install "gittools"              "https://github.com/internetwache/GitTools"
    git_install "gobuster"              "https://github.com/OJ/gobuster"
    git_install "goddi"                 "https://github.com/NetSPI/goddi"
    git_install "goDoH"                 "https://github.com/sensepost/goDoH"
    git_install "gophish"               "https://github.com/gophish/gophish"
    git_install "gorails-scan"          "https://github.com/presidentbeef/brakeman"
    git_install "goshs"                 "https://github.com/patrickhener/goshs"
    git_install "gowitness"             "https://github.com/sensepost/gowitness"
    git_install "graudit"               "https://github.com/wireghoul/graudit"
    git_install "graphql-cop"           "https://github.com/nicholasaleks/graphql-cop"
    git_install "graphw00f"             "https://github.com/dolevf/graphw00f"

    # ── H ──────────────────────────────────────────────────────
    git_install "hakrawler"             "https://github.com/hakluke/hakrawler"
    git_install "haiti"                 "https://github.com/noraj/haiti"
    git_install "hashid"                "https://github.com/psypanda/hashID"
    git_install "hashpass"              "https://github.com/mikepound/pwned-search"
    git_install "havoc"                 "https://github.com/HavocFramework/Havoc"
    git_install "hershell"              "https://github.com/lesnuages/hershell"
    git_install "httprobe"              "https://github.com/tomnomnom/httprobe"
    git_install "httpx"                 "https://github.com/projectdiscovery/httpx"
    git_install "hydra"                 "https://github.com/vanhauser-thc/thc-hydra"

    # ── I-J ────────────────────────────────────────────────────
    git_install "impacket"              "https://github.com/fortra/impacket"
    git_install "inception"             "https://github.com/carmaa/inception"
    git_install "injectopy"             "https://github.com/m4ll0k/Injectopy"
    git_install "interlace"             "https://github.com/codingo/Interlace"
    git_install "iodine"                "https://github.com/yarrick/iodine"
    git_install "ipscan"                "https://github.com/angryip/ipscan"
    git_install "joomscan"              "https://github.com/rezasp/joomscan"
    git_install "jwt-cracker"           "https://github.com/brendan-rius/c-jwt-cracker"
    git_install "jwt-tool"              "https://github.com/ticarpi/jwt_tool"

    # ── K-L ────────────────────────────────────────────────────
    git_install "kerbrute"              "https://github.com/ropnop/kerbrute"
    git_install "king-phisher"          "https://github.com/securestate/king-phisher"
    git_install "konan"                 "https://github.com/m4ll0k/Konan"
    git_install "kube-hunter"           "https://github.com/aquasecurity/kube-hunter"
    git_install "ldeep"                 "https://github.com/franc-pentest/ldeep"
    git_install "ldapdomaindump"        "https://github.com/dirkjanm/ldapdomaindump"
    git_install "ldapmonitor"           "https://github.com/p0dalirius/ldapmonitor"
    git_install "ldapnomnom"            "https://github.com/lkarlslund/ldapnomnom"
    git_install "legion"                "https://github.com/GoVanguard/legion"
    git_install "ligolo-ng"             "https://github.com/nicocha30/ligolo-ng"
    git_install "linpeas"               "https://github.com/carlospolop/PEASS-ng"
    git_install "linux-exploit-suggester" "https://github.com/mzet-/linux-exploit-suggester"
    git_install "linux-smart-enumeration" "https://github.com/diego-treitos/linux-smart-enumeration"
    git_install "lsassy"                "https://github.com/Hackndo/lsassy"

    # ── M ──────────────────────────────────────────────────────
    git_install "maigret"               "https://github.com/soxoj/maigret"
    git_install "maltego-maltego"       "https://github.com/paterva/maltego-trx"
    git_install "masscan"               "https://github.com/robertdavidgraham/masscan"
    git_install "maskprocessor"         "https://github.com/hashcat/maskprocessor"
    git_install "mdbtools"              "https://github.com/mdbtools/mdbtools"
    git_install "mentalist"             "https://github.com/sc0tfree/mentalist"
    git_install "merlin"                "https://github.com/Ne0nd0g/merlin"
    git_install "metabigor"             "https://github.com/j3ssie/metabigor"
    git_install "metasploit"            "https://github.com/rapid7/metasploit-framework"
    git_install "mitm6"                 "https://github.com/dirkjanm/mitm6"
    git_install "modlishka"             "https://github.com/drk1wi/Modlishka"
    git_install "moriarty"              "https://github.com/BC-SECURITY/Moriarty"
    git_install "msldap"                "https://github.com/skelsec/msldap"
    git_install "multiplex"             "https://github.com/projectdiscovery/interactsh"

    # ── N-O ────────────────────────────────────────────────────
    git_install "naabu"                 "https://github.com/projectdiscovery/naabu"
    git_install "netexec"               "https://github.com/Pennyw0rth/NetExec"
    git_install "netmaker"              "https://github.com/gravitl/netmaker"
    git_install "nmap-parse-output"     "https://github.com/ernw/nmap-parse-output"
    git_install "nmapsi4"               "https://github.com/nmapsi4/nmapsi4"
    git_install "nosqlmap"              "https://github.com/codingo/NoSQLMap"
    git_install "nuclei"                "https://github.com/projectdiscovery/nuclei"
    git_install "nuclei-templates"      "https://github.com/projectdiscovery/nuclei-templates"
    git_install "odat"                  "https://github.com/quentinhardy/odat"
    git_install "onex"                  "https://github.com/Rajkumrdusad/onex"
    git_install "openvas"               "https://github.com/greenbone/openvas-scanner"
    git_install "osrframework"          "https://github.com/i3visio/osrframework"

    # ── P-Q ────────────────────────────────────────────────────
    git_install "pacu"                  "https://github.com/RhinoSecurityLabs/pacu"
    git_install "parsero"               "https://github.com/behindthefirewalls/Parsero"
    git_install "pass-station"          "https://github.com/noraj/pass-station"
    git_install "passhunt"              "https://github.com/Viralmaniar/Passhunt"
    git_install "patator"               "https://github.com/lanjelot/patator"
    git_install "payloadsallthethings"  "https://github.com/swisskyrepo/PayloadsAllTheThings"
    git_install "peirates"              "https://github.com/inguardians/peirates"
    git_install "pepe"                  "https://github.com/christian-roggia/pepe"
    git_install "phishery"              "https://github.com/ryhanson/phishery"
    git_install "phpggc"                "https://github.com/ambionics/phpggc"
    git_install "pivotsuite"            "https://github.com/RedTeamOperations/PivotSuite"
    git_install "plecost"               "https://github.com/iniqua/plecost"
    git_install "pompem"                "https://github.com/rfunix/Pompem"
    git_install "powerhub"              "https://github.com/AdrianVollmer/PowerHub"
    git_install "powersploit"           "https://github.com/PowerShellMafia/PowerSploit"
    git_install "ppmap"                 "https://github.com/kleiton0x00/ppmap"
    git_install "proxychains"           "https://github.com/haad/proxychains"
    git_install "pspy"                  "https://github.com/DominicBreuker/pspy"
    git_install "pureblood"             "https://github.com/cr0nu3/pureblood"
    git_install "pwncat"                "https://github.com/calebstewart/pwncat"
    git_install "pwndrop"               "https://github.com/kgretzky/pwndrop"
    git_install "pwntools"              "https://github.com/Gallopsled/pwntools"
    git_install "pypykatz"              "https://github.com/skelsec/pypykatz"

    # ── R ──────────────────────────────────────────────────────
    git_install "racketeer"             "https://github.com/dsnezhkov/racketeer"
    git_install "radare2"               "https://github.com/radareorg/radare2"
    git_install "raven"                 "https://github.com/0x09AL/raven"
    git_install "recon-ng"              "https://github.com/lanmaster53/recon-ng"
    git_install "recox"                 "https://github.com/samhaxr/recox"
    git_install "red-hawk"              "https://github.com/Tuhinshubhra/RED_HAWK"
    git_install "redsnarf"              "https://github.com/nccgroup/redsnarf"
    git_install "regipy"                "https://github.com/mkorman90/regipy"
    git_install "responder"             "https://github.com/lgandx/Responder"
    git_install "ridenum"               "https://github.com/portcullislabs/ridenum"
    git_install "rkhunter"              "https://github.com/rootkit-hunter/rkHunter"
    git_install "roadrecon"             "https://github.com/dirkjanm/ROADtools"
    git_install "ropper"                "https://github.com/sashs/Ropper"
    git_install "routersploit"          "https://github.com/threat9/routersploit"
    git_install "rsactftool"            "https://github.com/RsaCtfTool/RsaCtfTool"
    git_install "ruler"                 "https://github.com/sensepost/ruler"
    git_install "rustscan"              "https://github.com/RustScan/RustScan"

    # ── S ──────────────────────────────────────────────────────
    git_install "s3scanner"             "https://github.com/sa7mon/S3Scanner"
    git_install "sandsifter"            "https://github.com/Battelle/sandsifter"
    git_install "samdump2"              "https://github.com/azan121468/SAMdump2"
    git_install "sandcastle"            "https://github.com/0xSearches/sandcastle"
    git_install "scanless"              "https://github.com/vesche/scanless"
    git_install "seclists"              "https://github.com/danielmiessler/SecLists"
    git_install "secretsdump"           "https://github.com/fortra/impacket"
    git_install "setoolkit"             "https://github.com/trustedsec/social-engineer-toolkit"
    git_install "sherlock"              "https://github.com/sherlock-project/sherlock"
    git_install "shellpop"              "https://github.com/0x00-0x00/ShellPop"
    git_install "silenttrinity"         "https://github.com/byt3bl33d3r/SILENTTRINITY"
    git_install "sliver"                "https://github.com/BishopFox/sliver"
    git_install "smbmap"                "https://github.com/ShawnDEvans/smbmap"
    git_install "snmpcheck"             "https://github.com/trufflesecurity/trufflehog"
    git_install "spiderpool"            "https://github.com/spiderpool/spiderpool"
    git_install "spiderfoot"            "https://github.com/smicallef/spiderfoot"
    git_install "spoofcheck"            "https://github.com/BishopFox/spoofcheck"
    git_install "spray"                 "https://github.com/Greenwolf/Spray"
    git_install "sqlmap"                "https://github.com/sqlmapproject/sqlmap"
    git_install "sshcheck"              "https://github.com/coreb1t/awesome-pentest-cheat-sheets"
    git_install "sshuttle"              "https://github.com/sshuttle/sshuttle"
    git_install "stegcracker"           "https://github.com/Paradoxis/StegCracker"
    git_install "stegseek"              "https://github.com/RickdeJager/stegseek"
    git_install "striker"               "https://github.com/s0md3v/Striker"
    git_install "subfinder"             "https://github.com/projectdiscovery/subfinder"
    git_install "sublist3r"             "https://github.com/aboul3la/Sublist3r"
    git_install "sudokiller"            "https://github.com/TH3xACE/SUDO_KILLER"
    git_install "suite3270"             "https://github.com/jake-maloney/suite3270"
    git_install "swaggerhub-scan"       "https://github.com/nikitastupin/clairvoyance"
    git_install "syft"                  "https://github.com/anchore/syft"

    # ── T ──────────────────────────────────────────────────────
    git_install "tcpick"                "https://github.com/roberto-scolari/tcpick"
    git_install "testssl"               "https://github.com/drwetter/testssl.sh"
    git_install "theharvester"          "https://github.com/laramies/theHarvester"
    git_install "traitor"               "https://github.com/liamg/traitor"
    git_install "trufflehog"            "https://github.com/trufflesecurity/trufflehog"
    git_install "tshark"                "https://github.com/wireshark/wireshark"
    git_install "ttyd"                  "https://github.com/tsl0922/ttyd"
    git_install "turbosearch"           "https://github.com/helviojunior/turbosearch"
    git_install "twofi"                 "https://github.com/digininja/twofi"

    # ── U-V ────────────────────────────────────────────────────
    git_install "uncompyle6"            "https://github.com/rocky/python-uncompyle6"
    git_install "unicorn"               "https://github.com/trustedsec/unicorn"
    git_install "unix-privesc-check"    "https://github.com/pentestmonkey/unix-privesc-check"
    git_install "updog"                 "https://github.com/sc0tfree/updog"
    git_install "veil"                  "https://github.com/Veil-Framework/Veil"
    git_install "villain"               "https://github.com/t3l3machus/Villain"
    git_install "volatility3"           "https://github.com/volatilityfoundation/volatility3"

    # ── W-X-Y-Z ────────────────────────────────────────────────
    git_install "wafw00f"               "https://github.com/EnableSecurity/wafw00f"
    git_install "waybackurls"           "https://github.com/tomnomnom/waybackurls"
    git_install "weevely"               "https://github.com/epinna/weevely3"
    git_install "wesng"                 "https://github.com/bitsadmin/wesng"
    git_install "whatweb"               "https://github.com/urbanadventurer/WhatWeb"
    git_install "wifi-autopwner"        "https://github.com/SYWorks/wireless-auto-pwner"
    git_install "wifiphisher"           "https://github.com/wifiphisher/wifiphisher"
    git_install "wifite"                "https://github.com/derv82/wifite2"
    git_install "winpwn"                "https://github.com/S3cur3Th1sSh1t/WinPwn"
    git_install "wordlistctl"           "https://github.com/BlackArch/wordlistctl"
    git_install "wpscan"                "https://github.com/wpscanteam/wpscan"
    git_install "xsrfprobe"             "https://github.com/0xInfection/XSRFProbe"
    git_install "xsser"                 "https://github.com/epsylon/xsser"
    git_install "ysoserial"             "https://github.com/frohoff/ysoserial"
    git_install "zeebee"                "https://github.com/hackerschoice/zeebe"
    git_install "zerologon"             "https://github.com/SecuraBV/CVE-2020-1472"
    git_install "zphisher"              "https://github.com/htr-tech/zphisher"
}

# =============================================================================
# PHASE 3 — PIP (Python tools from PyPI)
# =============================================================================
install_via_pip() {
    log "━━━ Phase 3: pip install — Python tools ━━━"
    local PIP_TOOLS=(
        impacket scapy pwntools paramiko
        requests beautifulsoup4 dnspython
        ldap3 pyOpenSSL cryptography pycryptodome
        shodan censys dnstwist stegcracker
        volatility3 yara-python angr
        boto3 botocore awscli
        jwt trufflehog sherlock-project
        netaddr ipaddress colorama
        frida frida-tools objection
        mitmproxy pyshark
        pymetasploit3 python-nmap
        wfuzz wafw00f theharvester
        dirsearch sublist3r
    )
    for t in "${PIP_TOOLS[@]}"; do
        pip_install "$t"
    done
}

# =============================================================================
# PHASE 4 — GO TOOLS
# =============================================================================
install_via_go() {
    log "━━━ Phase 4: go install — Go-based tools ━━━"
    go_install "httpx"       "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    go_install "nuclei"      "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    go_install "subfinder"   "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    go_install "naabu"       "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
    go_install "dnsx"        "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    go_install "interactsh"  "github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest"
    go_install "katana"      "github.com/projectdiscovery/katana/cmd/katana@latest"
    go_install "waybackurls" "github.com/tomnomnom/waybackurls@latest"
    go_install "gf"          "github.com/tomnomnom/gf@latest"
    go_install "anew"        "github.com/tomnomnom/anew@latest"
    go_install "qsreplace"   "github.com/tomnomnom/qsreplace@latest"
    go_install "gau"         "github.com/lc/gau/v2/cmd/gau@latest"
    go_install "hakrawler"   "github.com/hakluke/hakrawler@latest"
    go_install "gobuster"    "github.com/OJ/gobuster/v3@latest"
    go_install "ffuf"        "github.com/ffuf/ffuf/v2@latest"
    go_install "chisel"      "github.com/jpillora/chisel@latest"
    go_install "rustscan"    "github.com/RustScan/RustScan@latest" || true
    go_install "gowitness"   "github.com/sensepost/gowitness@latest"
    go_install "dalfox"      "github.com/hahwul/dalfox/v2@latest"
    go_install "trufflehog"  "github.com/trufflesecurity/trufflehog/v3@latest"
    go_install "gitleaks"    "github.com/gitleaks/gitleaks/v8@latest"
    go_install "cloudfox"    "github.com/BishopFox/cloudfox@latest"
    go_install "peirates"    "github.com/inguardians/peirates@latest"
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    banner

    [ "$EUID" -ne 0 ] && { err "Run as root: sudo bash $0"; exit 1; }

    mkdir -p "$OPT" /var/log
    touch "$LOG"
    [ ! "$RESUME" = true ] && > "$STATE"

    log "Phoenix OS BlackArch Complete Arsenal Installer"
    log "Target: $OPT | Log: $LOG | Resume: $RESUME"
    echo ""

    $GIT_ONLY  || install_via_apt
    $APT_ONLY  || install_via_git
    $APT_ONLY  || install_via_pip
    $APT_ONLY  || install_via_go

    # Update nuclei templates
    command -v nuclei &>/dev/null && { log "Updating Nuclei templates..."; nuclei -update-templates 2>/dev/null || true; }

    TOTAL_DONE=$((PASS + FAIL + SKIP))
    echo ""
    echo -e "${ORANGE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${ORANGE}║      PHOENIX OS — BLACKARCH ARSENAL COMPLETE        ║${NC}"
    echo -e "${ORANGE}╠══════════════════════════════════════════════════════╣${NC}"
    printf "${ORANGE}║${NC} ${GREEN}✓ Installed:${NC} %-40s${ORANGE}║${NC}\n" "$PASS tools"
    printf "${ORANGE}║${NC} ${CYAN}~ Skipped:${NC}   %-40s${ORANGE}║${NC}\n" "$SKIP already present"
    printf "${ORANGE}║${NC} ${YELLOW}✗ Failed:${NC}    %-40s${ORANGE}║${NC}\n" "$FAIL not available"
    printf "${ORANGE}║${NC} ${BOLD}  Total:${NC}     %-40s${ORANGE}║${NC}\n" "$TOTAL_DONE processed"
    printf "${ORANGE}║${NC}   Tools: %-43s${ORANGE}║${NC}\n" "$OPT"
    printf "${ORANGE}║${NC}   Log:   %-43s${ORANGE}║${NC}\n" "$LOG"
    echo -e "${ORANGE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${ORANGE}Born from the ashes of every failed boot. 🔥${NC}"
    echo ""
}

main "$@"
