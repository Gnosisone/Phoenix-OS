#!/usr/bin/env bash
# =============================================================================
# Phoenix OS — BlackArch Tool Integration
# Makes all cloned tools accessible system-wide:
#   1. Creates wrapper scripts in /usr/local/bin/ for every tool
#   2. Generates Kali app menu entries (.desktop files)
#   3. Updates man page database
#   4. Builds a searchable tool index
#
# Usage: sudo bash scripts/integrate_tools.sh
# =============================================================================

set +e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
ORANGE='\033[0;33m'; NC='\033[0m'
OPT="/opt/blackarch"
BIN="/usr/local/bin"
DESKTOP="/usr/share/applications"
PASS=0; FAIL=0; SKIP=0

ok()   { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)); }
warn() { echo -e "  ${YELLOW}~${NC} $1"; ((SKIP++)); }
err()  { echo -e "  ${YELLOW}✗${NC} $1"; ((FAIL++)); }

# Detect interpreter for a file
detect_interp() {
    local f="$1"
    local shebang
    shebang=$(head -1 "$f" 2>/dev/null)
    case "$shebang" in
        *python3*|*python*) echo "python3" ;;
        *ruby*)             echo "ruby" ;;
        *perl*)             echo "perl" ;;
        *node*)             echo "node" ;;
        *bash*|*sh*)        echo "bash" ;;
        *)
            case "$f" in
                *.py) echo "python3" ;;
                *.rb) echo "ruby" ;;
                *.pl) echo "perl" ;;
                *.js) echo "node" ;;
                *.sh) echo "bash" ;;
                *)    echo "" ;;
            esac ;;
    esac
}

# Find best entry point for a tool
find_entry() {
    local tool="$1" dir="$2"
    local tlow="${tool,,}"
    tlow="${tlow//-/}"; tlow="${tlow//_/}"

    # Check explicit candidates first
    for f in \
        "$dir/$tool" "$dir/$tool.py" "$dir/$tool.sh" "$dir/$tool.rb" \
        "$dir/main.py" "$dir/main.sh" "$dir/run.py" "$dir/run.sh" \
        "$dir/${tool}.pl" "$dir/start.py"; do
        [ -f "$f" ] && echo "$f" && return
    done

    # Deep scan with scoring
    local best_score=0 best_file=""
    while IFS= read -r -d '' f; do
        local fname="${f##*/}"
        local fbase="${fname%.*}"
        local fclean="${fbase//-/}"; fclean="${fclean//_/}"; fclean="${fclean,,}"
        local score=0

        [[ "$fclean" == "$tlow" ]] && score=100
        [[ "$fclean" == "${tlow}py" || "$fclean" == "${tlow}sh" ]] && score=90
        [[ "$fname" == "main.py" || "$fname" == "main.sh" ]] && score=50
        [[ "$fname" == "run.py"  || "$fname" == "run.sh"  ]] && score=40
        [[ "$fclean" == *"$tlow"* && $score -eq 0 ]] && score=30

        case "$fname" in
            *.py) ((score+=10)) ;;
            *.sh) ((score+=8))  ;;
            *.rb) ((score+=7))  ;;
            *.pl) ((score+=5))  ;;
        esac

        [ $score -gt $best_score ] && best_score=$score && best_file="$f"
    done < <(find "$dir" -maxdepth 3 \
        -not -path "*/.git/*" \
        -not -path "*/node_modules/*" \
        -not -path "*/__pycache__/*" \
        -not -path "*/venv/*" \
        -not -path "*/vendor/*" \
        \( -name "*.py" -o -name "*.sh" -o -name "*.rb" -o -name "*.pl" \) \
        -print0 2>/dev/null)

    [ -n "$best_file" ] && echo "$best_file"
}

# Create wrapper script in /usr/local/bin
make_wrapper() {
    local tool="$1" entry="$2" dir="$3"
    local wrapper="$BIN/$tool"
    local interp
    interp=$(detect_interp "$entry")

    [ -f "$wrapper" ] && warn "$tool (already in PATH)" && return

    if [ -z "$interp" ]; then
        # Try to make it directly executable
        chmod +x "$entry" 2>/dev/null
        ln -sf "$entry" "$wrapper" 2>/dev/null && ok "$tool (symlink)" && return
        err "$tool (no interpreter detected)"
        return
    fi

    # Write wrapper script
    cat > "$wrapper" << WRAP
#!/usr/bin/env bash
# Phoenix OS wrapper — $tool
# Source: $entry
cd "$dir" && exec $interp "$entry" "\$@"
WRAP
    chmod +x "$wrapper"
    ok "$tool ($interp wrapper)"
}

# Create .desktop file for Kali menu
make_desktop() {
    local tool="$1" dir="$2" category="$3"
    local desktop_file="$DESKTOP/phoenix-$tool.desktop"

    # Pick icon based on category
    local icon="security-high"
    case "$category" in
        recon)   icon="network-scanner" ;;
        web)     icon="web-browser" ;;
        wireless) icon="network-wireless" ;;
        exploit) icon="bug-buddy" ;;
        password) icon="dialog-password" ;;
        forensic) icon="search" ;;
    esac

    cat > "$desktop_file" << DESK
[Desktop Entry]
Name=$tool
Comment=Phoenix OS — BlackArch Arsenal
Exec=bash -c "$BIN/$tool; read -p 'Press Enter to close...'"
Terminal=true
Type=Application
Icon=$icon
Categories=Kali;Security;$category;
Keywords=$tool;blackarch;pentest;phoenix;
DESK
}

# Detect tool category from name/path
detect_category() {
    local tool="$1"
    case "$tool" in
        *nmap*|*scan*|*recon*|*enum*|*osint*|*harvest*|*spider*|*amass*|*sub*) echo "recon" ;;
        *sql*|*xss*|*web*|*fuzz*|*burp*|*wfuzz*|*nikto*|*cms*|*wp*) echo "web" ;;
        *wifi*|*air*|*wpa*|*wireless*|*kismet*|*blue*|*ble*) echo "wireless" ;;
        *exploit*|*msf*|*payload*|*shell*|*metasploit*|*sliver*|*havoc*) echo "exploit" ;;
        *hash*|*crack*|*hydra*|*john*|*brute*|*pass*|*word*) echo "password" ;;
        *forensic*|*volatil*|*autopsy*|*memory*|*artifact*) echo "forensic" ;;
        *ad*|*ldap*|*kerberos*|*smb*|*blood*) echo "activedirectory" ;;
        *cloud*|*aws*|*azure*|*k8s*|*docker*) echo "cloud" ;;
        *) echo "misc" ;;
    esac
}

# =============================================================================
# MAIN
# =============================================================================
echo -e "${ORANGE}"
echo "  PHOENIX OS — Tool Integration Engine"
echo "  Making $(ls $OPT | wc -l) BlackArch tools accessible system-wide"
echo -e "${NC}"

[ "$EUID" -ne 0 ] && { echo "Run as root: sudo bash $0"; exit 1; }

mkdir -p "$DESKTOP"
INDEX="/opt/blackarch/.tool-index"
echo "# Phoenix OS BlackArch Tool Index — $(date)" > "$INDEX"
echo "# Format: tool_name|entry_point|interpreter|category|wrapper_path" >> "$INDEX"

for tool_dir in "$OPT"/*/; do
    tool="${tool_dir%/}"
    tool="${tool##*/}"

    # Skip hidden dirs
    [[ "$tool" == .* ]] && continue

    entry=$(find_entry "$tool" "$tool_dir")

    if [ -z "$entry" ]; then
        err "$tool (no entry point found)"
        echo "$tool|none|none|misc|none" >> "$INDEX"
        continue
    fi

    interp=$(detect_interp "$entry")
    category=$(detect_category "$tool")

    # Create wrapper
    make_wrapper "$tool" "$entry" "$tool_dir"

    # Create desktop entry
    make_desktop "$tool" "$tool_dir" "$category"

    # Add to index
    wrapper="$BIN/$tool"
    echo "$tool|$entry|$interp|$category|$wrapper" >> "$INDEX"
done

# Update system databases
echo ""
echo -e "${CYAN}[+]${NC} Updating Kali application menu..."
update-desktop-database "$DESKTOP" 2>/dev/null || true
gtk-update-icon-cache /usr/share/icons/hicolor/ 2>/dev/null || true

echo -e "${CYAN}[+]${NC} Rebuilding man page index..."
mandb -q 2>/dev/null || true

echo -e "${CYAN}[+]${NC} Tool index written to $INDEX"

# Summary
TOTAL=$((PASS+FAIL+SKIP))
echo ""
echo -e "${ORANGE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${ORANGE}║     PHOENIX OS — TOOL INTEGRATION COMPLETE         ║${NC}"
echo -e "${ORANGE}╠══════════════════════════════════════════════════════╣${NC}"
printf "${ORANGE}║${NC} ${GREEN}✓ Integrated: %-38s${ORANGE}║${NC}\n" "$PASS tools in PATH + menu"
printf "${ORANGE}║${NC} ${CYAN}~ Skipped:    %-38s${ORANGE}║${NC}\n" "$SKIP already accessible"
printf "${ORANGE}║${NC} ${YELLOW}✗ No entry:   %-38s${ORANGE}║${NC}\n" "$FAIL tools (binary/C build needed)"
printf "${ORANGE}║${NC}   Index:      %-38s${ORANGE}║${NC}\n" "$INDEX"
echo -e "${ORANGE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Access any tool: ${CYAN}toolname --help${NC}"
echo -e "  Search tools:    ${CYAN}grep 'recon' $INDEX | cut -d'|' -f1${NC}"
echo -e "  Kali menu:       ${CYAN}Restart panel or logout/login${NC}"
echo ""
echo -e "  ${ORANGE}Born from the ashes of every failed boot. 🔥${NC}"
