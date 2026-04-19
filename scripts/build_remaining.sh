#!/usr/bin/env bash
# =============================================================================
# Phoenix OS — Build & Integrate Remaining Tools
# Compiles Go, C, Rust, npm, Java tools then integrates them
#
# Usage: sudo bash scripts/build_remaining.sh [--resume]
# =============================================================================

set +e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
ORANGE='\033[0;33m'; NC='\033[0m'
OPT="/opt/blackarch"
BIN="/usr/local/bin"
STATE="/var/log/phoenix-build-state.txt"
LOG="/var/log/phoenix-build.log"
PASS=0; FAIL=0; SKIP=0

RESUME=false; [[ "$1" == "--resume" ]] && RESUME=true

ok()     { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)); echo "PASS:$1" >> "$STATE"; }
fail()   { echo -e "  ${YELLOW}✗${NC} $1 ($2)"; ((FAIL++)); }
skip()   { echo -e "  ${CYAN}~${NC} $1 (done)"; ((SKIP++)); }
section(){ echo -e "\n${ORANGE}━━━ $1 ━━━${NC}"; }
done_already() { $RESUME && grep -q "^PASS:$1$" "$STATE" 2>/dev/null; }

make_wrapper() {
    local tool="$1" binary="$2"
    [ -f "$BIN/$tool" ] && return
    ln -sf "$binary" "$BIN/$tool" 2>/dev/null \
        || cp "$binary" "$BIN/$tool" 2>/dev/null
    chmod +x "$BIN/$tool" 2>/dev/null
}

[ "$EUID" -ne 0 ] && { echo "Run as root: sudo bash $0"; exit 1; }
[[ "$RESUME" != "true" ]] && > "$STATE"
touch "$LOG"

echo -e "${ORANGE}"
echo "  PHOENIX OS — Build Engine"
echo "  Compiling 269 tools from source: Go + C + Rust + npm + Java"
echo -e "${NC}"

# =============================================================================
# INSTALL BUILD DEPENDENCIES FIRST
# =============================================================================
section "Installing Build Dependencies"
echo "[+] Installing compilers and build tools..."
DEBIAN_FRONTEND=noninteractive apt install -y -qq \
    golang-go cargo rustc \
    build-essential cmake make gcc g++ \
    default-jdk maven gradle \
    nodejs npm \
    libssl-dev libffi-dev libpcap-dev \
    libnetfilter-queue-dev libmnl-dev \
    libcurl4-openssl-dev zlib1g-dev \
    mingw-w64 2>/dev/null | tail -1
echo "  Build deps ready"

# =============================================================================
# GO BUILD TOOLS (118 tools)
# =============================================================================
section "Building Go Tools (118)"

go_build() {
    local tool="$1" dir="$OPT/$tool"
    done_already "go:$tool" && skip "$tool" && return
    [ ! -d "$dir" ] && fail "$tool" "no dir" && return

    cd "$dir"

    # Try go install if go.mod exists with module path
    if [ -f "go.mod" ]; then
        mod=$(head -1 go.mod | awk '{print $2}')
        if GOPATH=/usr/local GOBIN="$BIN" go build -o "$BIN/$tool" ./... 2>/dev/null; then
            ok "go:$tool"
            return
        fi
        # Try main package
        if GOPATH=/usr/local GOBIN="$BIN" go build -o "$BIN/$tool" . 2>/dev/null; then
            ok "go:$tool"
            return
        fi
    fi

    # Find main.go and build it
    main_go=$(find "$dir" -name "main.go" -not -path "*vendor*" | head -1)
    if [ -n "$main_go" ]; then
        main_dir=$(dirname "$main_go")
        cd "$main_dir"
        if go build -o "$BIN/$tool" . 2>/dev/null; then
            ok "go:$tool (main.go)"
            return
        fi
    fi

    fail "$tool" "go build failed"
}

for tool in \
    adfind asnmap assetfinder azurehound bloodhound-cli cariddi \
    cdpsnarf cent chaos-client cloudfox codeql-go coercer \
    crlfuzz dnsgen dnsx duplicut egressbuster \
    fbcrawl fping-go gau getallurls gitgot \
    goaltdns gobuster goddi godnsbuster goDoH \
    gofingerprint gohttp gonmap gookies goop \
    gorailsbrute gores goronin goshs goterrasec \
    gowitness grpc-proxy gwp-asm hakip2host \
    hakrawler httprobe hurl httpx \
    interactsh-client interactsh-server \
    ipinfo irix-scanner iscore \
    katana kiterunner knary \
    ldeep-go ldapmonitor ldapnomnom \
    mapcidr massdns metabigor \
    naabu netexec-go netscan nmap-go \
    nuclei oauthscan oshintgram \
    puredns rada randsubdomain \
    rawhttp reconftw rekall \
    roboxtractor s3brute s3enum \
    shuffledns sigurls simplerecon \
    smap snmpbrute socialhunter \
    sourcemapper spiderfoot-go \
    sqlmap-go ssti-payload subfinder \
    surf syft tldfuzz tokensurgeon \
    trickest-cli trufflehog uglyflip \
    unfurl urldedupe urlhunter \
    vhostscan waybackrobots \
    websockify-go x8 xcname \
    xray xtc yeti-go zdns \
    zgrab zgrab2 zirikatu \
; do
    go_build "$tool"
done

# =============================================================================
# C / MAKE BUILD TOOLS (89 tools)
# =============================================================================
section "Building C/Make Tools (89)"

c_build() {
    local tool="$1" dir="$OPT/$tool"
    done_already "c:$tool" && skip "$tool" && return
    [ ! -d "$dir" ] && fail "$tool" "no dir" && return

    cd "$dir"

    # autoreconf if needed
    if [ -f "configure.ac" ] && [ ! -f "configure" ]; then
        autoreconf -fi 2>/dev/null || true
    fi

    # ./configure + make
    if [ -f "configure" ]; then
        ./configure --prefix=/usr/local 2>/dev/null
        if make -j$(nproc) 2>/dev/null && make install 2>/dev/null; then
            ok "c:$tool (configure+make)"
            return
        fi
    fi

    # cmake
    if [ -f "CMakeLists.txt" ]; then
        mkdir -p build && cd build
        if cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null \
            && make -j$(nproc) 2>/dev/null \
            && make install 2>/dev/null; then
            ok "c:$tool (cmake)"
            return
        fi
        cd "$dir"
    fi

    # plain make
    if [ -f "Makefile" ] || [ -f "makefile" ]; then
        if make -j$(nproc) 2>/dev/null; then
            # Find and link the output binary
            binary=$(find "$dir" -maxdepth 3 -type f -executable -name "$tool" | head -1)
            [ -z "$binary" ] && binary=$(find "$dir" -maxdepth 3 -type f -executable ! -name "*.sh" ! -name "*.py" | head -1)
            if [ -n "$binary" ]; then
                make_wrapper "$tool" "$binary"
                ok "c:$tool (make)"
                return
            fi
        fi
    fi

    fail "$tool" "build failed"
}

for tool in \
    agafi beleth blacknurse bonesi braa \
    bettercap-build cdpsnarf chameleon \
    checkpwnd chntpw cisco-ocs \
    cmospwd copy-router-config \
    creddump cymothoa darkstat \
    davtest dhcig dhcpig dnsmap \
    dnsrecon-c dnstracer \
    ds-walk dsniff-build \
    eapspray ebeowulf exploit-db-bin \
    firewalk frag6 ftpmap \
    genkeys gitminer goldeneye \
    halberd hping3-build htshells \
    httptunnel hwk i2pbrowser \
    ikeforce inundator iodine-build \
    ipwn ismtp jboss-autopwn \
    jbrute joomlascan kalibrate-rtl-build \
    killerbee l2tp-ipsec-vpn \
    lft lynis-build mdbtools-build \
    merkaat minimodem mitmAP \
    morxcrack mptcp-abuse \
    ncrack-build netcommander netgear-telnetable \
    netmap networkminer-build \
    nield nipper-ng nishang-build \
    nmap-build nping nsenumerate \
    obexstress oclhashcat-build \
    omnibus onetwopunch openvas-build \
    pdfcrack pdfinfo peepdf \
    pexec pinchme platformio \
    proxychains-build pwdump7 \
    pyrit rcrack rdp-sec-check \
    reaver-build rfcat \
    rop-tool rpcscan rsmangler-build \
    rtpbreak rtpflood rtpinsertsound \
    rtpmixsound samdump2-build \
    sasr scanner-caini scantastic \
    scotty sendemail sessionstorage \
    sfuzz siege sidguesser \
    siparmyknife sipsak smap-build \
    smtp-user-enum smtpmap sniffjoke \
    spike spooftooph squashfs-tools \
    strace-build stunnel sucrack \
    synscan t50 tcpjunk \
    thc-ssl-dos truecrack uatester \
    ufonet unhide voiphopper \
    wapiti-build wifijammer wifitap \
    wol-e wyd xplico-build \
    xrop yaf zaproxy-build zizzania \
; do
    c_build "$tool"
done

# =============================================================================
# RUST BUILD TOOLS (21 tools)
# =============================================================================
section "Building Rust Tools (21)"

rust_build() {
    local tool="$1" dir="$OPT/$tool"
    done_already "rust:$tool" && skip "$tool" && return
    [ ! -d "$dir" ] && fail "$tool" "no dir" && return

    cd "$dir"
    if cargo build --release 2>/dev/null; then
        binary=$(find "$dir/target/release" -maxdepth 1 -type f -executable | head -1)
        if [ -n "$binary" ]; then
            cp "$binary" "$BIN/$tool" 2>/dev/null
            chmod +x "$BIN/$tool"
            ok "rust:$tool"
        else
            fail "$tool" "no binary in target/release"
        fi
    else
        fail "$tool" "cargo build failed"
    fi
}

for tool in \
    ares chainsaw dirble \
    feroxbuster-build fingerprintx \
    httpx-rs jwt-hack ligolo-rs \
    noseyparker nuclei-rs \
    pwncat-rs ransack ripgrep-sec \
    rnr robber rustrecon \
    rustscan-build snare sniffnet \
    tunelo x0rro \
; do
    rust_build "$tool"
done

# =============================================================================
# NPM BUILD TOOLS (13 tools)
# =============================================================================
section "Building npm/Node Tools (13)"

npm_build() {
    local tool="$1" dir="$OPT/$tool"
    done_already "npm:$tool" && skip "$tool" && return
    [ ! -d "$dir" ] && fail "$tool" "no dir" && return

    cd "$dir"

    # Install dependencies
    npm install --silent 2>/dev/null || yarn install --silent 2>/dev/null || true

    # Try npm link to make globally available
    npm link 2>/dev/null || true

    # Find main entry
    main=$(node -e "try{console.log(require('./package.json').bin||require('./package.json').main||'')}catch(e){}" 2>/dev/null | head -1)

    if [ -f "$BIN/$tool" ] || [ -f "/usr/local/bin/$tool" ]; then
        ok "npm:$tool (linked)"
        return
    fi

    # Manual wrapper
    if [ -n "$main" ] && [ -f "$dir/$main" ]; then
        cat > "$BIN/$tool" << WRAP
#!/usr/bin/env node
require('$dir/$main');
WRAP
        chmod +x "$BIN/$tool"
        ok "npm:$tool (node wrapper)"
        return
    fi

    fail "$tool" "npm build failed"
}

for tool in \
    bagbak brosec cloudsploit \
    expose jsfuck \
    node-dirbuster netsparker-community \
    pentest-tools retire-js \
    secretfinder ssl-checker \
    wssip ysoserial-js \
; do
    npm_build "$tool"
done

# =============================================================================
# JAVA BUILD TOOLS (14 tools)
# =============================================================================
section "Building Java Tools (14)"

java_build() {
    local tool="$1" dir="$OPT/$tool"
    done_already "java:$tool" && skip "$tool" && return
    [ ! -d "$dir" ] && fail "$tool" "no dir" && return

    cd "$dir"
    built=false

    # Maven
    if [ -f "pom.xml" ]; then
        mvn package -q -DskipTests 2>/dev/null && built=true
    fi

    # Gradle
    if [ -f "build.gradle" ] || [ -f "gradlew" ]; then
        [ -f "gradlew" ] && chmod +x gradlew
        ./gradlew build -q 2>/dev/null || gradle build -q 2>/dev/null
        built=true
    fi

    # Find the jar
    jar=$(find "$dir" -name "*.jar" -not -path "*/test*" 2>/dev/null | head -1)

    if [ -n "$jar" ]; then
        cat > "$BIN/$tool" << WRAP
#!/usr/bin/env bash
exec java -jar "$jar" "\$@"
WRAP
        chmod +x "$BIN/$tool"
        ok "java:$tool"
    else
        fail "$tool" "no jar found"
    fi
}

for tool in \
    ajpfuzzer dexpatcher \
    gadgetinspector jd-cli jd-gui \
    jsql-injection log4shell-tools \
    nessus-report-downloader \
    owasp-threat-dragon \
    peass-ng-jar retire-java \
    ysoserial zeek-java \
; do
    java_build "$tool"
done

# =============================================================================
# BINARY-ONLY TOOLS (12 tools — already have executable, just need linking)
# =============================================================================
section "Linking Binary-Only Tools (12)"

for tool in \
    bqm cminer fernflower gadgettojscript \
    goofuzz hollows-hunter \
    impacket-bin invoke-atomicredteam \
    ligolo-proxy peass-bin \
    rubeus-precompiled secretsdump-bin \
; do
    done_already "bin:$tool" && skip "$tool" && continue
    dir="$OPT/$tool"
    [ ! -d "$dir" ] && continue
    binary=$(find "$dir" -maxdepth 3 -type f -executable ! -name "*.sh" ! -name "*.py" | head -1)
    if [ -n "$binary" ]; then
        make_wrapper "$tool" "$binary"
        ok "bin:$tool"
    else
        fail "$tool" "no executable"
    fi
done

# =============================================================================
# RE-RUN INTEGRATION for newly built tools
# =============================================================================
section "Re-running integration for newly built tools"
bash /home/kali/Phoenix-OS/scripts/integrate_tools.sh 2>/dev/null | tail -10

# Summary
TOTAL=$((PASS+FAIL+SKIP))
echo ""
echo -e "${ORANGE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${ORANGE}║     PHOENIX OS — BUILD ENGINE COMPLETE             ║${NC}"
echo -e "${ORANGE}╠══════════════════════════════════════════════════════╣${NC}"
printf "${ORANGE}║${NC} ${GREEN}✓ Built+linked: %-36s${ORANGE}║${NC}\n" "$PASS tools"
printf "${ORANGE}║${NC} ${CYAN}~ Skipped:      %-36s${ORANGE}║${NC}\n" "$SKIP already built"
printf "${ORANGE}║${NC} ${YELLOW}✗ Failed:       %-36s${ORANGE}║${NC}\n" "$FAIL tools"
printf "${ORANGE}║${NC}   Total:        %-36s${ORANGE}║${NC}\n" "$TOTAL processed"
echo -e "${ORANGE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${ORANGE}Born from the ashes of every failed boot. 🔥${NC}"
