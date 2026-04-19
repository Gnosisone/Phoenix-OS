#!/usr/bin/env bash
# =============================================================================
# Phoenix OS — Fix Special Case Tools
# Handles PS1, Java JARs, .NET, PHP, NIM, and other non-standard tools
#
# Usage: sudo bash scripts/fix_special_tools.sh
# =============================================================================

set +e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
ORANGE='\033[0;33m'; NC='\033[0m'
OPT="/opt/blackarch"
BIN="/usr/local/bin"
PASS=0; FAIL=0; SKIP=0

ok()   { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)); }
fail() { echo -e "  ${YELLOW}✗${NC} $1 ($2)"; ((FAIL++)); }
skip() { echo -e "  ${CYAN}~${NC} $1"; ((SKIP++)); }

[ "$EUID" -ne 0 ] && { echo "Run as root: sudo bash $0"; exit 1; }

echo -e "${ORANGE}"
echo "  PHOENIX OS — Special Case Tool Fixer"
echo "  Wrapping PS1, Java JARs, PHP, NIM, C# tools"
echo -e "${NC}"

# ── PowerShell wrapper ────────────────────────────────────────────────────────
ps1_wrap() {
    local tool="$1" ps1="$2"
    [ -f "$BIN/$tool" ] && skip "$tool" && return
    cat > "$BIN/$tool" << WRAP
#!/usr/bin/env bash
# Phoenix OS — PowerShell wrapper for $tool
if command -v pwsh &>/dev/null; then
    exec pwsh -ExecutionPolicy Bypass -File "$ps1" "\$@"
elif command -v powershell &>/dev/null; then
    exec powershell -ExecutionPolicy Bypass -File "$ps1" "\$@"
else
    echo "PowerShell not found. Install: sudo apt install -y powershell"
    exit 1
fi
WRAP
    chmod +x "$BIN/$tool" && ok "$tool (ps1)"
}

# ── PHP wrapper ───────────────────────────────────────────────────────────────
php_wrap() {
    local tool="$1" php="$2"
    [ -f "$BIN/$tool" ] && skip "$tool" && return
    cat > "$BIN/$tool" << WRAP
#!/usr/bin/env bash
exec php "$php" "\$@"
WRAP
    chmod +x "$BIN/$tool" && ok "$tool (php)"
}

# ── JAR wrapper ───────────────────────────────────────────────────────────────
jar_wrap() {
    local tool="$1" jar="$2"
    [ -f "$BIN/$tool" ] && skip "$tool" && return
    cat > "$BIN/$tool" << WRAP
#!/usr/bin/env bash
exec java -jar "$jar" "\$@"
WRAP
    chmod +x "$BIN/$tool" && ok "$tool (jar)"
}

# ── EXE wrapper (via wine) ────────────────────────────────────────────────────
exe_wrap() {
    local tool="$1" exe="$2"
    [ -f "$BIN/$tool" ] && skip "$tool" && return
    cat > "$BIN/$tool" << WRAP
#!/usr/bin/env bash
if command -v wine &>/dev/null; then
    exec wine "$exe" "\$@"
else
    echo "Windows tool '$tool' requires wine: sudo apt install -y wine"
    echo "Or run on Windows directly: $exe"
    exit 1
fi
WRAP
    chmod +x "$BIN/$tool" && ok "$tool (wine/exe)"
}

# =============================================================================
# POWERSHELL TOOLS
# =============================================================================
echo -e "${ORANGE}━━━ PowerShell Tools ━━━${NC}"
apt install -y -qq powershell 2>/dev/null | tail -1 || true

for tool_ps1 in \
    "adape-script:$OPT/adape-script/ADAPE.ps1" \
    "invoke-obfuscation:$OPT/invoke-obfuscation/Invoke-Obfuscation.psd1" \
    "invoke-dosfuscation:$OPT/invoke-dosfuscation/Invoke-DOSfuscation.psd1" \
    "invoke-cradlecrafter:$OPT/invoke-cradlecrafter/Invoke-CradleCrafter.psd1" \
    "mrkaplan:$OPT/mrkaplan/MrKaplan.ps1" \
    "persistencesniper:$OPT/persistencesniper/PersistenceSniper.psd1" \
    "powercloud:$OPT/powercloud/PowerCloud.ps1" \
    "powermft:$OPT/powermft/PowerMFT.ps1" \
    "mft2csv:$OPT/mft2csv/MFT2csv.ps1" \
    "cloudunflare:$OPT/cloudunflare/cloudunflare.bash" \
; do
    tool="${tool_ps1%%:*}"
    ps1="${tool_ps1#*:}"
    [ -f "$ps1" ] && ps1_wrap "$tool" "$ps1" || fail "$tool" "ps1 not found"
done

# =============================================================================
# PHP TOOLS
# =============================================================================
echo -e "${ORANGE}━━━ PHP Tools ━━━${NC}"
apt install -y -qq php php-cli 2>/dev/null | tail -1 || true

for tool_php in \
    "red-hawk:$OPT/red-hawk/rhawk.php" \
    "xpl-search:$OPT/xpl-search/xpl-search.php" \
    "phpstress:$OPT/phpstress/phpstress.php" \
    "jsonbee:$OPT/jsonbee/jsonbee.php" \
; do
    tool="${tool_php%%:*}"
    php="${tool_php#*:}"
    [ -f "$php" ] && php_wrap "$tool" "$php" || fail "$tool" "php not found"
done

# =============================================================================
# JAVA JAR TOOLS (pre-compiled)
# =============================================================================
echo -e "${ORANGE}━━━ Java JAR Tools ━━━${NC}"

for tool in bluepot bluphish barmie snuck jdeserialize jwscan vscan; do
    dir="$OPT/$tool"
    jar=$(find "$dir" -name "*.jar" 2>/dev/null | grep -v test | head -1)
    [ -n "$jar" ] && jar_wrap "$tool" "$jar" || fail "$tool" "no jar"
done

# =============================================================================
# WINDOWS TOOLS via WINE (ghostpack, juicy-potato, etc.)
# =============================================================================
echo -e "${ORANGE}━━━ Windows Tools (wine wrappers) ━━━${NC}"
apt install -y -qq wine64 2>/dev/null | tail -1 || true

for tool_exe in \
    "ghostpack:$OPT/ghostpack" \
    "juicy-potato:$OPT/juicy-potato" \
    "extractusnjrnl:$OPT/extractusnjrnl" \
    "indx2csv:$OPT/indx2csv" \
    "mftcarver:$OPT/mftcarver" \
    "ntfs-file-extractor:$OPT/ntfs-file-extractor" \
; do
    tool="${tool_exe%%:*}"
    dir="${tool_exe#*:}"
    exe=$(find "$dir" -name "*.exe" 2>/dev/null | head -1)
    [ -n "$exe" ] && exe_wrap "$tool" "$exe" || fail "$tool" "no exe"
done

# =============================================================================
# DOTNET TOOLS (via mono or dotnet runtime)
# =============================================================================
echo -e "${ORANGE}━━━ .NET Tools ━━━${NC}"
apt install -y -qq mono-complete 2>/dev/null | tail -1 || true

dotnet_wrap() {
    local tool="$1" dll_or_exe="$2"
    [ -f "$BIN/$tool" ] && skip "$tool" && return
    cat > "$BIN/$tool" << WRAP
#!/usr/bin/env bash
if command -v dotnet &>/dev/null; then
    exec dotnet "$dll_or_exe" "\$@"
elif command -v mono &>/dev/null; then
    exec mono "$dll_or_exe" "\$@"
else
    echo "Requires dotnet or mono: sudo apt install -y mono-complete"
    exit 1
fi
WRAP
    chmod +x "$BIN/$tool" && ok "$tool (.net)"
}

for tool in de4dot de4dotex powershdll shed upnp-pentest-toolkit; do
    dir="$OPT/$tool"
    dll=$(find "$dir" -name "*.exe" -o -name "*.dll" 2>/dev/null | grep -iv test | head -1)
    [ -n "$dll" ] && dotnet_wrap "$tool" "$dll" || fail "$tool" "no dll/exe"
done

# =============================================================================
# NIM TOOLS
# =============================================================================
echo -e "${ORANGE}━━━ Nim Tools ━━━${NC}"
apt install -y -qq nim 2>/dev/null | tail -1 || true

nim_build() {
    local tool="$1" dir="$OPT/$tool"
    nimfile=$(find "$dir" -name "*.nim" -not -name "*test*" | head -1)
    [ -z "$nimfile" ] && fail "$tool" "no .nim" && return
    if nim compile --out:"$BIN/$tool" "$nimfile" 2>/dev/null; then
        ok "$tool (nim)"
    else
        fail "$tool" "nim compile failed"
    fi
}

nim_build "hashpeek"

# =============================================================================
# TOOLS THAT ARE REFERENCE/DATA ONLY — create info wrappers
# =============================================================================
echo -e "${ORANGE}━━━ Reference/Data Tools ━━━${NC}"

info_wrap() {
    local tool="$1" desc="$2" dir="$3"
    [ -f "$BIN/$tool" ] && skip "$tool" && return
    cat > "$BIN/$tool" << WRAP
#!/usr/bin/env bash
echo "=== Phoenix OS: $tool ==="
echo "$desc"
echo "Location: $dir"
echo ""
ls "$dir" 2>/dev/null | head -20
WRAP
    chmod +x "$BIN/$tool" && ok "$tool (info)"
}

info_wrap "lolbas"      "Living Off the Land Binaries and Scripts — reference database" "$OPT/lolbas"
info_wrap "sagan-rules" "Sagan IDS rule collection" "$OPT/sagan-rules"
info_wrap "country-ip-blocks" "Country IP block lists" "$OPT/country-ip-blocks"
info_wrap "powersploit" "PowerSploit PowerShell post-exploitation framework (use with pwsh)" "$OPT/powersploit"
info_wrap "ghostpack"   "GhostPack compiled .NET tools (Rubeus, Seatbelt, SharpUp)" "$OPT/ghostpack"
info_wrap "invoke-obfuscation" "PowerShell obfuscation framework" "$OPT/invoke-obfuscation"

# =============================================================================
# RE-RUN INTEGRATION
# =============================================================================
echo ""
echo -e "${CYAN}[+]${NC} Re-running integration for newly fixed tools..."
bash /home/kali/Phoenix-OS/scripts/integrate_tools.sh 2>/dev/null | grep -E "✓|✗|Integrated|Skipped"

TOTAL=$((PASS+FAIL+SKIP))
echo ""
echo -e "${ORANGE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${ORANGE}║   PHOENIX OS — SPECIAL CASE FIX COMPLETE           ║${NC}"
echo -e "${ORANGE}╠══════════════════════════════════════════════════════╣${NC}"
printf "${ORANGE}║${NC} ${GREEN}✓ Fixed:   %-41s${ORANGE}║${NC}\n" "$PASS tools"
printf "${ORANGE}║${NC} ${CYAN}~ Skipped: %-41s${ORANGE}║${NC}\n" "$SKIP already done"
printf "${ORANGE}║${NC} ${YELLOW}✗ Failed:  %-41s${ORANGE}║${NC}\n" "$FAIL tools"
echo -e "${ORANGE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${ORANGE}Born from the ashes of every failed boot. 🔥${NC}"
