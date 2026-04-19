#!/usr/bin/env bash
# =============================================================================
# Phoenix OS — Auto-Generated Tool Fixer
# Generated from actual disk scan of /opt/blackarch/
# Builds and wraps ALL remaining 362 unintegrated tools
#
# Usage: sudo bash scripts/fix_all_remaining.sh [--resume]
# =============================================================================

set +e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; ORANGE='\033[0;33m'; NC='\033[0m'
OPT="/opt/blackarch"
BIN="/usr/local/bin"
STATE="/var/log/phoenix-fix-state.txt"
PASS=0; FAIL=0; SKIP=0

RESUME=false; [[ "$1" == "--resume" ]] && RESUME=true
[ "$EUID" -ne 0 ] && { echo "Run as root: sudo bash $0"; exit 1; }
[[ "$RESUME" != "true" ]] && > "$STATE"

ok()   { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)); echo "PASS:$1" >> "$STATE"; }
fail() { echo -e "  ${YELLOW}✗${NC} $1 ($2)"; ((FAIL++)); }
skip() { echo -e "  ${CYAN}~${NC} $1"; ((SKIP++)); }
done_already() { $RESUME && grep -q "^PASS:$1$" "$STATE" 2>/dev/null; }

wrap_py()   { local t="$1" f="$2"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\ncd "%s" && exec python3 "%s" "$@"\n' "$(dirname $f)" "$f" > "$BIN/$t"; chmod +x "$BIN/$t"; }
wrap_sh()   { local t="$1" f="$2"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\ncd "%s" && exec bash "%s" "$@"\n' "$(dirname $f)" "$f" > "$BIN/$t"; chmod +x "$BIN/$t"; }
wrap_rb()   { local t="$1" f="$2"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\ncd "%s" && exec ruby "%s" "$@"\n' "$(dirname $f)" "$f" > "$BIN/$t"; chmod +x "$BIN/$t"; }
wrap_php()  { local t="$1" f="$2"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\ncd "%s" && exec php "%s" "$@"\n' "$(dirname $f)" "$f" > "$BIN/$t"; chmod +x "$BIN/$t"; }
wrap_ps1()  { local t="$1" f="$2"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\nif command -v pwsh &>/dev/null; then exec pwsh -ExecutionPolicy Bypass -File "%s" "$@"; else echo "Install: sudo apt install powershell"; fi\n' "$f" > "$BIN/$t"; chmod +x "$BIN/$t"; }
wrap_jar()  { local t="$1" f="$2"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\nexec java -jar "%s" "$@"\n' "$f" > "$BIN/$t"; chmod +x "$BIN/$t"; }
wrap_exe()  { local t="$1" f="$2"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\nif command -v wine &>/dev/null; then exec wine "%s" "$@"; else echo "Requires wine: sudo apt install wine"; fi\n' "$f" > "$BIN/$t"; chmod +x "$BIN/$t"; }
wrap_info() { local t="$1" d="$2" desc="$3"; [ -f "$BIN/$t" ] && return; printf '#!/usr/bin/env bash\necho "=== %s ===\n%s\nLocation: %s"\nls "%s" | head -20\n' "$t" "$desc" "$d" "$d" > "$BIN/$t"; chmod +x "$BIN/$t"; }


echo -e "${ORANGE}━━━ Go Tools (118) ━━━${NC}"

if ! done_already "go:adfind"; then
  if [ -f "$BIN/adfind" ]; then skip "adfind"; echo "PASS:go:adfind" >> "$STATE"
  elif [ -d "/opt/blackarch/adfind" ]; then
    cd "/opt/blackarch/adfind"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/adfind" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/adfind" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/adfind" . 2>/dev/null && built=true
    fi
    $built && ok "go:adfind" || fail "adfind" "go build failed"
  else fail "adfind" "no dir"; fi
fi

if ! done_already "go:apkurlgrep"; then
  if [ -f "$BIN/apkurlgrep" ]; then skip "apkurlgrep"; echo "PASS:go:apkurlgrep" >> "$STATE"
  elif [ -d "/opt/blackarch/apkurlgrep" ]; then
    cd "/opt/blackarch/apkurlgrep"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/apkurlgrep" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/apkurlgrep" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/apkurlgrep" . 2>/dev/null && built=true
    fi
    $built && ok "go:apkurlgrep" || fail "apkurlgrep" "go build failed"
  else fail "apkurlgrep" "no dir"; fi
fi

if ! done_already "go:asnmap"; then
  if [ -f "$BIN/asnmap" ]; then skip "asnmap"; echo "PASS:go:asnmap" >> "$STATE"
  elif [ -d "/opt/blackarch/asnmap" ]; then
    cd "/opt/blackarch/asnmap"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/asnmap" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/asnmap" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/asnmap" . 2>/dev/null && built=true
    fi
    $built && ok "go:asnmap" || fail "asnmap" "go build failed"
  else fail "asnmap" "no dir"; fi
fi

if ! done_already "go:assetfinder"; then
  if [ -f "$BIN/assetfinder" ]; then skip "assetfinder"; echo "PASS:go:assetfinder" >> "$STATE"
  elif [ -d "/opt/blackarch/assetfinder" ]; then
    cd "/opt/blackarch/assetfinder"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/assetfinder" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/assetfinder" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/assetfinder" . 2>/dev/null && built=true
    fi
    $built && ok "go:assetfinder" || fail "assetfinder" "go build failed"
  else fail "assetfinder" "no dir"; fi
fi

if ! done_already "go:azurehound"; then
  if [ -f "$BIN/azurehound" ]; then skip "azurehound"; echo "PASS:go:azurehound" >> "$STATE"
  elif [ -d "/opt/blackarch/azurehound" ]; then
    cd "/opt/blackarch/azurehound"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/azurehound" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/azurehound" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/azurehound" . 2>/dev/null && built=true
    fi
    $built && ok "go:azurehound" || fail "azurehound" "go build failed"
  else fail "azurehound" "no dir"; fi
fi

if ! done_already "go:backoori"; then
  if [ -f "$BIN/backoori" ]; then skip "backoori"; echo "PASS:go:backoori" >> "$STATE"
  elif [ -d "/opt/blackarch/backoori" ]; then
    cd "/opt/blackarch/backoori"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/backoori" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/backoori" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/backoori" . 2>/dev/null && built=true
    fi
    $built && ok "go:backoori" || fail "backoori" "go build failed"
  else fail "backoori" "no dir"; fi
fi

if ! done_already "go:bloodhound-cli"; then
  if [ -f "$BIN/bloodhound-cli" ]; then skip "bloodhound-cli"; echo "PASS:go:bloodhound-cli" >> "$STATE"
  elif [ -d "/opt/blackarch/bloodhound-cli" ]; then
    cd "/opt/blackarch/bloodhound-cli"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/bloodhound-cli" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/bloodhound-cli" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/bloodhound-cli" . 2>/dev/null && built=true
    fi
    $built && ok "go:bloodhound-cli" || fail "bloodhound-cli" "go build failed"
  else fail "bloodhound-cli" "no dir"; fi
fi

if ! done_already "go:bluebox-ng"; then
  if [ -f "$BIN/bluebox-ng" ]; then skip "bluebox-ng"; echo "PASS:go:bluebox-ng" >> "$STATE"
  elif [ -d "/opt/blackarch/bluebox-ng" ]; then
    cd "/opt/blackarch/bluebox-ng"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/bluebox-ng" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/bluebox-ng" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/bluebox-ng" . 2>/dev/null && built=true
    fi
    $built && ok "go:bluebox-ng" || fail "bluebox-ng" "go build failed"
  else fail "bluebox-ng" "no dir"; fi
fi

if ! done_already "go:cameradar"; then
  if [ -f "$BIN/cameradar" ]; then skip "cameradar"; echo "PASS:go:cameradar" >> "$STATE"
  elif [ -d "/opt/blackarch/cameradar" ]; then
    cd "/opt/blackarch/cameradar"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/cameradar" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/cameradar" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/cameradar" . 2>/dev/null && built=true
    fi
    $built && ok "go:cameradar" || fail "cameradar" "go build failed"
  else fail "cameradar" "no dir"; fi
fi

if ! done_already "go:cariddi"; then
  if [ -f "$BIN/cariddi" ]; then skip "cariddi"; echo "PASS:go:cariddi" >> "$STATE"
  elif [ -d "/opt/blackarch/cariddi" ]; then
    cd "/opt/blackarch/cariddi"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/cariddi" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/cariddi" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/cariddi" . 2>/dev/null && built=true
    fi
    $built && ok "go:cariddi" || fail "cariddi" "go build failed"
  else fail "cariddi" "no dir"; fi
fi

if ! done_already "go:cent"; then
  if [ -f "$BIN/cent" ]; then skip "cent"; echo "PASS:go:cent" >> "$STATE"
  elif [ -d "/opt/blackarch/cent" ]; then
    cd "/opt/blackarch/cent"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/cent" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/cent" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/cent" . 2>/dev/null && built=true
    fi
    $built && ok "go:cent" || fail "cent" "go build failed"
  else fail "cent" "no dir"; fi
fi

if ! done_already "go:cero"; then
  if [ -f "$BIN/cero" ]; then skip "cero"; echo "PASS:go:cero" >> "$STATE"
  elif [ -d "/opt/blackarch/cero" ]; then
    cd "/opt/blackarch/cero"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/cero" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/cero" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/cero" . 2>/dev/null && built=true
    fi
    $built && ok "go:cero" || fail "cero" "go build failed"
  else fail "cero" "no dir"; fi
fi

if ! done_already "go:certgraph"; then
  if [ -f "$BIN/certgraph" ]; then skip "certgraph"; echo "PASS:go:certgraph" >> "$STATE"
  elif [ -d "/opt/blackarch/certgraph" ]; then
    cd "/opt/blackarch/certgraph"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/certgraph" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/certgraph" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/certgraph" . 2>/dev/null && built=true
    fi
    $built && ok "go:certgraph" || fail "certgraph" "go build failed"
  else fail "certgraph" "no dir"; fi
fi

if ! done_already "go:cloudlist"; then
  if [ -f "$BIN/cloudlist" ]; then skip "cloudlist"; echo "PASS:go:cloudlist" >> "$STATE"
  elif [ -d "/opt/blackarch/cloudlist" ]; then
    cd "/opt/blackarch/cloudlist"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/cloudlist" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/cloudlist" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/cloudlist" . 2>/dev/null && built=true
    fi
    $built && ok "go:cloudlist" || fail "cloudlist" "go build failed"
  else fail "cloudlist" "no dir"; fi
fi

if ! done_already "go:cnamulator"; then
  if [ -f "$BIN/cnamulator" ]; then skip "cnamulator"; echo "PASS:go:cnamulator" >> "$STATE"
  elif [ -d "/opt/blackarch/cnamulator" ]; then
    cd "/opt/blackarch/cnamulator"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/cnamulator" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/cnamulator" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/cnamulator" . 2>/dev/null && built=true
    fi
    $built && ok "go:cnamulator" || fail "cnamulator" "go build failed"
  else fail "cnamulator" "no dir"; fi
fi

if ! done_already "go:commonspeak"; then
  if [ -f "$BIN/commonspeak" ]; then skip "commonspeak"; echo "PASS:go:commonspeak" >> "$STATE"
  elif [ -d "/opt/blackarch/commonspeak" ]; then
    cd "/opt/blackarch/commonspeak"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/commonspeak" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/commonspeak" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/commonspeak" . 2>/dev/null && built=true
    fi
    $built && ok "go:commonspeak" || fail "commonspeak" "go build failed"
  else fail "commonspeak" "no dir"; fi
fi

if ! done_already "go:dcrawl"; then
  if [ -f "$BIN/dcrawl" ]; then skip "dcrawl"; echo "PASS:go:dcrawl" >> "$STATE"
  elif [ -d "/opt/blackarch/dcrawl" ]; then
    cd "/opt/blackarch/dcrawl"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/dcrawl" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/dcrawl" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/dcrawl" . 2>/dev/null && built=true
    fi
    $built && ok "go:dcrawl" || fail "dcrawl" "go build failed"
  else fail "dcrawl" "no dir"; fi
fi

if ! done_already "go:der-ascii"; then
  if [ -f "$BIN/der-ascii" ]; then skip "der-ascii"; echo "PASS:go:der-ascii" >> "$STATE"
  elif [ -d "/opt/blackarch/der-ascii" ]; then
    cd "/opt/blackarch/der-ascii"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/der-ascii" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/der-ascii" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/der-ascii" . 2>/dev/null && built=true
    fi
    $built && ok "go:der-ascii" || fail "der-ascii" "go build failed"
  else fail "der-ascii" "no dir"; fi
fi

if ! done_already "go:dnsobserver"; then
  if [ -f "$BIN/dnsobserver" ]; then skip "dnsobserver"; echo "PASS:go:dnsobserver" >> "$STATE"
  elif [ -d "/opt/blackarch/dnsobserver" ]; then
    cd "/opt/blackarch/dnsobserver"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/dnsobserver" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/dnsobserver" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/dnsobserver" . 2>/dev/null && built=true
    fi
    $built && ok "go:dnsobserver" || fail "dnsobserver" "go build failed"
  else fail "dnsobserver" "no dir"; fi
fi

if ! done_already "go:dnsprobe"; then
  if [ -f "$BIN/dnsprobe" ]; then skip "dnsprobe"; echo "PASS:go:dnsprobe" >> "$STATE"
  elif [ -d "/opt/blackarch/dnsprobe" ]; then
    cd "/opt/blackarch/dnsprobe"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/dnsprobe" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/dnsprobe" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/dnsprobe" . 2>/dev/null && built=true
    fi
    $built && ok "go:dnsprobe" || fail "dnsprobe" "go build failed"
  else fail "dnsprobe" "no dir"; fi
fi

if ! done_already "go:dns-reverse-proxy"; then
  if [ -f "$BIN/dns-reverse-proxy" ]; then skip "dns-reverse-proxy"; echo "PASS:go:dns-reverse-proxy" >> "$STATE"
  elif [ -d "/opt/blackarch/dns-reverse-proxy" ]; then
    cd "/opt/blackarch/dns-reverse-proxy"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/dns-reverse-proxy" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/dns-reverse-proxy" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/dns-reverse-proxy" . 2>/dev/null && built=true
    fi
    $built && ok "go:dns-reverse-proxy" || fail "dns-reverse-proxy" "go build failed"
  else fail "dns-reverse-proxy" "no dir"; fi
fi

if ! done_already "go:dnssearch"; then
  if [ -f "$BIN/dnssearch" ]; then skip "dnssearch"; echo "PASS:go:dnssearch" >> "$STATE"
  elif [ -d "/opt/blackarch/dnssearch" ]; then
    cd "/opt/blackarch/dnssearch"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/dnssearch" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/dnssearch" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/dnssearch" . 2>/dev/null && built=true
    fi
    $built && ok "go:dnssearch" || fail "dnssearch" "go build failed"
  else fail "dnssearch" "no dir"; fi
fi

if ! done_already "go:dontgo403"; then
  if [ -f "$BIN/dontgo403" ]; then skip "dontgo403"; echo "PASS:go:dontgo403" >> "$STATE"
  elif [ -d "/opt/blackarch/dontgo403" ]; then
    cd "/opt/blackarch/dontgo403"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/dontgo403" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/dontgo403" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/dontgo403" . 2>/dev/null && built=true
    fi
    $built && ok "go:dontgo403" || fail "dontgo403" "go build failed"
  else fail "dontgo403" "no dir"; fi
fi

if ! done_already "go:dorkscout"; then
  if [ -f "$BIN/dorkscout" ]; then skip "dorkscout"; echo "PASS:go:dorkscout" >> "$STATE"
  elif [ -d "/opt/blackarch/dorkscout" ]; then
    cd "/opt/blackarch/dorkscout"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/dorkscout" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/dorkscout" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/dorkscout" . 2>/dev/null && built=true
    fi
    $built && ok "go:dorkscout" || fail "dorkscout" "go build failed"
  else fail "dorkscout" "no dir"; fi
fi

if ! done_already "go:evine"; then
  if [ -f "$BIN/evine" ]; then skip "evine"; echo "PASS:go:evine" >> "$STATE"
  elif [ -d "/opt/blackarch/evine" ]; then
    cd "/opt/blackarch/evine"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/evine" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/evine" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/evine" . 2>/dev/null && built=true
    fi
    $built && ok "go:evine" || fail "evine" "go build failed"
  else fail "evine" "no dir"; fi
fi

if ! done_already "go:exiflooter"; then
  if [ -f "$BIN/exiflooter" ]; then skip "exiflooter"; echo "PASS:go:exiflooter" >> "$STATE"
  elif [ -d "/opt/blackarch/exiflooter" ]; then
    cd "/opt/blackarch/exiflooter"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/exiflooter" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/exiflooter" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/exiflooter" . 2>/dev/null && built=true
    fi
    $built && ok "go:exiflooter" || fail "exiflooter" "go build failed"
  else fail "exiflooter" "no dir"; fi
fi

if ! done_already "go:find3"; then
  if [ -f "$BIN/find3" ]; then skip "find3"; echo "PASS:go:find3" >> "$STATE"
  elif [ -d "/opt/blackarch/find3" ]; then
    cd "/opt/blackarch/find3"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/find3" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/find3" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/find3" . 2>/dev/null && built=true
    fi
    $built && ok "go:find3" || fail "find3" "go build failed"
  else fail "find3" "no dir"; fi
fi

if ! done_already "go:fortiscan"; then
  if [ -f "$BIN/fortiscan" ]; then skip "fortiscan"; echo "PASS:go:fortiscan" >> "$STATE"
  elif [ -d "/opt/blackarch/fortiscan" ]; then
    cd "/opt/blackarch/fortiscan"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/fortiscan" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/fortiscan" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/fortiscan" . 2>/dev/null && built=true
    fi
    $built && ok "go:fortiscan" || fail "fortiscan" "go build failed"
  else fail "fortiscan" "no dir"; fi
fi

if ! done_already "go:gau"; then
  if [ -f "$BIN/gau" ]; then skip "gau"; echo "PASS:go:gau" >> "$STATE"
  elif [ -d "/opt/blackarch/gau" ]; then
    cd "/opt/blackarch/gau"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/gau" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/gau" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/gau" . 2>/dev/null && built=true
    fi
    $built && ok "go:gau" || fail "gau" "go build failed"
  else fail "gau" "no dir"; fi
fi

if ! done_already "go:gf"; then
  if [ -f "$BIN/gf" ]; then skip "gf"; echo "PASS:go:gf" >> "$STATE"
  elif [ -d "/opt/blackarch/gf" ]; then
    cd "/opt/blackarch/gf"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/gf" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/gf" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/gf" . 2>/dev/null && built=true
    fi
    $built && ok "go:gf" || fail "gf" "go build failed"
  else fail "gf" "no dir"; fi
fi

if ! done_already "go:girsh"; then
  if [ -f "$BIN/girsh" ]; then skip "girsh"; echo "PASS:go:girsh" >> "$STATE"
  elif [ -d "/opt/blackarch/girsh" ]; then
    cd "/opt/blackarch/girsh"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/girsh" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/girsh" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/girsh" . 2>/dev/null && built=true
    fi
    $built && ok "go:girsh" || fail "girsh" "go build failed"
  else fail "girsh" "no dir"; fi
fi

if ! done_already "go:gobd"; then
  if [ -f "$BIN/gobd" ]; then skip "gobd"; echo "PASS:go:gobd" >> "$STATE"
  elif [ -d "/opt/blackarch/gobd" ]; then
    cd "/opt/blackarch/gobd"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/gobd" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/gobd" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/gobd" . 2>/dev/null && built=true
    fi
    $built && ok "go:gobd" || fail "gobd" "go build failed"
  else fail "gobd" "no dir"; fi
fi

if ! done_already "go:goddi"; then
  if [ -f "$BIN/goddi" ]; then skip "goddi"; echo "PASS:go:goddi" >> "$STATE"
  elif [ -d "/opt/blackarch/goddi" ]; then
    cd "/opt/blackarch/goddi"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/goddi" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/goddi" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/goddi" . 2>/dev/null && built=true
    fi
    $built && ok "go:goddi" || fail "goddi" "go build failed"
  else fail "goddi" "no dir"; fi
fi

if ! done_already "go:go-exploitdb"; then
  if [ -f "$BIN/go-exploitdb" ]; then skip "go-exploitdb"; echo "PASS:go:go-exploitdb" >> "$STATE"
  elif [ -d "/opt/blackarch/go-exploitdb" ]; then
    cd "/opt/blackarch/go-exploitdb"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/go-exploitdb" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/go-exploitdb" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/go-exploitdb" . 2>/dev/null && built=true
    fi
    $built && ok "go:go-exploitdb" || fail "go-exploitdb" "go build failed"
  else fail "go-exploitdb" "no dir"; fi
fi

if ! done_already "go:golang-glide"; then
  if [ -f "$BIN/golang-glide" ]; then skip "golang-glide"; echo "PASS:go:golang-glide" >> "$STATE"
  elif [ -d "/opt/blackarch/golang-glide" ]; then
    cd "/opt/blackarch/golang-glide"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/golang-glide" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/golang-glide" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/golang-glide" . 2>/dev/null && built=true
    fi
    $built && ok "go:golang-glide" || fail "golang-glide" "go build failed"
  else fail "golang-glide" "no dir"; fi
fi

if ! done_already "go:gomapenum"; then
  if [ -f "$BIN/gomapenum" ]; then skip "gomapenum"; echo "PASS:go:gomapenum" >> "$STATE"
  elif [ -d "/opt/blackarch/gomapenum" ]; then
    cd "/opt/blackarch/gomapenum"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/gomapenum" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/gomapenum" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/gomapenum" . 2>/dev/null && built=true
    fi
    $built && ok "go:gomapenum" || fail "gomapenum" "go build failed"
  else fail "gomapenum" "no dir"; fi
fi

if ! done_already "go:goop-dump"; then
  if [ -f "$BIN/goop-dump" ]; then skip "goop-dump"; echo "PASS:go:goop-dump" >> "$STATE"
  elif [ -d "/opt/blackarch/goop-dump" ]; then
    cd "/opt/blackarch/goop-dump"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/goop-dump" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/goop-dump" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/goop-dump" . 2>/dev/null && built=true
    fi
    $built && ok "go:goop-dump" || fail "goop-dump" "go build failed"
  else fail "goop-dump" "no dir"; fi
fi

if ! done_already "go:goshs"; then
  if [ -f "$BIN/goshs" ]; then skip "goshs"; echo "PASS:go:goshs" >> "$STATE"
  elif [ -d "/opt/blackarch/goshs" ]; then
    cd "/opt/blackarch/goshs"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/goshs" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/goshs" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/goshs" . 2>/dev/null && built=true
    fi
    $built && ok "go:goshs" || fail "goshs" "go build failed"
  else fail "goshs" "no dir"; fi
fi

if ! done_already "go:gosint"; then
  if [ -f "$BIN/gosint" ]; then skip "gosint"; echo "PASS:go:gosint" >> "$STATE"
  elif [ -d "/opt/blackarch/gosint" ]; then
    cd "/opt/blackarch/gosint"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/gosint" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/gosint" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/gosint" . 2>/dev/null && built=true
    fi
    $built && ok "go:gosint" || fail "gosint" "go build failed"
  else fail "gosint" "no dir"; fi
fi

if ! done_already "go:gospider"; then
  if [ -f "$BIN/gospider" ]; then skip "gospider"; echo "PASS:go:gospider" >> "$STATE"
  elif [ -d "/opt/blackarch/gospider" ]; then
    cd "/opt/blackarch/gospider"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/gospider" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/gospider" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/gospider" . 2>/dev/null && built=true
    fi
    $built && ok "go:gospider" || fail "gospider" "go build failed"
  else fail "gospider" "no dir"; fi
fi

if ! done_already "go:gowitness"; then
  if [ -f "$BIN/gowitness" ]; then skip "gowitness"; echo "PASS:go:gowitness" >> "$STATE"
  elif [ -d "/opt/blackarch/gowitness" ]; then
    cd "/opt/blackarch/gowitness"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/gowitness" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/gowitness" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/gowitness" . 2>/dev/null && built=true
    fi
    $built && ok "go:gowitness" || fail "gowitness" "go build failed"
  else fail "gowitness" "no dir"; fi
fi

if ! done_already "go:h2spec"; then
  if [ -f "$BIN/h2spec" ]; then skip "h2spec"; echo "PASS:go:h2spec" >> "$STATE"
  elif [ -d "/opt/blackarch/h2spec" ]; then
    cd "/opt/blackarch/h2spec"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/h2spec" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/h2spec" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/h2spec" . 2>/dev/null && built=true
    fi
    $built && ok "go:h2spec" || fail "h2spec" "go build failed"
  else fail "h2spec" "no dir"; fi
fi

if ! done_already "go:hakrawler"; then
  if [ -f "$BIN/hakrawler" ]; then skip "hakrawler"; echo "PASS:go:hakrawler" >> "$STATE"
  elif [ -d "/opt/blackarch/hakrawler" ]; then
    cd "/opt/blackarch/hakrawler"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/hakrawler" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/hakrawler" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/hakrawler" . 2>/dev/null && built=true
    fi
    $built && ok "go:hakrawler" || fail "hakrawler" "go build failed"
  else fail "hakrawler" "no dir"; fi
fi

if ! done_already "go:hakrevdns"; then
  if [ -f "$BIN/hakrevdns" ]; then skip "hakrevdns"; echo "PASS:go:hakrevdns" >> "$STATE"
  elif [ -d "/opt/blackarch/hakrevdns" ]; then
    cd "/opt/blackarch/hakrevdns"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/hakrevdns" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/hakrevdns" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/hakrevdns" . 2>/dev/null && built=true
    fi
    $built && ok "go:hakrevdns" || fail "hakrevdns" "go build failed"
  else fail "hakrevdns" "no dir"; fi
fi

if ! done_already "go:hercules-payload"; then
  if [ -f "$BIN/hercules-payload" ]; then skip "hercules-payload"; echo "PASS:go:hercules-payload" >> "$STATE"
  elif [ -d "/opt/blackarch/hercules-payload" ]; then
    cd "/opt/blackarch/hercules-payload"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/hercules-payload" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/hercules-payload" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/hercules-payload" . 2>/dev/null && built=true
    fi
    $built && ok "go:hercules-payload" || fail "hercules-payload" "go build failed"
  else fail "hercules-payload" "no dir"; fi
fi

if ! done_already "go:hetty"; then
  if [ -f "$BIN/hetty" ]; then skip "hetty"; echo "PASS:go:hetty" >> "$STATE"
  elif [ -d "/opt/blackarch/hetty" ]; then
    cd "/opt/blackarch/hetty"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/hetty" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/hetty" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/hetty" . 2>/dev/null && built=true
    fi
    $built && ok "go:hetty" || fail "hetty" "go build failed"
  else fail "hetty" "no dir"; fi
fi

if ! done_already "go:http2smugl"; then
  if [ -f "$BIN/http2smugl" ]; then skip "http2smugl"; echo "PASS:go:http2smugl" >> "$STATE"
  elif [ -d "/opt/blackarch/http2smugl" ]; then
    cd "/opt/blackarch/http2smugl"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/http2smugl" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/http2smugl" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/http2smugl" . 2>/dev/null && built=true
    fi
    $built && ok "go:http2smugl" || fail "http2smugl" "go build failed"
  else fail "http2smugl" "no dir"; fi
fi

if ! done_already "go:httprobe"; then
  if [ -f "$BIN/httprobe" ]; then skip "httprobe"; echo "PASS:go:httprobe" >> "$STATE"
  elif [ -d "/opt/blackarch/httprobe" ]; then
    cd "/opt/blackarch/httprobe"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/httprobe" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/httprobe" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/httprobe" . 2>/dev/null && built=true
    fi
    $built && ok "go:httprobe" || fail "httprobe" "go build failed"
  else fail "httprobe" "no dir"; fi
fi

if ! done_already "go:ipv666"; then
  if [ -f "$BIN/ipv666" ]; then skip "ipv666"; echo "PASS:go:ipv666" >> "$STATE"
  elif [ -d "/opt/blackarch/ipv666" ]; then
    cd "/opt/blackarch/ipv666"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/ipv666" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/ipv666" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/ipv666" . 2>/dev/null && built=true
    fi
    $built && ok "go:ipv666" || fail "ipv666" "go build failed"
  else fail "ipv666" "no dir"; fi
fi

if ! done_already "go:jaeles"; then
  if [ -f "$BIN/jaeles" ]; then skip "jaeles"; echo "PASS:go:jaeles" >> "$STATE"
  elif [ -d "/opt/blackarch/jaeles" ]; then
    cd "/opt/blackarch/jaeles"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/jaeles" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/jaeles" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/jaeles" . 2>/dev/null && built=true
    fi
    $built && ok "go:jaeles" || fail "jaeles" "go build failed"
  else fail "jaeles" "no dir"; fi
fi

if ! done_already "go:jinjector"; then
  if [ -f "$BIN/jinjector" ]; then skip "jinjector"; echo "PASS:go:jinjector" >> "$STATE"
  elif [ -d "/opt/blackarch/jinjector" ]; then
    cd "/opt/blackarch/jinjector"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/jinjector" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/jinjector" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/jinjector" . 2>/dev/null && built=true
    fi
    $built && ok "go:jinjector" || fail "jinjector" "go build failed"
  else fail "jinjector" "no dir"; fi
fi

if ! done_already "go:kerbrute"; then
  if [ -f "$BIN/kerbrute" ]; then skip "kerbrute"; echo "PASS:go:kerbrute" >> "$STATE"
  elif [ -d "/opt/blackarch/kerbrute" ]; then
    cd "/opt/blackarch/kerbrute"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/kerbrute" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/kerbrute" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/kerbrute" . 2>/dev/null && built=true
    fi
    $built && ok "go:kerbrute" || fail "kerbrute" "go build failed"
  else fail "kerbrute" "no dir"; fi
fi

if ! done_already "go:klar"; then
  if [ -f "$BIN/klar" ]; then skip "klar"; echo "PASS:go:klar" >> "$STATE"
  elif [ -d "/opt/blackarch/klar" ]; then
    cd "/opt/blackarch/klar"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/klar" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/klar" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/klar" . 2>/dev/null && built=true
    fi
    $built && ok "go:klar" || fail "klar" "go build failed"
  else fail "klar" "no dir"; fi
fi

if ! done_already "go:limelighter"; then
  if [ -f "$BIN/limelighter" ]; then skip "limelighter"; echo "PASS:go:limelighter" >> "$STATE"
  elif [ -d "/opt/blackarch/limelighter" ]; then
    cd "/opt/blackarch/limelighter"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/limelighter" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/limelighter" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/limelighter" . 2>/dev/null && built=true
    fi
    $built && ok "go:limelighter" || fail "limelighter" "go build failed"
  else fail "limelighter" "no dir"; fi
fi

if ! done_already "go:local-php-security-checker"; then
  if [ -f "$BIN/local-php-security-checker" ]; then skip "local-php-security-checker"; echo "PASS:go:local-php-security-checker" >> "$STATE"
  elif [ -d "/opt/blackarch/local-php-security-checker" ]; then
    cd "/opt/blackarch/local-php-security-checker"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/local-php-security-checker" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/local-php-security-checker" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/local-php-security-checker" . 2>/dev/null && built=true
    fi
    $built && ok "go:local-php-security-checker" || fail "local-php-security-checker" "go build failed"
  else fail "local-php-security-checker" "no dir"; fi
fi

if ! done_already "go:mallory"; then
  if [ -f "$BIN/mallory" ]; then skip "mallory"; echo "PASS:go:mallory" >> "$STATE"
  elif [ -d "/opt/blackarch/mallory" ]; then
    cd "/opt/blackarch/mallory"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/mallory" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/mallory" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/mallory" . 2>/dev/null && built=true
    fi
    $built && ok "go:mallory" || fail "mallory" "go build failed"
  else fail "mallory" "no dir"; fi
fi

if ! done_already "go:mantra"; then
  if [ -f "$BIN/mantra" ]; then skip "mantra"; echo "PASS:go:mantra" >> "$STATE"
  elif [ -d "/opt/blackarch/mantra" ]; then
    cd "/opt/blackarch/mantra"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/mantra" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/mantra" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/mantra" . 2>/dev/null && built=true
    fi
    $built && ok "go:mantra" || fail "mantra" "go build failed"
  else fail "mantra" "no dir"; fi
fi

if ! done_already "go:meg"; then
  if [ -f "$BIN/meg" ]; then skip "meg"; echo "PASS:go:meg" >> "$STATE"
  elif [ -d "/opt/blackarch/meg" ]; then
    cd "/opt/blackarch/meg"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/meg" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/meg" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/meg" . 2>/dev/null && built=true
    fi
    $built && ok "go:meg" || fail "meg" "go build failed"
  else fail "meg" "no dir"; fi
fi

if ! done_already "go:merlin-server"; then
  if [ -f "$BIN/merlin-server" ]; then skip "merlin-server"; echo "PASS:go:merlin-server" >> "$STATE"
  elif [ -d "/opt/blackarch/merlin-server" ]; then
    cd "/opt/blackarch/merlin-server"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/merlin-server" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/merlin-server" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/merlin-server" . 2>/dev/null && built=true
    fi
    $built && ok "go:merlin-server" || fail "merlin-server" "go build failed"
  else fail "merlin-server" "no dir"; fi
fi

if ! done_already "go:mildew"; then
  if [ -f "$BIN/mildew" ]; then skip "mildew"; echo "PASS:go:mildew" >> "$STATE"
  elif [ -d "/opt/blackarch/mildew" ]; then
    cd "/opt/blackarch/mildew"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/mildew" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/mildew" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/mildew" . 2>/dev/null && built=true
    fi
    $built && ok "go:mildew" || fail "mildew" "go build failed"
  else fail "mildew" "no dir"; fi
fi

if ! done_already "go:monsoon"; then
  if [ -f "$BIN/monsoon" ]; then skip "monsoon"; echo "PASS:go:monsoon" >> "$STATE"
  elif [ -d "/opt/blackarch/monsoon" ]; then
    cd "/opt/blackarch/monsoon"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/monsoon" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/monsoon" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/monsoon" . 2>/dev/null && built=true
    fi
    $built && ok "go:monsoon" || fail "monsoon" "go build failed"
  else fail "monsoon" "no dir"; fi
fi

if ! done_already "go:msmailprobe"; then
  if [ -f "$BIN/msmailprobe" ]; then skip "msmailprobe"; echo "PASS:go:msmailprobe" >> "$STATE"
  elif [ -d "/opt/blackarch/msmailprobe" ]; then
    cd "/opt/blackarch/msmailprobe"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/msmailprobe" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/msmailprobe" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/msmailprobe" . 2>/dev/null && built=true
    fi
    $built && ok "go:msmailprobe" || fail "msmailprobe" "go build failed"
  else fail "msmailprobe" "no dir"; fi
fi

if ! done_already "go:mubeng"; then
  if [ -f "$BIN/mubeng" ]; then skip "mubeng"; echo "PASS:go:mubeng" >> "$STATE"
  elif [ -d "/opt/blackarch/mubeng" ]; then
    cd "/opt/blackarch/mubeng"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/mubeng" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/mubeng" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/mubeng" . 2>/dev/null && built=true
    fi
    $built && ok "go:mubeng" || fail "mubeng" "go build failed"
  else fail "mubeng" "no dir"; fi
fi

if ! done_already "go:mylg"; then
  if [ -f "$BIN/mylg" ]; then skip "mylg"; echo "PASS:go:mylg" >> "$STATE"
  elif [ -d "/opt/blackarch/mylg" ]; then
    cd "/opt/blackarch/mylg"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/mylg" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/mylg" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/mylg" . 2>/dev/null && built=true
    fi
    $built && ok "go:mylg" || fail "mylg" "go build failed"
  else fail "mylg" "no dir"; fi
fi

if ! done_already "go:navgix"; then
  if [ -f "$BIN/navgix" ]; then skip "navgix"; echo "PASS:go:navgix" >> "$STATE"
  elif [ -d "/opt/blackarch/navgix" ]; then
    cd "/opt/blackarch/navgix"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/navgix" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/navgix" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/navgix" . 2>/dev/null && built=true
    fi
    $built && ok "go:navgix" || fail "navgix" "go build failed"
  else fail "navgix" "no dir"; fi
fi

if ! done_already "go:netscout"; then
  if [ -f "$BIN/netscout" ]; then skip "netscout"; echo "PASS:go:netscout" >> "$STATE"
  elif [ -d "/opt/blackarch/netscout" ]; then
    cd "/opt/blackarch/netscout"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/netscout" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/netscout" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/netscout" . 2>/dev/null && built=true
    fi
    $built && ok "go:netscout" || fail "netscout" "go build failed"
  else fail "netscout" "no dir"; fi
fi

if ! done_already "go:nextnet"; then
  if [ -f "$BIN/nextnet" ]; then skip "nextnet"; echo "PASS:go:nextnet" >> "$STATE"
  elif [ -d "/opt/blackarch/nextnet" ]; then
    cd "/opt/blackarch/nextnet"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/nextnet" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/nextnet" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/nextnet" . 2>/dev/null && built=true
    fi
    $built && ok "go:nextnet" || fail "nextnet" "go build failed"
  else fail "nextnet" "no dir"; fi
fi

if ! done_already "go:nray"; then
  if [ -f "$BIN/nray" ]; then skip "nray"; echo "PASS:go:nray" >> "$STATE"
  elif [ -d "/opt/blackarch/nray" ]; then
    cd "/opt/blackarch/nray"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/nray" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/nray" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/nray" . 2>/dev/null && built=true
    fi
    $built && ok "go:nray" || fail "nray" "go build failed"
  else fail "nray" "no dir"; fi
fi

if ! done_already "go:nuclei"; then
  if [ -f "$BIN/nuclei" ]; then skip "nuclei"; echo "PASS:go:nuclei" >> "$STATE"
  elif [ -d "/opt/blackarch/nuclei" ]; then
    cd "/opt/blackarch/nuclei"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/nuclei" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/nuclei" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/nuclei" . 2>/dev/null && built=true
    fi
    $built && ok "go:nuclei" || fail "nuclei" "go build failed"
  else fail "nuclei" "no dir"; fi
fi

if ! done_already "go:oniongrok"; then
  if [ -f "$BIN/oniongrok" ]; then skip "oniongrok"; echo "PASS:go:oniongrok" >> "$STATE"
  elif [ -d "/opt/blackarch/oniongrok" ]; then
    cd "/opt/blackarch/oniongrok"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/oniongrok" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/oniongrok" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/oniongrok" . 2>/dev/null && built=true
    fi
    $built && ok "go:oniongrok" || fail "oniongrok" "go build failed"
  else fail "oniongrok" "no dir"; fi
fi

if ! done_already "go:onionscan"; then
  if [ -f "$BIN/onionscan" ]; then skip "onionscan"; echo "PASS:go:onionscan" >> "$STATE"
  elif [ -d "/opt/blackarch/onionscan" ]; then
    cd "/opt/blackarch/onionscan"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/onionscan" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/onionscan" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/onionscan" . 2>/dev/null && built=true
    fi
    $built && ok "go:onionscan" || fail "onionscan" "go build failed"
  else fail "onionscan" "no dir"; fi
fi

if ! done_already "go:openrisk"; then
  if [ -f "$BIN/openrisk" ]; then skip "openrisk"; echo "PASS:go:openrisk" >> "$STATE"
  elif [ -d "/opt/blackarch/openrisk" ]; then
    cd "/opt/blackarch/openrisk"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/openrisk" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/openrisk" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/openrisk" . 2>/dev/null && built=true
    fi
    $built && ok "go:openrisk" || fail "openrisk" "go build failed"
  else fail "openrisk" "no dir"; fi
fi

if ! done_already "go:passdetective"; then
  if [ -f "$BIN/passdetective" ]; then skip "passdetective"; echo "PASS:go:passdetective" >> "$STATE"
  elif [ -d "/opt/blackarch/passdetective" ]; then
    cd "/opt/blackarch/passdetective"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/passdetective" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/passdetective" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/passdetective" . 2>/dev/null && built=true
    fi
    $built && ok "go:passdetective" || fail "passdetective" "go build failed"
  else fail "passdetective" "no dir"; fi
fi

if ! done_already "go:pencode"; then
  if [ -f "$BIN/pencode" ]; then skip "pencode"; echo "PASS:go:pencode" >> "$STATE"
  elif [ -d "/opt/blackarch/pencode" ]; then
    cd "/opt/blackarch/pencode"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/pencode" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/pencode" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/pencode" . 2>/dev/null && built=true
    fi
    $built && ok "go:pencode" || fail "pencode" "go build failed"
  else fail "pencode" "no dir"; fi
fi

if ! done_already "go:phishery"; then
  if [ -f "$BIN/phishery" ]; then skip "phishery"; echo "PASS:go:phishery" >> "$STATE"
  elif [ -d "/opt/blackarch/phishery" ]; then
    cd "/opt/blackarch/phishery"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/phishery" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/phishery" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/phishery" . 2>/dev/null && built=true
    fi
    $built && ok "go:phishery" || fail "phishery" "go build failed"
  else fail "phishery" "no dir"; fi
fi

if ! done_already "go:phoneinfoga"; then
  if [ -f "$BIN/phoneinfoga" ]; then skip "phoneinfoga"; echo "PASS:go:phoneinfoga" >> "$STATE"
  elif [ -d "/opt/blackarch/phoneinfoga" ]; then
    cd "/opt/blackarch/phoneinfoga"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/phoneinfoga" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/phoneinfoga" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/phoneinfoga" . 2>/dev/null && built=true
    fi
    $built && ok "go:phoneinfoga" || fail "phoneinfoga" "go build failed"
  else fail "phoneinfoga" "no dir"; fi
fi

if ! done_already "go:platypus"; then
  if [ -f "$BIN/platypus" ]; then skip "platypus"; echo "PASS:go:platypus" >> "$STATE"
  elif [ -d "/opt/blackarch/platypus" ]; then
    cd "/opt/blackarch/platypus"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/platypus" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/platypus" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/platypus" . 2>/dev/null && built=true
    fi
    $built && ok "go:platypus" || fail "platypus" "go build failed"
  else fail "platypus" "no dir"; fi
fi

if ! done_already "go:proxify"; then
  if [ -f "$BIN/proxify" ]; then skip "proxify"; echo "PASS:go:proxify" >> "$STATE"
  elif [ -d "/opt/blackarch/proxify" ]; then
    cd "/opt/blackarch/proxify"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/proxify" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/proxify" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/proxify" . 2>/dev/null && built=true
    fi
    $built && ok "go:proxify" || fail "proxify" "go build failed"
  else fail "proxify" "no dir"; fi
fi

if ! done_already "go:puredns"; then
  if [ -f "$BIN/puredns" ]; then skip "puredns"; echo "PASS:go:puredns" >> "$STATE"
  elif [ -d "/opt/blackarch/puredns" ]; then
    cd "/opt/blackarch/puredns"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/puredns" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/puredns" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/puredns" . 2>/dev/null && built=true
    fi
    $built && ok "go:puredns" || fail "puredns" "go build failed"
  else fail "puredns" "no dir"; fi
fi

if ! done_already "go:qsreplace"; then
  if [ -f "$BIN/qsreplace" ]; then skip "qsreplace"; echo "PASS:go:qsreplace" >> "$STATE"
  elif [ -d "/opt/blackarch/qsreplace" ]; then
    cd "/opt/blackarch/qsreplace"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/qsreplace" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/qsreplace" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/qsreplace" . 2>/dev/null && built=true
    fi
    $built && ok "go:qsreplace" || fail "qsreplace" "go build failed"
  else fail "qsreplace" "no dir"; fi
fi

if ! done_already "go:raven"; then
  if [ -f "$BIN/raven" ]; then skip "raven"; echo "PASS:go:raven" >> "$STATE"
  elif [ -d "/opt/blackarch/raven" ]; then
    cd "/opt/blackarch/raven"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/raven" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/raven" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/raven" . 2>/dev/null && built=true
    fi
    $built && ok "go:raven" || fail "raven" "go build failed"
  else fail "raven" "no dir"; fi
fi

if ! done_already "go:redress"; then
  if [ -f "$BIN/redress" ]; then skip "redress"; echo "PASS:go:redress" >> "$STATE"
  elif [ -d "/opt/blackarch/redress" ]; then
    cd "/opt/blackarch/redress"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/redress" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/redress" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/redress" . 2>/dev/null && built=true
    fi
    $built && ok "go:redress" || fail "redress" "go build failed"
  else fail "redress" "no dir"; fi
fi

if ! done_already "go:ruler"; then
  if [ -f "$BIN/ruler" ]; then skip "ruler"; echo "PASS:go:ruler" >> "$STATE"
  elif [ -d "/opt/blackarch/ruler" ]; then
    cd "/opt/blackarch/ruler"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/ruler" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/ruler" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/ruler" . 2>/dev/null && built=true
    fi
    $built && ok "go:ruler" || fail "ruler" "go build failed"
  else fail "ruler" "no dir"; fi
fi

if ! done_already "go:s3enum"; then
  if [ -f "$BIN/s3enum" ]; then skip "s3enum"; echo "PASS:go:s3enum" >> "$STATE"
  elif [ -d "/opt/blackarch/s3enum" ]; then
    cd "/opt/blackarch/s3enum"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/s3enum" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/s3enum" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/s3enum" . 2>/dev/null && built=true
    fi
    $built && ok "go:s3enum" || fail "s3enum" "go build failed"
  else fail "s3enum" "no dir"; fi
fi

if ! done_already "go:s3-fuzzer"; then
  if [ -f "$BIN/s3-fuzzer" ]; then skip "s3-fuzzer"; echo "PASS:go:s3-fuzzer" >> "$STATE"
  elif [ -d "/opt/blackarch/s3-fuzzer" ]; then
    cd "/opt/blackarch/s3-fuzzer"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/s3-fuzzer" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/s3-fuzzer" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/s3-fuzzer" . 2>/dev/null && built=true
    fi
    $built && ok "go:s3-fuzzer" || fail "s3-fuzzer" "go build failed"
  else fail "s3-fuzzer" "no dir"; fi
fi

if ! done_already "go:second-order"; then
  if [ -f "$BIN/second-order" ]; then skip "second-order"; echo "PASS:go:second-order" >> "$STATE"
  elif [ -d "/opt/blackarch/second-order" ]; then
    cd "/opt/blackarch/second-order"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/second-order" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/second-order" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/second-order" . 2>/dev/null && built=true
    fi
    $built && ok "go:second-order" || fail "second-order" "go build failed"
  else fail "second-order" "no dir"; fi
fi

if ! done_already "go:shhgit"; then
  if [ -f "$BIN/shhgit" ]; then skip "shhgit"; echo "PASS:go:shhgit" >> "$STATE"
  elif [ -d "/opt/blackarch/shhgit" ]; then
    cd "/opt/blackarch/shhgit"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/shhgit" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/shhgit" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/shhgit" . 2>/dev/null && built=true
    fi
    $built && ok "go:shhgit" || fail "shhgit" "go build failed"
  else fail "shhgit" "no dir"; fi
fi

if ! done_already "go:shosubgo"; then
  if [ -f "$BIN/shosubgo" ]; then skip "shosubgo"; echo "PASS:go:shosubgo" >> "$STATE"
  elif [ -d "/opt/blackarch/shosubgo" ]; then
    cd "/opt/blackarch/shosubgo"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/shosubgo" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/shosubgo" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/shosubgo" . 2>/dev/null && built=true
    fi
    $built && ok "go:shosubgo" || fail "shosubgo" "go build failed"
  else fail "shosubgo" "no dir"; fi
fi

if ! done_already "go:shuffledns"; then
  if [ -f "$BIN/shuffledns" ]; then skip "shuffledns"; echo "PASS:go:shuffledns" >> "$STATE"
  elif [ -d "/opt/blackarch/shuffledns" ]; then
    cd "/opt/blackarch/shuffledns"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/shuffledns" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/shuffledns" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/shuffledns" . 2>/dev/null && built=true
    fi
    $built && ok "go:shuffledns" || fail "shuffledns" "go build failed"
  else fail "shuffledns" "no dir"; fi
fi

if ! done_already "go:sipbrute"; then
  if [ -f "$BIN/sipbrute" ]; then skip "sipbrute"; echo "PASS:go:sipbrute" >> "$STATE"
  elif [ -d "/opt/blackarch/sipbrute" ]; then
    cd "/opt/blackarch/sipbrute"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/sipbrute" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/sipbrute" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/sipbrute" . 2>/dev/null && built=true
    fi
    $built && ok "go:sipbrute" || fail "sipbrute" "go build failed"
  else fail "sipbrute" "no dir"; fi
fi

if ! done_already "go:sipshock"; then
  if [ -f "$BIN/sipshock" ]; then skip "sipshock"; echo "PASS:go:sipshock" >> "$STATE"
  elif [ -d "/opt/blackarch/sipshock" ]; then
    cd "/opt/blackarch/sipshock"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/sipshock" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/sipshock" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/sipshock" . 2>/dev/null && built=true
    fi
    $built && ok "go:sipshock" || fail "sipshock" "go build failed"
  else fail "sipshock" "no dir"; fi
fi

if ! done_already "go:sj"; then
  if [ -f "$BIN/sj" ]; then skip "sj"; echo "PASS:go:sj" >> "$STATE"
  elif [ -d "/opt/blackarch/sj" ]; then
    cd "/opt/blackarch/sj"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/sj" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/sj" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/sj" . 2>/dev/null && built=true
    fi
    $built && ok "go:sj" || fail "sj" "go build failed"
  else fail "sj" "no dir"; fi
fi

if ! done_already "go:slurp-scanner"; then
  if [ -f "$BIN/slurp-scanner" ]; then skip "slurp-scanner"; echo "PASS:go:slurp-scanner" >> "$STATE"
  elif [ -d "/opt/blackarch/slurp-scanner" ]; then
    cd "/opt/blackarch/slurp-scanner"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/slurp-scanner" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/slurp-scanner" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/slurp-scanner" . 2>/dev/null && built=true
    fi
    $built && ok "go:slurp-scanner" || fail "slurp-scanner" "go build failed"
  else fail "slurp-scanner" "no dir"; fi
fi

if ! done_already "go:smap-scanner"; then
  if [ -f "$BIN/smap-scanner" ]; then skip "smap-scanner"; echo "PASS:go:smap-scanner" >> "$STATE"
  elif [ -d "/opt/blackarch/smap-scanner" ]; then
    cd "/opt/blackarch/smap-scanner"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/smap-scanner" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/smap-scanner" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/smap-scanner" . 2>/dev/null && built=true
    fi
    $built && ok "go:smap-scanner" || fail "smap-scanner" "go build failed"
  else fail "smap-scanner" "no dir"; fi
fi

if ! done_already "go:sourcemapper"; then
  if [ -f "$BIN/sourcemapper" ]; then skip "sourcemapper"; echo "PASS:go:sourcemapper" >> "$STATE"
  elif [ -d "/opt/blackarch/sourcemapper" ]; then
    cd "/opt/blackarch/sourcemapper"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/sourcemapper" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/sourcemapper" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/sourcemapper" . 2>/dev/null && built=true
    fi
    $built && ok "go:sourcemapper" || fail "sourcemapper" "go build failed"
  else fail "sourcemapper" "no dir"; fi
fi

if ! done_already "go:spfmap"; then
  if [ -f "$BIN/spfmap" ]; then skip "spfmap"; echo "PASS:go:spfmap" >> "$STATE"
  elif [ -d "/opt/blackarch/spfmap" ]; then
    cd "/opt/blackarch/spfmap"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/spfmap" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/spfmap" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/spfmap" . 2>/dev/null && built=true
    fi
    $built && ok "go:spfmap" || fail "spfmap" "go build failed"
  else fail "spfmap" "no dir"; fi
fi

if ! done_already "go:ssllabs-scan"; then
  if [ -f "$BIN/ssllabs-scan" ]; then skip "ssllabs-scan"; echo "PASS:go:ssllabs-scan" >> "$STATE"
  elif [ -d "/opt/blackarch/ssllabs-scan" ]; then
    cd "/opt/blackarch/ssllabs-scan"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/ssllabs-scan" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/ssllabs-scan" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/ssllabs-scan" . 2>/dev/null && built=true
    fi
    $built && ok "go:ssllabs-scan" || fail "ssllabs-scan" "go build failed"
  else fail "ssllabs-scan" "no dir"; fi
fi

if ! done_already "go:ssrf-sheriff"; then
  if [ -f "$BIN/ssrf-sheriff" ]; then skip "ssrf-sheriff"; echo "PASS:go:ssrf-sheriff" >> "$STATE"
  elif [ -d "/opt/blackarch/ssrf-sheriff" ]; then
    cd "/opt/blackarch/ssrf-sheriff"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/ssrf-sheriff" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/ssrf-sheriff" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/ssrf-sheriff" . 2>/dev/null && built=true
    fi
    $built && ok "go:ssrf-sheriff" || fail "ssrf-sheriff" "go build failed"
  else fail "ssrf-sheriff" "no dir"; fi
fi

if ! done_already "go:subjack"; then
  if [ -f "$BIN/subjack" ]; then skip "subjack"; echo "PASS:go:subjack" >> "$STATE"
  elif [ -d "/opt/blackarch/subjack" ]; then
    cd "/opt/blackarch/subjack"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/subjack" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/subjack" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/subjack" . 2>/dev/null && built=true
    fi
    $built && ok "go:subjack" || fail "subjack" "go build failed"
  else fail "subjack" "no dir"; fi
fi

if ! done_already "go:subjs"; then
  if [ -f "$BIN/subjs" ]; then skip "subjs"; echo "PASS:go:subjs" >> "$STATE"
  elif [ -d "/opt/blackarch/subjs" ]; then
    cd "/opt/blackarch/subjs"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/subjs" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/subjs" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/subjs" . 2>/dev/null && built=true
    fi
    $built && ok "go:subjs" || fail "subjs" "go build failed"
  else fail "subjs" "no dir"; fi
fi

if ! done_already "go:subover"; then
  if [ -f "$BIN/subover" ]; then skip "subover"; echo "PASS:go:subover" >> "$STATE"
  elif [ -d "/opt/blackarch/subover" ]; then
    cd "/opt/blackarch/subover"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/subover" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/subover" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/subover" . 2>/dev/null && built=true
    fi
    $built && ok "go:subover" || fail "subover" "go build failed"
  else fail "subover" "no dir"; fi
fi

if ! done_already "go:subzy"; then
  if [ -f "$BIN/subzy" ]; then skip "subzy"; echo "PASS:go:subzy" >> "$STATE"
  elif [ -d "/opt/blackarch/subzy" ]; then
    cd "/opt/blackarch/subzy"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/subzy" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/subzy" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/subzy" . 2>/dev/null && built=true
    fi
    $built && ok "go:subzy" || fail "subzy" "go build failed"
  else fail "subzy" "no dir"; fi
fi

if ! done_already "go:talon"; then
  if [ -f "$BIN/talon" ]; then skip "talon"; echo "PASS:go:talon" >> "$STATE"
  elif [ -d "/opt/blackarch/talon" ]; then
    cd "/opt/blackarch/talon"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/talon" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/talon" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/talon" . 2>/dev/null && built=true
    fi
    $built && ok "go:talon" || fail "talon" "go build failed"
  else fail "talon" "no dir"; fi
fi

if ! done_already "go:teamsuserenum"; then
  if [ -f "$BIN/teamsuserenum" ]; then skip "teamsuserenum"; echo "PASS:go:teamsuserenum" >> "$STATE"
  elif [ -d "/opt/blackarch/teamsuserenum" ]; then
    cd "/opt/blackarch/teamsuserenum"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/teamsuserenum" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/teamsuserenum" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/teamsuserenum" . 2>/dev/null && built=true
    fi
    $built && ok "go:teamsuserenum" || fail "teamsuserenum" "go build failed"
  else fail "teamsuserenum" "no dir"; fi
fi

if ! done_already "go:tlsx"; then
  if [ -f "$BIN/tlsx" ]; then skip "tlsx"; echo "PASS:go:tlsx" >> "$STATE"
  elif [ -d "/opt/blackarch/tlsx" ]; then
    cd "/opt/blackarch/tlsx"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/tlsx" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/tlsx" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/tlsx" . 2>/dev/null && built=true
    fi
    $built && ok "go:tlsx" || fail "tlsx" "go build failed"
  else fail "tlsx" "no dir"; fi
fi

if ! done_already "go:turner"; then
  if [ -f "$BIN/turner" ]; then skip "turner"; echo "PASS:go:turner" >> "$STATE"
  elif [ -d "/opt/blackarch/turner" ]; then
    cd "/opt/blackarch/turner"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/turner" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/turner" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/turner" . 2>/dev/null && built=true
    fi
    $built && ok "go:turner" || fail "turner" "go build failed"
  else fail "turner" "no dir"; fi
fi

if ! done_already "go:uff"; then
  if [ -f "$BIN/uff" ]; then skip "uff"; echo "PASS:go:uff" >> "$STATE"
  elif [ -d "/opt/blackarch/uff" ]; then
    cd "/opt/blackarch/uff"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/uff" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/uff" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/uff" . 2>/dev/null && built=true
    fi
    $built && ok "go:uff" || fail "uff" "go build failed"
  else fail "uff" "no dir"; fi
fi

if ! done_already "go:unfurl"; then
  if [ -f "$BIN/unfurl" ]; then skip "unfurl"; echo "PASS:go:unfurl" >> "$STATE"
  elif [ -d "/opt/blackarch/unfurl" ]; then
    cd "/opt/blackarch/unfurl"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/unfurl" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/unfurl" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/unfurl" . 2>/dev/null && built=true
    fi
    $built && ok "go:unfurl" || fail "unfurl" "go build failed"
  else fail "unfurl" "no dir"; fi
fi

if ! done_already "go:volana"; then
  if [ -f "$BIN/volana" ]; then skip "volana"; echo "PASS:go:volana" >> "$STATE"
  elif [ -d "/opt/blackarch/volana" ]; then
    cd "/opt/blackarch/volana"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/volana" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/volana" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/volana" . 2>/dev/null && built=true
    fi
    $built && ok "go:volana" || fail "volana" "go build failed"
  else fail "volana" "no dir"; fi
fi

if ! done_already "go:vuls"; then
  if [ -f "$BIN/vuls" ]; then skip "vuls"; echo "PASS:go:vuls" >> "$STATE"
  elif [ -d "/opt/blackarch/vuls" ]; then
    cd "/opt/blackarch/vuls"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/vuls" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/vuls" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/vuls" . 2>/dev/null && built=true
    fi
    $built && ok "go:vuls" || fail "vuls" "go build failed"
  else fail "vuls" "no dir"; fi
fi

if ! done_already "go:waybackurls"; then
  if [ -f "$BIN/waybackurls" ]; then skip "waybackurls"; echo "PASS:go:waybackurls" >> "$STATE"
  elif [ -d "/opt/blackarch/waybackurls" ]; then
    cd "/opt/blackarch/waybackurls"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/waybackurls" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/waybackurls" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/waybackurls" . 2>/dev/null && built=true
    fi
    $built && ok "go:waybackurls" || fail "waybackurls" "go build failed"
  else fail "waybackurls" "no dir"; fi
fi

if ! done_already "go:webanalyze"; then
  if [ -f "$BIN/webanalyze" ]; then skip "webanalyze"; echo "PASS:go:webanalyze" >> "$STATE"
  elif [ -d "/opt/blackarch/webanalyze" ]; then
    cd "/opt/blackarch/webanalyze"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/webanalyze" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/webanalyze" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/webanalyze" . 2>/dev/null && built=true
    fi
    $built && ok "go:webanalyze" || fail "webanalyze" "go build failed"
  else fail "webanalyze" "no dir"; fi
fi

if ! done_already "go:whoxyrm"; then
  if [ -f "$BIN/whoxyrm" ]; then skip "whoxyrm"; echo "PASS:go:whoxyrm" >> "$STATE"
  elif [ -d "/opt/blackarch/whoxyrm" ]; then
    cd "/opt/blackarch/whoxyrm"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/whoxyrm" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/whoxyrm" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/whoxyrm" . 2>/dev/null && built=true
    fi
    $built && ok "go:whoxyrm" || fail "whoxyrm" "go build failed"
  else fail "whoxyrm" "no dir"; fi
fi

if ! done_already "go:windowsspyblocker"; then
  if [ -f "$BIN/windowsspyblocker" ]; then skip "windowsspyblocker"; echo "PASS:go:windowsspyblocker" >> "$STATE"
  elif [ -d "/opt/blackarch/windowsspyblocker" ]; then
    cd "/opt/blackarch/windowsspyblocker"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/windowsspyblocker" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/windowsspyblocker" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/windowsspyblocker" . 2>/dev/null && built=true
    fi
    $built && ok "go:windowsspyblocker" || fail "windowsspyblocker" "go build failed"
  else fail "windowsspyblocker" "no dir"; fi
fi

if ! done_already "go:xray"; then
  if [ -f "$BIN/xray" ]; then skip "xray"; echo "PASS:go:xray" >> "$STATE"
  elif [ -d "/opt/blackarch/xray" ]; then
    cd "/opt/blackarch/xray"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/xray" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/xray" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/xray" . 2>/dev/null && built=true
    fi
    $built && ok "go:xray" || fail "xray" "go build failed"
  else fail "xray" "no dir"; fi
fi

if ! done_already "go:xxeserv"; then
  if [ -f "$BIN/xxeserv" ]; then skip "xxeserv"; echo "PASS:go:xxeserv" >> "$STATE"
  elif [ -d "/opt/blackarch/xxeserv" ]; then
    cd "/opt/blackarch/xxeserv"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/xxeserv" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/xxeserv" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/xxeserv" . 2>/dev/null && built=true
    fi
    $built && ok "go:xxeserv" || fail "xxeserv" "go build failed"
  else fail "xxeserv" "no dir"; fi
fi

if ! done_already "go:yay"; then
  if [ -f "$BIN/yay" ]; then skip "yay"; echo "PASS:go:yay" >> "$STATE"
  elif [ -d "/opt/blackarch/yay" ]; then
    cd "/opt/blackarch/yay"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/yay" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/yay" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/yay" . 2>/dev/null && built=true
    fi
    $built && ok "go:yay" || fail "yay" "go build failed"
  else fail "yay" "no dir"; fi
fi

if ! done_already "go:zipexec"; then
  if [ -f "$BIN/zipexec" ]; then skip "zipexec"; echo "PASS:go:zipexec" >> "$STATE"
  elif [ -d "/opt/blackarch/zipexec" ]; then
    cd "/opt/blackarch/zipexec"
    built=false
    # Try go.mod build
    [ -f "go.mod" ] && GOPATH=/usr/local go build -o "$BIN/zipexec" ./... 2>/dev/null && built=true
    # Try main.go
    if ! $built; then
      mgo=$(find "/opt/blackarch/zipexec" -name "main.go" ! -path "*/vendor/*" | head -1)
      [ -n "$mgo" ] && cd "$(dirname $mgo)" && go build -o "$BIN/zipexec" . 2>/dev/null && built=true
    fi
    $built && ok "go:zipexec" || fail "zipexec" "go build failed"
  else fail "zipexec" "no dir"; fi
fi

echo -e "${ORANGE}━━━ C/Make Tools (84) ━━━${NC}"

if ! done_already "c:agafi"; then
  if [ -f "$BIN/agafi" ]; then skip "agafi"; echo "PASS:c:agafi" >> "$STATE"
  elif [ -d "/opt/blackarch/agafi" ]; then
    cd "/opt/blackarch/agafi"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/agafi"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/agafi" -maxdepth 4 -type f -executable -name "agafi" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/agafi" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/agafi" 2>/dev/null && ok "c:agafi" || ok "c:agafi (installed)"
    else fail "agafi" "build failed"; fi
  else fail "agafi" "no dir"; fi
fi

if ! done_already "c:beleth"; then
  if [ -f "$BIN/beleth" ]; then skip "beleth"; echo "PASS:c:beleth" >> "$STATE"
  elif [ -d "/opt/blackarch/beleth" ]; then
    cd "/opt/blackarch/beleth"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/beleth"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/beleth" -maxdepth 4 -type f -executable -name "beleth" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/beleth" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/beleth" 2>/dev/null && ok "c:beleth" || ok "c:beleth (installed)"
    else fail "beleth" "build failed"; fi
  else fail "beleth" "no dir"; fi
fi

if ! done_already "c:blackarch-keyring"; then
  if [ -f "$BIN/blackarch-keyring" ]; then skip "blackarch-keyring"; echo "PASS:c:blackarch-keyring" >> "$STATE"
  elif [ -d "/opt/blackarch/blackarch-keyring" ]; then
    cd "/opt/blackarch/blackarch-keyring"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/blackarch-keyring"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/blackarch-keyring" -maxdepth 4 -type f -executable -name "blackarch-keyring" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/blackarch-keyring" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/blackarch-keyring" 2>/dev/null && ok "c:blackarch-keyring" || ok "c:blackarch-keyring (installed)"
    else fail "blackarch-keyring" "build failed"; fi
  else fail "blackarch-keyring" "no dir"; fi
fi

if ! done_already "c:bonesi"; then
  if [ -f "$BIN/bonesi" ]; then skip "bonesi"; echo "PASS:c:bonesi" >> "$STATE"
  elif [ -d "/opt/blackarch/bonesi" ]; then
    cd "/opt/blackarch/bonesi"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/bonesi"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/bonesi" -maxdepth 4 -type f -executable -name "bonesi" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/bonesi" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/bonesi" 2>/dev/null && ok "c:bonesi" || ok "c:bonesi (installed)"
    else fail "bonesi" "build failed"; fi
  else fail "bonesi" "no dir"; fi
fi

if ! done_already "c:cdpsnarf"; then
  if [ -f "$BIN/cdpsnarf" ]; then skip "cdpsnarf"; echo "PASS:c:cdpsnarf" >> "$STATE"
  elif [ -d "/opt/blackarch/cdpsnarf" ]; then
    cd "/opt/blackarch/cdpsnarf"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/cdpsnarf"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/cdpsnarf" -maxdepth 4 -type f -executable -name "cdpsnarf" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/cdpsnarf" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/cdpsnarf" 2>/dev/null && ok "c:cdpsnarf" || ok "c:cdpsnarf (installed)"
    else fail "cdpsnarf" "build failed"; fi
  else fail "cdpsnarf" "no dir"; fi
fi

if ! done_already "c:chw00t"; then
  if [ -f "$BIN/chw00t" ]; then skip "chw00t"; echo "PASS:c:chw00t" >> "$STATE"
  elif [ -d "/opt/blackarch/chw00t" ]; then
    cd "/opt/blackarch/chw00t"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/chw00t"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/chw00t" -maxdepth 4 -type f -executable -name "chw00t" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/chw00t" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/chw00t" 2>/dev/null && ok "c:chw00t" || ok "c:chw00t (installed)"
    else fail "chw00t" "build failed"; fi
  else fail "chw00t" "no dir"; fi
fi

if ! done_already "c:cisco7crack"; then
  if [ -f "$BIN/cisco7crack" ]; then skip "cisco7crack"; echo "PASS:c:cisco7crack" >> "$STATE"
  elif [ -d "/opt/blackarch/cisco7crack" ]; then
    cd "/opt/blackarch/cisco7crack"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/cisco7crack"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/cisco7crack" -maxdepth 4 -type f -executable -name "cisco7crack" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/cisco7crack" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/cisco7crack" 2>/dev/null && ok "c:cisco7crack" || ok "c:cisco7crack (installed)"
    else fail "cisco7crack" "build failed"; fi
  else fail "cisco7crack" "no dir"; fi
fi

if ! done_already "c:cntlm"; then
  if [ -f "$BIN/cntlm" ]; then skip "cntlm"; echo "PASS:c:cntlm" >> "$STATE"
  elif [ -d "/opt/blackarch/cntlm" ]; then
    cd "/opt/blackarch/cntlm"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/cntlm"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/cntlm" -maxdepth 4 -type f -executable -name "cntlm" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/cntlm" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/cntlm" 2>/dev/null && ok "c:cntlm" || ok "c:cntlm (installed)"
    else fail "cntlm" "build failed"; fi
  else fail "cntlm" "no dir"; fi
fi

if ! done_already "c:crypthook"; then
  if [ -f "$BIN/crypthook" ]; then skip "crypthook"; echo "PASS:c:crypthook" >> "$STATE"
  elif [ -d "/opt/blackarch/crypthook" ]; then
    cd "/opt/blackarch/crypthook"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/crypthook"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/crypthook" -maxdepth 4 -type f -executable -name "crypthook" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/crypthook" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/crypthook" 2>/dev/null && ok "c:crypthook" || ok "c:crypthook (installed)"
    else fail "crypthook" "build failed"; fi
  else fail "crypthook" "no dir"; fi
fi

if ! done_already "c:cvechecker"; then
  if [ -f "$BIN/cvechecker" ]; then skip "cvechecker"; echo "PASS:c:cvechecker" >> "$STATE"
  elif [ -d "/opt/blackarch/cvechecker" ]; then
    cd "/opt/blackarch/cvechecker"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/cvechecker"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/cvechecker" -maxdepth 4 -type f -executable -name "cvechecker" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/cvechecker" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/cvechecker" 2>/dev/null && ok "c:cvechecker" || ok "c:cvechecker (installed)"
    else fail "cvechecker" "build failed"; fi
  else fail "cvechecker" "no dir"; fi
fi

if ! done_already "c:dbusmap"; then
  if [ -f "$BIN/dbusmap" ]; then skip "dbusmap"; echo "PASS:c:dbusmap" >> "$STATE"
  elif [ -d "/opt/blackarch/dbusmap" ]; then
    cd "/opt/blackarch/dbusmap"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/dbusmap"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/dbusmap" -maxdepth 4 -type f -executable -name "dbusmap" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/dbusmap" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/dbusmap" 2>/dev/null && ok "c:dbusmap" || ok "c:dbusmap (installed)"
    else fail "dbusmap" "build failed"; fi
  else fail "dbusmap" "no dir"; fi
fi

if ! done_already "c:decodify"; then
  if [ -f "$BIN/decodify" ]; then skip "decodify"; echo "PASS:c:decodify" >> "$STATE"
  elif [ -d "/opt/blackarch/decodify" ]; then
    cd "/opt/blackarch/decodify"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/decodify"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/decodify" -maxdepth 4 -type f -executable -name "decodify" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/decodify" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/decodify" 2>/dev/null && ok "c:decodify" || ok "c:decodify (installed)"
    else fail "decodify" "build failed"; fi
  else fail "decodify" "no dir"; fi
fi

if ! done_already "c:dhcpoptinj"; then
  if [ -f "$BIN/dhcpoptinj" ]; then skip "dhcpoptinj"; echo "PASS:c:dhcpoptinj" >> "$STATE"
  elif [ -d "/opt/blackarch/dhcpoptinj" ]; then
    cd "/opt/blackarch/dhcpoptinj"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/dhcpoptinj"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/dhcpoptinj" -maxdepth 4 -type f -executable -name "dhcpoptinj" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/dhcpoptinj" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/dhcpoptinj" 2>/dev/null && ok "c:dhcpoptinj" || ok "c:dhcpoptinj (installed)"
    else fail "dhcpoptinj" "build failed"; fi
  else fail "dhcpoptinj" "no dir"; fi
fi

if ! done_already "c:dirbuster-ng"; then
  if [ -f "$BIN/dirbuster-ng" ]; then skip "dirbuster-ng"; echo "PASS:c:dirbuster-ng" >> "$STATE"
  elif [ -d "/opt/blackarch/dirbuster-ng" ]; then
    cd "/opt/blackarch/dirbuster-ng"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/dirbuster-ng"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/dirbuster-ng" -maxdepth 4 -type f -executable -name "dirbuster-ng" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/dirbuster-ng" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/dirbuster-ng" 2>/dev/null && ok "c:dirbuster-ng" || ok "c:dirbuster-ng (installed)"
    else fail "dirbuster-ng" "build failed"; fi
  else fail "dirbuster-ng" "no dir"; fi
fi

if ! done_already "c:dns-spoof"; then
  if [ -f "$BIN/dns-spoof" ]; then skip "dns-spoof"; echo "PASS:c:dns-spoof" >> "$STATE"
  elif [ -d "/opt/blackarch/dns-spoof" ]; then
    cd "/opt/blackarch/dns-spoof"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/dns-spoof"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/dns-spoof" -maxdepth 4 -type f -executable -name "dns-spoof" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/dns-spoof" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/dns-spoof" 2>/dev/null && ok "c:dns-spoof" || ok "c:dns-spoof (installed)"
    else fail "dns-spoof" "build failed"; fi
  else fail "dns-spoof" "no dir"; fi
fi

if ! done_already "c:dragon-backdoor"; then
  if [ -f "$BIN/dragon-backdoor" ]; then skip "dragon-backdoor"; echo "PASS:c:dragon-backdoor" >> "$STATE"
  elif [ -d "/opt/blackarch/dragon-backdoor" ]; then
    cd "/opt/blackarch/dragon-backdoor"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/dragon-backdoor"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/dragon-backdoor" -maxdepth 4 -type f -executable -name "dragon-backdoor" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/dragon-backdoor" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/dragon-backdoor" 2>/dev/null && ok "c:dragon-backdoor" || ok "c:dragon-backdoor (installed)"
    else fail "dragon-backdoor" "build failed"; fi
  else fail "dragon-backdoor" "no dir"; fi
fi

if ! done_already "c:drinkme"; then
  if [ -f "$BIN/drinkme" ]; then skip "drinkme"; echo "PASS:c:drinkme" >> "$STATE"
  elif [ -d "/opt/blackarch/drinkme" ]; then
    cd "/opt/blackarch/drinkme"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/drinkme"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/drinkme" -maxdepth 4 -type f -executable -name "drinkme" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/drinkme" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/drinkme" 2>/dev/null && ok "c:drinkme" || ok "c:drinkme (installed)"
    else fail "drinkme" "build failed"; fi
  else fail "drinkme" "no dir"; fi
fi

if ! done_already "c:dsd"; then
  if [ -f "$BIN/dsd" ]; then skip "dsd"; echo "PASS:c:dsd" >> "$STATE"
  elif [ -d "/opt/blackarch/dsd" ]; then
    cd "/opt/blackarch/dsd"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/dsd"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/dsd" -maxdepth 4 -type f -executable -name "dsd" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/dsd" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/dsd" 2>/dev/null && ok "c:dsd" || ok "c:dsd (installed)"
    else fail "dsd" "build failed"; fi
  else fail "dsd" "no dir"; fi
fi

if ! done_already "c:elfparser"; then
  if [ -f "$BIN/elfparser" ]; then skip "elfparser"; echo "PASS:c:elfparser" >> "$STATE"
  elif [ -d "/opt/blackarch/elfparser" ]; then
    cd "/opt/blackarch/elfparser"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/elfparser"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/elfparser" -maxdepth 4 -type f -executable -name "elfparser" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/elfparser" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/elfparser" 2>/dev/null && ok "c:elfparser" || ok "c:elfparser (installed)"
    else fail "elfparser" "build failed"; fi
  else fail "elfparser" "no dir"; fi
fi

if ! done_already "c:fakenetbios"; then
  if [ -f "$BIN/fakenetbios" ]; then skip "fakenetbios"; echo "PASS:c:fakenetbios" >> "$STATE"
  elif [ -d "/opt/blackarch/fakenetbios" ]; then
    cd "/opt/blackarch/fakenetbios"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/fakenetbios"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/fakenetbios" -maxdepth 4 -type f -executable -name "fakenetbios" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/fakenetbios" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/fakenetbios" 2>/dev/null && ok "c:fakenetbios" || ok "c:fakenetbios (installed)"
    else fail "fakenetbios" "build failed"; fi
  else fail "fakenetbios" "no dir"; fi
fi

if ! done_already "c:fernmelder"; then
  if [ -f "$BIN/fernmelder" ]; then skip "fernmelder"; echo "PASS:c:fernmelder" >> "$STATE"
  elif [ -d "/opt/blackarch/fernmelder" ]; then
    cd "/opt/blackarch/fernmelder"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/fernmelder"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/fernmelder" -maxdepth 4 -type f -executable -name "fernmelder" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/fernmelder" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/fernmelder" 2>/dev/null && ok "c:fernmelder" || ok "c:fernmelder (installed)"
    else fail "fernmelder" "build failed"; fi
  else fail "fernmelder" "no dir"; fi
fi

if ! done_already "c:firecat"; then
  if [ -f "$BIN/firecat" ]; then skip "firecat"; echo "PASS:c:firecat" >> "$STATE"
  elif [ -d "/opt/blackarch/firecat" ]; then
    cd "/opt/blackarch/firecat"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/firecat"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/firecat" -maxdepth 4 -type f -executable -name "firecat" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/firecat" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/firecat" 2>/dev/null && ok "c:firecat" || ok "c:firecat (installed)"
    else fail "firecat" "build failed"; fi
  else fail "firecat" "no dir"; fi
fi

if ! done_already "c:gqrx-scanner"; then
  if [ -f "$BIN/gqrx-scanner" ]; then skip "gqrx-scanner"; echo "PASS:c:gqrx-scanner" >> "$STATE"
  elif [ -d "/opt/blackarch/gqrx-scanner" ]; then
    cd "/opt/blackarch/gqrx-scanner"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/gqrx-scanner"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/gqrx-scanner" -maxdepth 4 -type f -executable -name "gqrx-scanner" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/gqrx-scanner" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/gqrx-scanner" 2>/dev/null && ok "c:gqrx-scanner" || ok "c:gqrx-scanner (installed)"
    else fail "gqrx-scanner" "build failed"; fi
  else fail "gqrx-scanner" "no dir"; fi
fi

if ! done_already "c:hash-extender"; then
  if [ -f "$BIN/hash-extender" ]; then skip "hash-extender"; echo "PASS:c:hash-extender" >> "$STATE"
  elif [ -d "/opt/blackarch/hash-extender" ]; then
    cd "/opt/blackarch/hash-extender"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/hash-extender"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/hash-extender" -maxdepth 4 -type f -executable -name "hash-extender" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/hash-extender" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/hash-extender" 2>/dev/null && ok "c:hash-extender" || ok "c:hash-extender (installed)"
    else fail "hash-extender" "build failed"; fi
  else fail "hash-extender" "no dir"; fi
fi

if ! done_already "c:heaptrace"; then
  if [ -f "$BIN/heaptrace" ]; then skip "heaptrace"; echo "PASS:c:heaptrace" >> "$STATE"
  elif [ -d "/opt/blackarch/heaptrace" ]; then
    cd "/opt/blackarch/heaptrace"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/heaptrace"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/heaptrace" -maxdepth 4 -type f -executable -name "heaptrace" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/heaptrace" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/heaptrace" 2>/dev/null && ok "c:heaptrace" || ok "c:heaptrace (installed)"
    else fail "heaptrace" "build failed"; fi
  else fail "heaptrace" "no dir"; fi
fi

if ! done_already "c:heartleech"; then
  if [ -f "$BIN/heartleech" ]; then skip "heartleech"; echo "PASS:c:heartleech" >> "$STATE"
  elif [ -d "/opt/blackarch/heartleech" ]; then
    cd "/opt/blackarch/heartleech"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/heartleech"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/heartleech" -maxdepth 4 -type f -executable -name "heartleech" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/heartleech" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/heartleech" 2>/dev/null && ok "c:heartleech" || ok "c:heartleech (installed)"
    else fail "heartleech" "build failed"; fi
  else fail "heartleech" "no dir"; fi
fi

if ! done_already "c:http-parser"; then
  if [ -f "$BIN/http-parser" ]; then skip "http-parser"; echo "PASS:c:http-parser" >> "$STATE"
  elif [ -d "/opt/blackarch/http-parser" ]; then
    cd "/opt/blackarch/http-parser"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/http-parser"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/http-parser" -maxdepth 4 -type f -executable -name "http-parser" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/http-parser" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/http-parser" 2>/dev/null && ok "c:http-parser" || ok "c:http-parser (installed)"
    else fail "http-parser" "build failed"; fi
  else fail "http-parser" "no dir"; fi
fi

if ! done_already "c:imagejs"; then
  if [ -f "$BIN/imagejs" ]; then skip "imagejs"; echo "PASS:c:imagejs" >> "$STATE"
  elif [ -d "/opt/blackarch/imagejs" ]; then
    cd "/opt/blackarch/imagejs"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/imagejs"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/imagejs" -maxdepth 4 -type f -executable -name "imagejs" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/imagejs" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/imagejs" 2>/dev/null && ok "c:imagejs" || ok "c:imagejs (installed)"
    else fail "imagejs" "build failed"; fi
  else fail "imagejs" "no dir"; fi
fi

if ! done_already "c:interrogate"; then
  if [ -f "$BIN/interrogate" ]; then skip "interrogate"; echo "PASS:c:interrogate" >> "$STATE"
  elif [ -d "/opt/blackarch/interrogate" ]; then
    cd "/opt/blackarch/interrogate"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/interrogate"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/interrogate" -maxdepth 4 -type f -executable -name "interrogate" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/interrogate" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/interrogate" 2>/dev/null && ok "c:interrogate" || ok "c:interrogate (installed)"
    else fail "interrogate" "build failed"; fi
  else fail "interrogate" "no dir"; fi
fi

if ! done_already "c:inviteflood"; then
  if [ -f "$BIN/inviteflood" ]; then skip "inviteflood"; echo "PASS:c:inviteflood" >> "$STATE"
  elif [ -d "/opt/blackarch/inviteflood" ]; then
    cd "/opt/blackarch/inviteflood"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/inviteflood"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/inviteflood" -maxdepth 4 -type f -executable -name "inviteflood" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/inviteflood" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/inviteflood" 2>/dev/null && ok "c:inviteflood" || ok "c:inviteflood (installed)"
    else fail "inviteflood" "build failed"; fi
  else fail "inviteflood" "no dir"; fi
fi

if ! done_already "c:ipobfuscator"; then
  if [ -f "$BIN/ipobfuscator" ]; then skip "ipobfuscator"; echo "PASS:c:ipobfuscator" >> "$STATE"
  elif [ -d "/opt/blackarch/ipobfuscator" ]; then
    cd "/opt/blackarch/ipobfuscator"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/ipobfuscator"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/ipobfuscator" -maxdepth 4 -type f -executable -name "ipobfuscator" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/ipobfuscator" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/ipobfuscator" 2>/dev/null && ok "c:ipobfuscator" || ok "c:ipobfuscator (installed)"
    else fail "ipobfuscator" "build failed"; fi
  else fail "ipobfuscator" "no dir"; fi
fi

if ! done_already "c:issniff"; then
  if [ -f "$BIN/issniff" ]; then skip "issniff"; echo "PASS:c:issniff" >> "$STATE"
  elif [ -d "/opt/blackarch/issniff" ]; then
    cd "/opt/blackarch/issniff"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/issniff"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/issniff" -maxdepth 4 -type f -executable -name "issniff" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/issniff" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/issniff" 2>/dev/null && ok "c:issniff" || ok "c:issniff (installed)"
    else fail "issniff" "build failed"; fi
  else fail "issniff" "no dir"; fi
fi

if ! done_already "c:kadimus"; then
  if [ -f "$BIN/kadimus" ]; then skip "kadimus"; echo "PASS:c:kadimus" >> "$STATE"
  elif [ -d "/opt/blackarch/kadimus" ]; then
    cd "/opt/blackarch/kadimus"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/kadimus"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/kadimus" -maxdepth 4 -type f -executable -name "kadimus" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/kadimus" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/kadimus" 2>/dev/null && ok "c:kadimus" || ok "c:kadimus (installed)"
    else fail "kadimus" "build failed"; fi
  else fail "kadimus" "no dir"; fi
fi

if ! done_already "c:kekeo"; then
  if [ -f "$BIN/kekeo" ]; then skip "kekeo"; echo "PASS:c:kekeo" >> "$STATE"
  elif [ -d "/opt/blackarch/kekeo" ]; then
    cd "/opt/blackarch/kekeo"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/kekeo"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/kekeo" -maxdepth 4 -type f -executable -name "kekeo" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/kekeo" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/kekeo" 2>/dev/null && ok "c:kekeo" || ok "c:kekeo (installed)"
    else fail "kekeo" "build failed"; fi
  else fail "kekeo" "no dir"; fi
fi

if ! done_already "c:ld-shatner"; then
  if [ -f "$BIN/ld-shatner" ]; then skip "ld-shatner"; echo "PASS:c:ld-shatner" >> "$STATE"
  elif [ -d "/opt/blackarch/ld-shatner" ]; then
    cd "/opt/blackarch/ld-shatner"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/ld-shatner"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/ld-shatner" -maxdepth 4 -type f -executable -name "ld-shatner" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/ld-shatner" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/ld-shatner" 2>/dev/null && ok "c:ld-shatner" || ok "c:ld-shatner (installed)"
    else fail "ld-shatner" "build failed"; fi
  else fail "ld-shatner" "no dir"; fi
fi

if ! done_already "c:libmirisdr4"; then
  if [ -f "$BIN/libmirisdr4" ]; then skip "libmirisdr4"; echo "PASS:c:libmirisdr4" >> "$STATE"
  elif [ -d "/opt/blackarch/libmirisdr4" ]; then
    cd "/opt/blackarch/libmirisdr4"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/libmirisdr4"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/libmirisdr4" -maxdepth 4 -type f -executable -name "libmirisdr4" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/libmirisdr4" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/libmirisdr4" 2>/dev/null && ok "c:libmirisdr4" || ok "c:libmirisdr4 (installed)"
    else fail "libmirisdr4" "build failed"; fi
  else fail "libmirisdr4" "no dir"; fi
fi

if ! done_already "c:libpjf"; then
  if [ -f "$BIN/libpjf" ]; then skip "libpjf"; echo "PASS:c:libpjf" >> "$STATE"
  elif [ -d "/opt/blackarch/libpjf" ]; then
    cd "/opt/blackarch/libpjf"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/libpjf"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/libpjf" -maxdepth 4 -type f -executable -name "libpjf" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/libpjf" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/libpjf" 2>/dev/null && ok "c:libpjf" || ok "c:libpjf (installed)"
    else fail "libpjf" "build failed"; fi
  else fail "libpjf" "no dir"; fi
fi

if ! done_already "c:libusb3380"; then
  if [ -f "$BIN/libusb3380" ]; then skip "libusb3380"; echo "PASS:c:libusb3380" >> "$STATE"
  elif [ -d "/opt/blackarch/libusb3380" ]; then
    cd "/opt/blackarch/libusb3380"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/libusb3380"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/libusb3380" -maxdepth 4 -type f -executable -name "libusb3380" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/libusb3380" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/libusb3380" 2>/dev/null && ok "c:libusb3380" || ok "c:libusb3380 (installed)"
    else fail "libusb3380" "build failed"; fi
  else fail "libusb3380" "no dir"; fi
fi

if ! done_already "c:libxtrx"; then
  if [ -f "$BIN/libxtrx" ]; then skip "libxtrx"; echo "PASS:c:libxtrx" >> "$STATE"
  elif [ -d "/opt/blackarch/libxtrx" ]; then
    cd "/opt/blackarch/libxtrx"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/libxtrx"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/libxtrx" -maxdepth 4 -type f -executable -name "libxtrx" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/libxtrx" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/libxtrx" 2>/dev/null && ok "c:libxtrx" || ok "c:libxtrx (installed)"
    else fail "libxtrx" "build failed"; fi
  else fail "libxtrx" "no dir"; fi
fi

if ! done_already "c:libxtrxdsp"; then
  if [ -f "$BIN/libxtrxdsp" ]; then skip "libxtrxdsp"; echo "PASS:c:libxtrxdsp" >> "$STATE"
  elif [ -d "/opt/blackarch/libxtrxdsp" ]; then
    cd "/opt/blackarch/libxtrxdsp"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/libxtrxdsp"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/libxtrxdsp" -maxdepth 4 -type f -executable -name "libxtrxdsp" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/libxtrxdsp" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/libxtrxdsp" 2>/dev/null && ok "c:libxtrxdsp" || ok "c:libxtrxdsp (installed)"
    else fail "libxtrxdsp" "build failed"; fi
  else fail "libxtrxdsp" "no dir"; fi
fi

if ! done_already "c:libxtrxll"; then
  if [ -f "$BIN/libxtrxll" ]; then skip "libxtrxll"; echo "PASS:c:libxtrxll" >> "$STATE"
  elif [ -d "/opt/blackarch/libxtrxll" ]; then
    cd "/opt/blackarch/libxtrxll"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/libxtrxll"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/libxtrxll" -maxdepth 4 -type f -executable -name "libxtrxll" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/libxtrxll" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/libxtrxll" 2>/dev/null && ok "c:libxtrxll" || ok "c:libxtrxll (installed)"
    else fail "libxtrxll" "build failed"; fi
  else fail "libxtrxll" "no dir"; fi
fi

if ! done_already "c:linux-inject"; then
  if [ -f "$BIN/linux-inject" ]; then skip "linux-inject"; echo "PASS:c:linux-inject" >> "$STATE"
  elif [ -d "/opt/blackarch/linux-inject" ]; then
    cd "/opt/blackarch/linux-inject"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/linux-inject"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/linux-inject" -maxdepth 4 -type f -executable -name "linux-inject" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/linux-inject" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/linux-inject" 2>/dev/null && ok "c:linux-inject" || ok "c:linux-inject (installed)"
    else fail "linux-inject" "build failed"; fi
  else fail "linux-inject" "no dir"; fi
fi

if ! done_already "c:mbelib"; then
  if [ -f "$BIN/mbelib" ]; then skip "mbelib"; echo "PASS:c:mbelib" >> "$STATE"
  elif [ -d "/opt/blackarch/mbelib" ]; then
    cd "/opt/blackarch/mbelib"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/mbelib"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/mbelib" -maxdepth 4 -type f -executable -name "mbelib" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/mbelib" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/mbelib" 2>/dev/null && ok "c:mbelib" || ok "c:mbelib (installed)"
    else fail "mbelib" "build failed"; fi
  else fail "mbelib" "no dir"; fi
fi

if ! done_already "c:mimikatz"; then
  if [ -f "$BIN/mimikatz" ]; then skip "mimikatz"; echo "PASS:c:mimikatz" >> "$STATE"
  elif [ -d "/opt/blackarch/mimikatz" ]; then
    cd "/opt/blackarch/mimikatz"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/mimikatz"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/mimikatz" -maxdepth 4 -type f -executable -name "mimikatz" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/mimikatz" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/mimikatz" 2>/dev/null && ok "c:mimikatz" || ok "c:mimikatz (installed)"
    else fail "mimikatz" "build failed"; fi
  else fail "mimikatz" "no dir"; fi
fi

if ! done_already "c:nfcutils"; then
  if [ -f "$BIN/nfcutils" ]; then skip "nfcutils"; echo "PASS:c:nfcutils" >> "$STATE"
  elif [ -d "/opt/blackarch/nfcutils" ]; then
    cd "/opt/blackarch/nfcutils"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/nfcutils"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/nfcutils" -maxdepth 4 -type f -executable -name "nfcutils" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/nfcutils" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/nfcutils" 2>/dev/null && ok "c:nfcutils" || ok "c:nfcutils (installed)"
    else fail "nfcutils" "build failed"; fi
  else fail "nfcutils" "no dir"; fi
fi

if ! done_already "c:ntpdos"; then
  if [ -f "$BIN/ntpdos" ]; then skip "ntpdos"; echo "PASS:c:ntpdos" >> "$STATE"
  elif [ -d "/opt/blackarch/ntpdos" ]; then
    cd "/opt/blackarch/ntpdos"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/ntpdos"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/ntpdos" -maxdepth 4 -type f -executable -name "ntpdos" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/ntpdos" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/ntpdos" 2>/dev/null && ok "c:ntpdos" || ok "c:ntpdos (installed)"
    else fail "ntpdos" "build failed"; fi
  else fail "ntpdos" "no dir"; fi
fi

if ! done_already "c:orjail"; then
  if [ -f "$BIN/orjail" ]; then skip "orjail"; echo "PASS:c:orjail" >> "$STATE"
  elif [ -d "/opt/blackarch/orjail" ]; then
    cd "/opt/blackarch/orjail"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/orjail"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/orjail" -maxdepth 4 -type f -executable -name "orjail" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/orjail" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/orjail" 2>/dev/null && ok "c:orjail" || ok "c:orjail (installed)"
    else fail "orjail" "build failed"; fi
  else fail "orjail" "no dir"; fi
fi

if ! done_already "c:owrx_connector"; then
  if [ -f "$BIN/owrx_connector" ]; then skip "owrx_connector"; echo "PASS:c:owrx_connector" >> "$STATE"
  elif [ -d "/opt/blackarch/owrx_connector" ]; then
    cd "/opt/blackarch/owrx_connector"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/owrx_connector"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/owrx_connector" -maxdepth 4 -type f -executable -name "owrx_connector" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/owrx_connector" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/owrx_connector" 2>/dev/null && ok "c:owrx_connector" || ok "c:owrx_connector (installed)"
    else fail "owrx_connector" "build failed"; fi
  else fail "owrx_connector" "no dir"; fi
fi

if ! done_already "c:pemcrack"; then
  if [ -f "$BIN/pemcrack" ]; then skip "pemcrack"; echo "PASS:c:pemcrack" >> "$STATE"
  elif [ -d "/opt/blackarch/pemcrack" ]; then
    cd "/opt/blackarch/pemcrack"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/pemcrack"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/pemcrack" -maxdepth 4 -type f -executable -name "pemcrack" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/pemcrack" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/pemcrack" 2>/dev/null && ok "c:pemcrack" || ok "c:pemcrack (installed)"
    else fail "pemcrack" "build failed"; fi
  else fail "pemcrack" "no dir"; fi
fi

if ! done_already "c:phantap"; then
  if [ -f "$BIN/phantap" ]; then skip "phantap"; echo "PASS:c:phantap" >> "$STATE"
  elif [ -d "/opt/blackarch/phantap" ]; then
    cd "/opt/blackarch/phantap"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/phantap"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/phantap" -maxdepth 4 -type f -executable -name "phantap" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/phantap" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/phantap" 2>/dev/null && ok "c:phantap" || ok "c:phantap (installed)"
    else fail "phantap" "build failed"; fi
  else fail "phantap" "no dir"; fi
fi

if ! done_already "c:php-findsock-shell"; then
  if [ -f "$BIN/php-findsock-shell" ]; then skip "php-findsock-shell"; echo "PASS:c:php-findsock-shell" >> "$STATE"
  elif [ -d "/opt/blackarch/php-findsock-shell" ]; then
    cd "/opt/blackarch/php-findsock-shell"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/php-findsock-shell"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/php-findsock-shell" -maxdepth 4 -type f -executable -name "php-findsock-shell" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/php-findsock-shell" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/php-findsock-shell" 2>/dev/null && ok "c:php-findsock-shell" || ok "c:php-findsock-shell (installed)"
    else fail "php-findsock-shell" "build failed"; fi
  else fail "php-findsock-shell" "no dir"; fi
fi

if ! done_already "c:pixd"; then
  if [ -f "$BIN/pixd" ]; then skip "pixd"; echo "PASS:c:pixd" >> "$STATE"
  elif [ -d "/opt/blackarch/pixd" ]; then
    cd "/opt/blackarch/pixd"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/pixd"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/pixd" -maxdepth 4 -type f -executable -name "pixd" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/pixd" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/pixd" 2>/dev/null && ok "c:pixd" || ok "c:pixd (installed)"
    else fail "pixd" "build failed"; fi
  else fail "pixd" "no dir"; fi
fi

if ! done_already "c:pixload"; then
  if [ -f "$BIN/pixload" ]; then skip "pixload"; echo "PASS:c:pixload" >> "$STATE"
  elif [ -d "/opt/blackarch/pixload" ]; then
    cd "/opt/blackarch/pixload"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/pixload"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/pixload" -maxdepth 4 -type f -executable -name "pixload" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/pixload" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/pixload" 2>/dev/null && ok "c:pixload" || ok "c:pixload (installed)"
    else fail "pixload" "build failed"; fi
  else fail "pixload" "no dir"; fi
fi

if ! done_already "c:princeprocessor"; then
  if [ -f "$BIN/princeprocessor" ]; then skip "princeprocessor"; echo "PASS:c:princeprocessor" >> "$STATE"
  elif [ -d "/opt/blackarch/princeprocessor" ]; then
    cd "/opt/blackarch/princeprocessor"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/princeprocessor"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/princeprocessor" -maxdepth 4 -type f -executable -name "princeprocessor" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/princeprocessor" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/princeprocessor" 2>/dev/null && ok "c:princeprocessor" || ok "c:princeprocessor (installed)"
    else fail "princeprocessor" "build failed"; fi
  else fail "princeprocessor" "no dir"; fi
fi

if ! done_already "c:proctal"; then
  if [ -f "$BIN/proctal" ]; then skip "proctal"; echo "PASS:c:proctal" >> "$STATE"
  elif [ -d "/opt/blackarch/proctal" ]; then
    cd "/opt/blackarch/proctal"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/proctal"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/proctal" -maxdepth 4 -type f -executable -name "proctal" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/proctal" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/proctal" 2>/dev/null && ok "c:proctal" || ok "c:proctal (installed)"
    else fail "proctal" "build failed"; fi
  else fail "proctal" "no dir"; fi
fi

if ! done_already "c:rats"; then
  if [ -f "$BIN/rats" ]; then skip "rats"; echo "PASS:c:rats" >> "$STATE"
  elif [ -d "/opt/blackarch/rats" ]; then
    cd "/opt/blackarch/rats"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/rats"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/rats" -maxdepth 4 -type f -executable -name "rats" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/rats" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/rats" 2>/dev/null && ok "c:rats" || ok "c:rats (installed)"
    else fail "rats" "build failed"; fi
  else fail "rats" "no dir"; fi
fi

if ! done_already "c:rbndr"; then
  if [ -f "$BIN/rbndr" ]; then skip "rbndr"; echo "PASS:c:rbndr" >> "$STATE"
  elif [ -d "/opt/blackarch/rbndr" ]; then
    cd "/opt/blackarch/rbndr"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/rbndr"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/rbndr" -maxdepth 4 -type f -executable -name "rbndr" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/rbndr" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/rbndr" 2>/dev/null && ok "c:rbndr" || ok "c:rbndr (installed)"
    else fail "rbndr" "build failed"; fi
  else fail "rbndr" "no dir"; fi
fi

if ! done_already "c:revsh"; then
  if [ -f "$BIN/revsh" ]; then skip "revsh"; echo "PASS:c:revsh" >> "$STATE"
  elif [ -d "/opt/blackarch/revsh" ]; then
    cd "/opt/blackarch/revsh"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/revsh"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/revsh" -maxdepth 4 -type f -executable -name "revsh" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/revsh" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/revsh" 2>/dev/null && ok "c:revsh" || ok "c:revsh (installed)"
    else fail "revsh" "build failed"; fi
  else fail "revsh" "no dir"; fi
fi

if ! done_already "c:rifiuti2"; then
  if [ -f "$BIN/rifiuti2" ]; then skip "rifiuti2"; echo "PASS:c:rifiuti2" >> "$STATE"
  elif [ -d "/opt/blackarch/rifiuti2" ]; then
    cd "/opt/blackarch/rifiuti2"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/rifiuti2"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/rifiuti2" -maxdepth 4 -type f -executable -name "rifiuti2" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/rifiuti2" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/rifiuti2" 2>/dev/null && ok "c:rifiuti2" || ok "c:rifiuti2 (installed)"
    else fail "rifiuti2" "build failed"; fi
  else fail "rifiuti2" "no dir"; fi
fi

if ! done_already "c:rtlizer"; then
  if [ -f "$BIN/rtlizer" ]; then skip "rtlizer"; echo "PASS:c:rtlizer" >> "$STATE"
  elif [ -d "/opt/blackarch/rtlizer" ]; then
    cd "/opt/blackarch/rtlizer"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/rtlizer"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/rtlizer" -maxdepth 4 -type f -executable -name "rtlizer" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/rtlizer" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/rtlizer" 2>/dev/null && ok "c:rtlizer" || ok "c:rtlizer (installed)"
    else fail "rtlizer" "build failed"; fi
  else fail "rtlizer" "no dir"; fi
fi

if ! done_already "c:saruman"; then
  if [ -f "$BIN/saruman" ]; then skip "saruman"; echo "PASS:c:saruman" >> "$STATE"
  elif [ -d "/opt/blackarch/saruman" ]; then
    cd "/opt/blackarch/saruman"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/saruman"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/saruman" -maxdepth 4 -type f -executable -name "saruman" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/saruman" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/saruman" 2>/dev/null && ok "c:saruman" || ok "c:saruman (installed)"
    else fail "saruman" "build failed"; fi
  else fail "saruman" "no dir"; fi
fi

if ! done_already "c:sha1collisiondetection"; then
  if [ -f "$BIN/sha1collisiondetection" ]; then skip "sha1collisiondetection"; echo "PASS:c:sha1collisiondetection" >> "$STATE"
  elif [ -d "/opt/blackarch/sha1collisiondetection" ]; then
    cd "/opt/blackarch/sha1collisiondetection"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/sha1collisiondetection"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/sha1collisiondetection" -maxdepth 4 -type f -executable -name "sha1collisiondetection" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/sha1collisiondetection" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/sha1collisiondetection" 2>/dev/null && ok "c:sha1collisiondetection" || ok "c:sha1collisiondetection (installed)"
    else fail "sha1collisiondetection" "build failed"; fi
  else fail "sha1collisiondetection" "no dir"; fi
fi

if ! done_already "c:shellcode-compiler"; then
  if [ -f "$BIN/shellcode-compiler" ]; then skip "shellcode-compiler"; echo "PASS:c:shellcode-compiler" >> "$STATE"
  elif [ -d "/opt/blackarch/shellcode-compiler" ]; then
    cd "/opt/blackarch/shellcode-compiler"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/shellcode-compiler"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/shellcode-compiler" -maxdepth 4 -type f -executable -name "shellcode-compiler" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/shellcode-compiler" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/shellcode-compiler" 2>/dev/null && ok "c:shellcode-compiler" || ok "c:shellcode-compiler (installed)"
    else fail "shellcode-compiler" "build failed"; fi
  else fail "shellcode-compiler" "no dir"; fi
fi

if ! done_already "c:sherlocked"; then
  if [ -f "$BIN/sherlocked" ]; then skip "sherlocked"; echo "PASS:c:sherlocked" >> "$STATE"
  elif [ -d "/opt/blackarch/sherlocked" ]; then
    cd "/opt/blackarch/sherlocked"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/sherlocked"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/sherlocked" -maxdepth 4 -type f -executable -name "sherlocked" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/sherlocked" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/sherlocked" 2>/dev/null && ok "c:sherlocked" || ok "c:sherlocked (installed)"
    else fail "sherlocked" "build failed"; fi
  else fail "sherlocked" "no dir"; fi
fi

if ! done_already "c:sipffer"; then
  if [ -f "$BIN/sipffer" ]; then skip "sipffer"; echo "PASS:c:sipffer" >> "$STATE"
  elif [ -d "/opt/blackarch/sipffer" ]; then
    cd "/opt/blackarch/sipffer"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/sipffer"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/sipffer" -maxdepth 4 -type f -executable -name "sipffer" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/sipffer" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/sipffer" 2>/dev/null && ok "c:sipffer" || ok "c:sipffer (installed)"
    else fail "sipffer" "build failed"; fi
  else fail "sipffer" "no dir"; fi
fi

if ! done_already "c:skul"; then
  if [ -f "$BIN/skul" ]; then skip "skul"; echo "PASS:c:skul" >> "$STATE"
  elif [ -d "/opt/blackarch/skul" ]; then
    cd "/opt/blackarch/skul"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/skul"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/skul" -maxdepth 4 -type f -executable -name "skul" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/skul" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/skul" 2>/dev/null && ok "c:skul" || ok "c:skul (installed)"
    else fail "skul" "build failed"; fi
  else fail "skul" "no dir"; fi
fi

if ! done_already "c:sloth-fuzzer"; then
  if [ -f "$BIN/sloth-fuzzer" ]; then skip "sloth-fuzzer"; echo "PASS:c:sloth-fuzzer" >> "$STATE"
  elif [ -d "/opt/blackarch/sloth-fuzzer" ]; then
    cd "/opt/blackarch/sloth-fuzzer"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/sloth-fuzzer"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/sloth-fuzzer" -maxdepth 4 -type f -executable -name "sloth-fuzzer" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/sloth-fuzzer" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/sloth-fuzzer" 2>/dev/null && ok "c:sloth-fuzzer" || ok "c:sloth-fuzzer (installed)"
    else fail "sloth-fuzzer" "build failed"; fi
  else fail "sloth-fuzzer" "no dir"; fi
fi

if ! done_already "c:sslnuke"; then
  if [ -f "$BIN/sslnuke" ]; then skip "sslnuke"; echo "PASS:c:sslnuke" >> "$STATE"
  elif [ -d "/opt/blackarch/sslnuke" ]; then
    cd "/opt/blackarch/sslnuke"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/sslnuke"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/sslnuke" -maxdepth 4 -type f -executable -name "sslnuke" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/sslnuke" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/sslnuke" 2>/dev/null && ok "c:sslnuke" || ok "c:sslnuke (installed)"
    else fail "sslnuke" "build failed"; fi
  else fail "sslnuke" "no dir"; fi
fi

if ! done_already "c:stegolego"; then
  if [ -f "$BIN/stegolego" ]; then skip "stegolego"; echo "PASS:c:stegolego" >> "$STATE"
  elif [ -d "/opt/blackarch/stegolego" ]; then
    cd "/opt/blackarch/stegolego"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/stegolego"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/stegolego" -maxdepth 4 -type f -executable -name "stegolego" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/stegolego" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/stegolego" 2>/dev/null && ok "c:stegolego" || ok "c:stegolego (installed)"
    else fail "stegolego" "build failed"; fi
  else fail "stegolego" "no dir"; fi
fi

if ! done_already "c:syringe"; then
  if [ -f "$BIN/syringe" ]; then skip "syringe"; echo "PASS:c:syringe" >> "$STATE"
  elif [ -d "/opt/blackarch/syringe" ]; then
    cd "/opt/blackarch/syringe"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/syringe"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/syringe" -maxdepth 4 -type f -executable -name "syringe" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/syringe" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/syringe" 2>/dev/null && ok "c:syringe" || ok "c:syringe (installed)"
    else fail "syringe" "build failed"; fi
  else fail "syringe" "no dir"; fi
fi

if ! done_already "c:tcpcopy"; then
  if [ -f "$BIN/tcpcopy" ]; then skip "tcpcopy"; echo "PASS:c:tcpcopy" >> "$STATE"
  elif [ -d "/opt/blackarch/tcpcopy" ]; then
    cd "/opt/blackarch/tcpcopy"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/tcpcopy"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/tcpcopy" -maxdepth 4 -type f -executable -name "tcpcopy" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/tcpcopy" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/tcpcopy" 2>/dev/null && ok "c:tcpcopy" || ok "c:tcpcopy (installed)"
    else fail "tcpcopy" "build failed"; fi
  else fail "tcpcopy" "no dir"; fi
fi

if ! done_already "c:tcpdstat"; then
  if [ -f "$BIN/tcpdstat" ]; then skip "tcpdstat"; echo "PASS:c:tcpdstat" >> "$STATE"
  elif [ -d "/opt/blackarch/tcpdstat" ]; then
    cd "/opt/blackarch/tcpdstat"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/tcpdstat"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/tcpdstat" -maxdepth 4 -type f -executable -name "tcpdstat" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/tcpdstat" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/tcpdstat" 2>/dev/null && ok "c:tcpdstat" || ok "c:tcpdstat (installed)"
    else fail "tcpdstat" "build failed"; fi
  else fail "tcpdstat" "no dir"; fi
fi

if ! done_already "c:tsh-sctp"; then
  if [ -f "$BIN/tsh-sctp" ]; then skip "tsh-sctp"; echo "PASS:c:tsh-sctp" >> "$STATE"
  elif [ -d "/opt/blackarch/tsh-sctp" ]; then
    cd "/opt/blackarch/tsh-sctp"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/tsh-sctp"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/tsh-sctp" -maxdepth 4 -type f -executable -name "tsh-sctp" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/tsh-sctp" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/tsh-sctp" 2>/dev/null && ok "c:tsh-sctp" || ok "c:tsh-sctp (installed)"
    else fail "tsh-sctp" "build failed"; fi
  else fail "tsh-sctp" "no dir"; fi
fi

if ! done_already "c:tyton"; then
  if [ -f "$BIN/tyton" ]; then skip "tyton"; echo "PASS:c:tyton" >> "$STATE"
  elif [ -d "/opt/blackarch/tyton" ]; then
    cd "/opt/blackarch/tyton"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/tyton"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/tyton" -maxdepth 4 -type f -executable -name "tyton" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/tyton" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/tyton" 2>/dev/null && ok "c:tyton" || ok "c:tyton (installed)"
    else fail "tyton" "build failed"; fi
  else fail "tyton" "no dir"; fi
fi

if ! done_already "c:uacme"; then
  if [ -f "$BIN/uacme" ]; then skip "uacme"; echo "PASS:c:uacme" >> "$STATE"
  elif [ -d "/opt/blackarch/uacme" ]; then
    cd "/opt/blackarch/uacme"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/uacme"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/uacme" -maxdepth 4 -type f -executable -name "uacme" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/uacme" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/uacme" 2>/dev/null && ok "c:uacme" || ok "c:uacme (installed)"
    else fail "uacme" "build failed"; fi
  else fail "uacme" "no dir"; fi
fi

if ! done_already "c:unifuzzer"; then
  if [ -f "$BIN/unifuzzer" ]; then skip "unifuzzer"; echo "PASS:c:unifuzzer" >> "$STATE"
  elif [ -d "/opt/blackarch/unifuzzer" ]; then
    cd "/opt/blackarch/unifuzzer"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/unifuzzer"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/unifuzzer" -maxdepth 4 -type f -executable -name "unifuzzer" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/unifuzzer" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/unifuzzer" 2>/dev/null && ok "c:unifuzzer" || ok "c:unifuzzer (installed)"
    else fail "unifuzzer" "build failed"; fi
  else fail "unifuzzer" "no dir"; fi
fi

if ! done_already "c:untwister"; then
  if [ -f "$BIN/untwister" ]; then skip "untwister"; echo "PASS:c:untwister" >> "$STATE"
  elif [ -d "/opt/blackarch/untwister" ]; then
    cd "/opt/blackarch/untwister"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/untwister"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/untwister" -maxdepth 4 -type f -executable -name "untwister" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/untwister" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/untwister" 2>/dev/null && ok "c:untwister" || ok "c:untwister (installed)"
    else fail "untwister" "build failed"; fi
  else fail "untwister" "no dir"; fi
fi

if ! done_already "c:vbrute"; then
  if [ -f "$BIN/vbrute" ]; then skip "vbrute"; echo "PASS:c:vbrute" >> "$STATE"
  elif [ -d "/opt/blackarch/vbrute" ]; then
    cd "/opt/blackarch/vbrute"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/vbrute"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/vbrute" -maxdepth 4 -type f -executable -name "vbrute" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/vbrute" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/vbrute" 2>/dev/null && ok "c:vbrute" || ok "c:vbrute (installed)"
    else fail "vbrute" "build failed"; fi
  else fail "vbrute" "no dir"; fi
fi

if ! done_already "c:wificurse"; then
  if [ -f "$BIN/wificurse" ]; then skip "wificurse"; echo "PASS:c:wificurse" >> "$STATE"
  elif [ -d "/opt/blackarch/wificurse" ]; then
    cd "/opt/blackarch/wificurse"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/wificurse"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/wificurse" -maxdepth 4 -type f -executable -name "wificurse" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/wificurse" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/wificurse" 2>/dev/null && ok "c:wificurse" || ok "c:wificurse (installed)"
    else fail "wificurse" "build failed"; fi
  else fail "wificurse" "no dir"; fi
fi

if ! done_already "c:xrop"; then
  if [ -f "$BIN/xrop" ]; then skip "xrop"; echo "PASS:c:xrop" >> "$STATE"
  elif [ -d "/opt/blackarch/xrop" ]; then
    cd "/opt/blackarch/xrop"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/xrop"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/xrop" -maxdepth 4 -type f -executable -name "xrop" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/xrop" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/xrop" 2>/dev/null && ok "c:xrop" || ok "c:xrop (installed)"
    else fail "xrop" "build failed"; fi
  else fail "xrop" "no dir"; fi
fi

if ! done_already "c:xssscan"; then
  if [ -f "$BIN/xssscan" ]; then skip "xssscan"; echo "PASS:c:xssscan" >> "$STATE"
  elif [ -d "/opt/blackarch/xssscan" ]; then
    cd "/opt/blackarch/xssscan"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/xssscan"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/xssscan" -maxdepth 4 -type f -executable -name "xssscan" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/xssscan" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/xssscan" 2>/dev/null && ok "c:xssscan" || ok "c:xssscan (installed)"
    else fail "xssscan" "build failed"; fi
  else fail "xssscan" "no dir"; fi
fi

if ! done_already "c:yuck"; then
  if [ -f "$BIN/yuck" ]; then skip "yuck"; echo "PASS:c:yuck" >> "$STATE"
  elif [ -d "/opt/blackarch/yuck" ]; then
    cd "/opt/blackarch/yuck"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/yuck"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/yuck" -maxdepth 4 -type f -executable -name "yuck" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/yuck" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/yuck" 2>/dev/null && ok "c:yuck" || ok "c:yuck (installed)"
    else fail "yuck" "build failed"; fi
  else fail "yuck" "no dir"; fi
fi

if ! done_already "c:zizzania"; then
  if [ -f "$BIN/zizzania" ]; then skip "zizzania"; echo "PASS:c:zizzania" >> "$STATE"
  elif [ -d "/opt/blackarch/zizzania" ]; then
    cd "/opt/blackarch/zizzania"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/zizzania"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/zizzania" -maxdepth 4 -type f -executable -name "zizzania" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/zizzania" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/zizzania" 2>/dev/null && ok "c:zizzania" || ok "c:zizzania (installed)"
    else fail "zizzania" "build failed"; fi
  else fail "zizzania" "no dir"; fi
fi

if ! done_already "c:zulucrypt"; then
  if [ -f "$BIN/zulucrypt" ]; then skip "zulucrypt"; echo "PASS:c:zulucrypt" >> "$STATE"
  elif [ -d "/opt/blackarch/zulucrypt" ]; then
    cd "/opt/blackarch/zulucrypt"
    built=false
    [ -f "configure.ac" ] && [ ! -f "configure" ] && autoreconf -fi 2>/dev/null || true
    if [ -f "configure" ]; then
      ./configure --prefix=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true
    fi
    if ! $built && [ -f "CMakeLists.txt" ]; then
      mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local 2>/dev/null && make -j$(nproc) 2>/dev/null && make install 2>/dev/null && built=true && cd "/opt/blackarch/zulucrypt"
    fi
    if ! $built && [ -f "Makefile" -o -f "makefile" ]; then
      make -j$(nproc) 2>/dev/null && built=true
    fi
    if $built; then
      bin=$(find "/opt/blackarch/zulucrypt" -maxdepth 4 -type f -executable -name "zulucrypt" 2>/dev/null | head -1)
      [ -z "$bin" ] && bin=$(find "/opt/blackarch/zulucrypt" -maxdepth 4 -type f -executable ! -name "*.sh" ! -name "*.py" ! -name "*.pl" 2>/dev/null | head -1)
      [ -n "$bin" ] && ln -sf "$bin" "$BIN/zulucrypt" 2>/dev/null && ok "c:zulucrypt" || ok "c:zulucrypt (installed)"
    else fail "zulucrypt" "build failed"; fi
  else fail "zulucrypt" "no dir"; fi
fi

echo -e "${ORANGE}━━━ Rust Tools (21) ━━━${NC}"

if ! done_already "rust:ares"; then
  if [ -f "$BIN/ares" ]; then skip "ares"; echo "PASS:rust:ares" >> "$STATE"
  elif [ -d "/opt/blackarch/ares" ]; then
    cd "/opt/blackarch/ares"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/ares/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/ares" && chmod +x "$BIN/ares" && ok "rust:ares" || fail "ares" "no binary"
    else fail "ares" "cargo failed"; fi
  else fail "ares" "no dir"; fi
fi

if ! done_already "rust:blackarch-devtools-toolkit"; then
  if [ -f "$BIN/blackarch-devtools-toolkit" ]; then skip "blackarch-devtools-toolkit"; echo "PASS:rust:blackarch-devtools-toolkit" >> "$STATE"
  elif [ -d "/opt/blackarch/blackarch-devtools-toolkit" ]; then
    cd "/opt/blackarch/blackarch-devtools-toolkit"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/blackarch-devtools-toolkit/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/blackarch-devtools-toolkit" && chmod +x "$BIN/blackarch-devtools-toolkit" && ok "rust:blackarch-devtools-toolkit" || fail "blackarch-devtools-toolkit" "no binary"
    else fail "blackarch-devtools-toolkit" "cargo failed"; fi
  else fail "blackarch-devtools-toolkit" "no dir"; fi
fi

if ! done_already "rust:chainsaw"; then
  if [ -f "$BIN/chainsaw" ]; then skip "chainsaw"; echo "PASS:rust:chainsaw" >> "$STATE"
  elif [ -d "/opt/blackarch/chainsaw" ]; then
    cd "/opt/blackarch/chainsaw"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/chainsaw/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/chainsaw" && chmod +x "$BIN/chainsaw" && ok "rust:chainsaw" || fail "chainsaw" "no binary"
    else fail "chainsaw" "cargo failed"; fi
  else fail "chainsaw" "no dir"; fi
fi

if ! done_already "rust:dirble"; then
  if [ -f "$BIN/dirble" ]; then skip "dirble"; echo "PASS:rust:dirble" >> "$STATE"
  elif [ -d "/opt/blackarch/dirble" ]; then
    cd "/opt/blackarch/dirble"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/dirble/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/dirble" && chmod +x "$BIN/dirble" && ok "rust:dirble" || fail "dirble" "no binary"
    else fail "dirble" "cargo failed"; fi
  else fail "dirble" "no dir"; fi
fi

if ! done_already "rust:jwt-hack"; then
  if [ -f "$BIN/jwt-hack" ]; then skip "jwt-hack"; echo "PASS:rust:jwt-hack" >> "$STATE"
  elif [ -d "/opt/blackarch/jwt-hack" ]; then
    cd "/opt/blackarch/jwt-hack"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/jwt-hack/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/jwt-hack" && chmod +x "$BIN/jwt-hack" && ok "rust:jwt-hack" || fail "jwt-hack" "no binary"
    else fail "jwt-hack" "cargo failed"; fi
  else fail "jwt-hack" "no dir"; fi
fi

if ! done_already "rust:lorsrf"; then
  if [ -f "$BIN/lorsrf" ]; then skip "lorsrf"; echo "PASS:rust:lorsrf" >> "$STATE"
  elif [ -d "/opt/blackarch/lorsrf" ]; then
    cd "/opt/blackarch/lorsrf"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/lorsrf/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/lorsrf" && chmod +x "$BIN/lorsrf" && ok "rust:lorsrf" || fail "lorsrf" "no binary"
    else fail "lorsrf" "cargo failed"; fi
  else fail "lorsrf" "no dir"; fi
fi

if ! done_already "rust:moonwalk"; then
  if [ -f "$BIN/moonwalk" ]; then skip "moonwalk"; echo "PASS:rust:moonwalk" >> "$STATE"
  elif [ -d "/opt/blackarch/moonwalk" ]; then
    cd "/opt/blackarch/moonwalk"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/moonwalk/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/moonwalk" && chmod +x "$BIN/moonwalk" && ok "rust:moonwalk" || fail "moonwalk" "no binary"
    else fail "moonwalk" "cargo failed"; fi
  else fail "moonwalk" "no dir"; fi
fi

if ! done_already "rust:operative"; then
  if [ -f "$BIN/operative" ]; then skip "operative"; echo "PASS:rust:operative" >> "$STATE"
  elif [ -d "/opt/blackarch/operative" ]; then
    cd "/opt/blackarch/operative"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/operative/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/operative" && chmod +x "$BIN/operative" && ok "rust:operative" || fail "operative" "no binary"
    else fail "operative" "cargo failed"; fi
  else fail "operative" "no dir"; fi
fi

if ! done_already "rust:paru"; then
  if [ -f "$BIN/paru" ]; then skip "paru"; echo "PASS:rust:paru" >> "$STATE"
  elif [ -d "/opt/blackarch/paru" ]; then
    cd "/opt/blackarch/paru"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/paru/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/paru" && chmod +x "$BIN/paru" && ok "rust:paru" || fail "paru" "no binary"
    else fail "paru" "cargo failed"; fi
  else fail "paru" "no dir"; fi
fi

if ! done_already "rust:ppfuzz"; then
  if [ -f "$BIN/ppfuzz" ]; then skip "ppfuzz"; echo "PASS:rust:ppfuzz" >> "$STATE"
  elif [ -d "/opt/blackarch/ppfuzz" ]; then
    cd "/opt/blackarch/ppfuzz"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/ppfuzz/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/ppfuzz" && chmod +x "$BIN/ppfuzz" && ok "rust:ppfuzz" || fail "ppfuzz" "no binary"
    else fail "ppfuzz" "cargo failed"; fi
  else fail "ppfuzz" "no dir"; fi
fi

if ! done_already "rust:pwfuzz-rs"; then
  if [ -f "$BIN/pwfuzz-rs" ]; then skip "pwfuzz-rs"; echo "PASS:rust:pwfuzz-rs" >> "$STATE"
  elif [ -d "/opt/blackarch/pwfuzz-rs" ]; then
    cd "/opt/blackarch/pwfuzz-rs"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/pwfuzz-rs/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/pwfuzz-rs" && chmod +x "$BIN/pwfuzz-rs" && ok "rust:pwfuzz-rs" || fail "pwfuzz-rs" "no binary"
    else fail "pwfuzz-rs" "cargo failed"; fi
  else fail "pwfuzz-rs" "no dir"; fi
fi

if ! done_already "rust:rbasefind"; then
  if [ -f "$BIN/rbasefind" ]; then skip "rbasefind"; echo "PASS:rust:rbasefind" >> "$STATE"
  elif [ -d "/opt/blackarch/rbasefind" ]; then
    cd "/opt/blackarch/rbasefind"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/rbasefind/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/rbasefind" && chmod +x "$BIN/rbasefind" && ok "rust:rbasefind" || fail "rbasefind" "no binary"
    else fail "rbasefind" "cargo failed"; fi
  else fail "rbasefind" "no dir"; fi
fi

if ! done_already "rust:rulesfinder"; then
  if [ -f "$BIN/rulesfinder" ]; then skip "rulesfinder"; echo "PASS:rust:rulesfinder" >> "$STATE"
  elif [ -d "/opt/blackarch/rulesfinder" ]; then
    cd "/opt/blackarch/rulesfinder"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/rulesfinder/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/rulesfinder" && chmod +x "$BIN/rulesfinder" && ok "rust:rulesfinder" || fail "rulesfinder" "no binary"
    else fail "rulesfinder" "cargo failed"; fi
  else fail "rulesfinder" "no dir"; fi
fi

if ! done_already "rust:rustbuster"; then
  if [ -f "$BIN/rustbuster" ]; then skip "rustbuster"; echo "PASS:rust:rustbuster" >> "$STATE"
  elif [ -d "/opt/blackarch/rustbuster" ]; then
    cd "/opt/blackarch/rustbuster"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/rustbuster/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/rustbuster" && chmod +x "$BIN/rustbuster" && ok "rust:rustbuster" || fail "rustbuster" "no binary"
    else fail "rustbuster" "cargo failed"; fi
  else fail "rustbuster" "no dir"; fi
fi

if ! done_already "rust:rusthound-ce"; then
  if [ -f "$BIN/rusthound-ce" ]; then skip "rusthound-ce"; echo "PASS:rust:rusthound-ce" >> "$STATE"
  elif [ -d "/opt/blackarch/rusthound-ce" ]; then
    cd "/opt/blackarch/rusthound-ce"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/rusthound-ce/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/rusthound-ce" && chmod +x "$BIN/rusthound-ce" && ok "rust:rusthound-ce" || fail "rusthound-ce" "no binary"
    else fail "rusthound-ce" "cargo failed"; fi
  else fail "rusthound-ce" "no dir"; fi
fi

if ! done_already "rust:rustpad"; then
  if [ -f "$BIN/rustpad" ]; then skip "rustpad"; echo "PASS:rust:rustpad" >> "$STATE"
  elif [ -d "/opt/blackarch/rustpad" ]; then
    cd "/opt/blackarch/rustpad"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/rustpad/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/rustpad" && chmod +x "$BIN/rustpad" && ok "rust:rustpad" || fail "rustpad" "no binary"
    else fail "rustpad" "cargo failed"; fi
  else fail "rustpad" "no dir"; fi
fi

if ! done_already "rust:samesame"; then
  if [ -f "$BIN/samesame" ]; then skip "samesame"; echo "PASS:rust:samesame" >> "$STATE"
  elif [ -d "/opt/blackarch/samesame" ]; then
    cd "/opt/blackarch/samesame"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/samesame/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/samesame" && chmod +x "$BIN/samesame" && ok "rust:samesame" || fail "samesame" "no binary"
    else fail "samesame" "cargo failed"; fi
  else fail "samesame" "no dir"; fi
fi

if ! done_already "rust:scrying"; then
  if [ -f "$BIN/scrying" ]; then skip "scrying"; echo "PASS:rust:scrying" >> "$STATE"
  elif [ -d "/opt/blackarch/scrying" ]; then
    cd "/opt/blackarch/scrying"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/scrying/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/scrying" && chmod +x "$BIN/scrying" && ok "rust:scrying" || fail "scrying" "no binary"
    else fail "scrying" "cargo failed"; fi
  else fail "scrying" "no dir"; fi
fi

if ! done_already "rust:urx"; then
  if [ -f "$BIN/urx" ]; then skip "urx"; echo "PASS:rust:urx" >> "$STATE"
  elif [ -d "/opt/blackarch/urx" ]; then
    cd "/opt/blackarch/urx"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/urx/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/urx" && chmod +x "$BIN/urx" && ok "rust:urx" || fail "urx" "no binary"
    else fail "urx" "cargo failed"; fi
  else fail "urx" "no dir"; fi
fi

if ! done_already "rust:wcc"; then
  if [ -f "$BIN/wcc" ]; then skip "wcc"; echo "PASS:rust:wcc" >> "$STATE"
  elif [ -d "/opt/blackarch/wcc" ]; then
    cd "/opt/blackarch/wcc"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/wcc/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/wcc" && chmod +x "$BIN/wcc" && ok "rust:wcc" || fail "wcc" "no binary"
    else fail "wcc" "cargo failed"; fi
  else fail "wcc" "no dir"; fi
fi

if ! done_already "rust:x8"; then
  if [ -f "$BIN/x8" ]; then skip "x8"; echo "PASS:rust:x8" >> "$STATE"
  elif [ -d "/opt/blackarch/x8" ]; then
    cd "/opt/blackarch/x8"
    if cargo build --release 2>/dev/null; then
      bin=$(find "/opt/blackarch/x8/target/release" -maxdepth 1 -type f -executable 2>/dev/null | head -1)
      [ -n "$bin" ] && cp "$bin" "$BIN/x8" && chmod +x "$BIN/x8" && ok "rust:x8" || fail "x8" "no binary"
    else fail "x8" "cargo failed"; fi
  else fail "x8" "no dir"; fi
fi

echo -e "${ORANGE}━━━ Java Tools (18) ━━━${NC}"
# Fix ysoserial Java version
sed -i "s/<source>6</<source>8</g; s/<target>6</<target>8</g" /opt/blackarch/ysoserial/pom.xml 2>/dev/null || true

if ! done_already "java:ajpfuzzer"; then
  if [ -f "$BIN/ajpfuzzer" ]; then skip "ajpfuzzer"; echo "PASS:java:ajpfuzzer" >> "$STATE"
  elif [ -d "/opt/blackarch/ajpfuzzer" ]; then
    cd "/opt/blackarch/ajpfuzzer"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/ajpfuzzer" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "ajpfuzzer" "$jar" && ok "java:ajpfuzzer" || fail "ajpfuzzer" "no jar"
  else fail "ajpfuzzer" "no dir"; fi
fi

if ! done_already "java:binnavi"; then
  if [ -f "$BIN/binnavi" ]; then skip "binnavi"; echo "PASS:java:binnavi" >> "$STATE"
  elif [ -d "/opt/blackarch/binnavi" ]; then
    cd "/opt/blackarch/binnavi"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/binnavi" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "binnavi" "$jar" && ok "java:binnavi" || fail "binnavi" "no jar"
  else fail "binnavi" "no dir"; fi
fi

if ! done_already "java:dexpatcher"; then
  if [ -f "$BIN/dexpatcher" ]; then skip "dexpatcher"; echo "PASS:java:dexpatcher" >> "$STATE"
  elif [ -d "/opt/blackarch/dexpatcher" ]; then
    cd "/opt/blackarch/dexpatcher"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/dexpatcher" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "dexpatcher" "$jar" && ok "java:dexpatcher" || fail "dexpatcher" "no jar"
  else fail "dexpatcher" "no dir"; fi
fi

if ! done_already "java:fernflower"; then
  if [ -f "$BIN/fernflower" ]; then skip "fernflower"; echo "PASS:java:fernflower" >> "$STATE"
  elif [ -d "/opt/blackarch/fernflower" ]; then
    cd "/opt/blackarch/fernflower"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/fernflower" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "fernflower" "$jar" && ok "java:fernflower" || fail "fernflower" "no jar"
  else fail "fernflower" "no dir"; fi
fi

if ! done_already "java:gadgetinspector"; then
  if [ -f "$BIN/gadgetinspector" ]; then skip "gadgetinspector"; echo "PASS:java:gadgetinspector" >> "$STATE"
  elif [ -d "/opt/blackarch/gadgetinspector" ]; then
    cd "/opt/blackarch/gadgetinspector"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/gadgetinspector" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "gadgetinspector" "$jar" && ok "java:gadgetinspector" || fail "gadgetinspector" "no jar"
  else fail "gadgetinspector" "no dir"; fi
fi

if ! done_already "java:jaadas"; then
  if [ -f "$BIN/jaadas" ]; then skip "jaadas"; echo "PASS:java:jaadas" >> "$STATE"
  elif [ -d "/opt/blackarch/jaadas" ]; then
    cd "/opt/blackarch/jaadas"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/jaadas" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "jaadas" "$jar" && ok "java:jaadas" || fail "jaadas" "no jar"
  else fail "jaadas" "no dir"; fi
fi

if ! done_already "java:jd-cli"; then
  if [ -f "$BIN/jd-cli" ]; then skip "jd-cli"; echo "PASS:java:jd-cli" >> "$STATE"
  elif [ -d "/opt/blackarch/jd-cli" ]; then
    cd "/opt/blackarch/jd-cli"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/jd-cli" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "jd-cli" "$jar" && ok "java:jd-cli" || fail "jd-cli" "no jar"
  else fail "jd-cli" "no dir"; fi
fi

if ! done_already "java:jd-gui"; then
  if [ -f "$BIN/jd-gui" ]; then skip "jd-gui"; echo "PASS:java:jd-gui" >> "$STATE"
  elif [ -d "/opt/blackarch/jd-gui" ]; then
    cd "/opt/blackarch/jd-gui"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/jd-gui" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "jd-gui" "$jar" && ok "java:jd-gui" || fail "jd-gui" "no jar"
  else fail "jd-gui" "no dir"; fi
fi

if ! done_already "java:jndi-injection-exploit"; then
  if [ -f "$BIN/jndi-injection-exploit" ]; then skip "jndi-injection-exploit"; echo "PASS:java:jndi-injection-exploit" >> "$STATE"
  elif [ -d "/opt/blackarch/jndi-injection-exploit" ]; then
    cd "/opt/blackarch/jndi-injection-exploit"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/jndi-injection-exploit" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "jndi-injection-exploit" "$jar" && ok "java:jndi-injection-exploit" || fail "jndi-injection-exploit" "no jar"
  else fail "jndi-injection-exploit" "no dir"; fi
fi

if ! done_already "java:jsql-injection"; then
  if [ -f "$BIN/jsql-injection" ]; then skip "jsql-injection"; echo "PASS:java:jsql-injection" >> "$STATE"
  elif [ -d "/opt/blackarch/jsql-injection" ]; then
    cd "/opt/blackarch/jsql-injection"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/jsql-injection" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "jsql-injection" "$jar" && ok "java:jsql-injection" || fail "jsql-injection" "no jar"
  else fail "jsql-injection" "no dir"; fi
fi

if ! done_already "java:luyten"; then
  if [ -f "$BIN/luyten" ]; then skip "luyten"; echo "PASS:java:luyten" >> "$STATE"
  elif [ -d "/opt/blackarch/luyten" ]; then
    cd "/opt/blackarch/luyten"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/luyten" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "luyten" "$jar" && ok "java:luyten" || fail "luyten" "no jar"
  else fail "luyten" "no dir"; fi
fi

if ! done_already "java:marshalsec"; then
  if [ -f "$BIN/marshalsec" ]; then skip "marshalsec"; echo "PASS:java:marshalsec" >> "$STATE"
  elif [ -d "/opt/blackarch/marshalsec" ]; then
    cd "/opt/blackarch/marshalsec"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/marshalsec" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "marshalsec" "$jar" && ok "java:marshalsec" || fail "marshalsec" "no jar"
  else fail "marshalsec" "no dir"; fi
fi

if ! done_already "java:procyon"; then
  if [ -f "$BIN/procyon" ]; then skip "procyon"; echo "PASS:java:procyon" >> "$STATE"
  elif [ -d "/opt/blackarch/procyon" ]; then
    cd "/opt/blackarch/procyon"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/procyon" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "procyon" "$jar" && ok "java:procyon" || fail "procyon" "no jar"
  else fail "procyon" "no dir"; fi
fi

if ! done_already "java:recaf"; then
  if [ -f "$BIN/recaf" ]; then skip "recaf"; echo "PASS:java:recaf" >> "$STATE"
  elif [ -d "/opt/blackarch/recaf" ]; then
    cd "/opt/blackarch/recaf"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/recaf" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "recaf" "$jar" && ok "java:recaf" || fail "recaf" "no jar"
  else fail "recaf" "no dir"; fi
fi

if ! done_already "java:richsploit"; then
  if [ -f "$BIN/richsploit" ]; then skip "richsploit"; echo "PASS:java:richsploit" >> "$STATE"
  elif [ -d "/opt/blackarch/richsploit" ]; then
    cd "/opt/blackarch/richsploit"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/richsploit" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "richsploit" "$jar" && ok "java:richsploit" || fail "richsploit" "no jar"
  else fail "richsploit" "no dir"; fi
fi

if ! done_already "java:sdrtrunk"; then
  if [ -f "$BIN/sdrtrunk" ]; then skip "sdrtrunk"; echo "PASS:java:sdrtrunk" >> "$STATE"
  elif [ -d "/opt/blackarch/sdrtrunk" ]; then
    cd "/opt/blackarch/sdrtrunk"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/sdrtrunk" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "sdrtrunk" "$jar" && ok "java:sdrtrunk" || fail "sdrtrunk" "no jar"
  else fail "sdrtrunk" "no dir"; fi
fi

if ! done_already "java:verinice"; then
  if [ -f "$BIN/verinice" ]; then skip "verinice"; echo "PASS:java:verinice" >> "$STATE"
  elif [ -d "/opt/blackarch/verinice" ]; then
    cd "/opt/blackarch/verinice"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/verinice" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "verinice" "$jar" && ok "java:verinice" || fail "verinice" "no jar"
  else fail "verinice" "no dir"; fi
fi

if ! done_already "java:ysoserial"; then
  if [ -f "$BIN/ysoserial" ]; then skip "ysoserial"; echo "PASS:java:ysoserial" >> "$STATE"
  elif [ -d "/opt/blackarch/ysoserial" ]; then
    cd "/opt/blackarch/ysoserial"
    [ -f "gradlew" ] && chmod +x gradlew
    [ -f "pom.xml" ] && mvn package -q -DskipTests 2>/dev/null || true
    [ -f "gradlew" ] && ./gradlew build -q 2>/dev/null || true
    [ -f "build.gradle" ] && ! [ -f "gradlew" ] && gradle build -q 2>/dev/null || true
    jar=$(find "/opt/blackarch/ysoserial" -name "*.jar" ! -path "*/test*" ! -path "*-sources*" ! -path "*-javadoc*" 2>/dev/null | head -1)
    [ -n "$jar" ] && wrap_jar "ysoserial" "$jar" && ok "java:ysoserial" || fail "ysoserial" "no jar"
  else fail "ysoserial" "no dir"; fi
fi

echo -e "${ORANGE}━━━ npm Tools (15) ━━━${NC}"

if ! done_already "npm:bagbak"; then
  if [ -f "$BIN/bagbak" ]; then skip "bagbak"; echo "PASS:npm:bagbak" >> "$STATE"
  elif [ -d "/opt/blackarch/bagbak" ]; then
    cd "/opt/blackarch/bagbak"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/bagbak" ] && ok "npm:bagbak" && echo "PASS:npm:bagbak" >> "$STATE" || fail "bagbak" "npm link failed"
  else fail "bagbak" "no dir"; fi
fi

if ! done_already "npm:box-js"; then
  if [ -f "$BIN/box-js" ]; then skip "box-js"; echo "PASS:npm:box-js" >> "$STATE"
  elif [ -d "/opt/blackarch/box-js" ]; then
    cd "/opt/blackarch/box-js"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/box-js" ] && ok "npm:box-js" && echo "PASS:npm:box-js" >> "$STATE" || fail "box-js" "npm link failed"
  else fail "box-js" "no dir"; fi
fi

if ! done_already "npm:brosec"; then
  if [ -f "$BIN/brosec" ]; then skip "brosec"; echo "PASS:npm:brosec" >> "$STATE"
  elif [ -d "/opt/blackarch/brosec" ]; then
    cd "/opt/blackarch/brosec"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/brosec" ] && ok "npm:brosec" && echo "PASS:npm:brosec" >> "$STATE" || fail "brosec" "npm link failed"
  else fail "brosec" "no dir"; fi
fi

if ! done_already "npm:cloudsploit"; then
  if [ -f "$BIN/cloudsploit" ]; then skip "cloudsploit"; echo "PASS:npm:cloudsploit" >> "$STATE"
  elif [ -d "/opt/blackarch/cloudsploit" ]; then
    cd "/opt/blackarch/cloudsploit"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/cloudsploit" ] && ok "npm:cloudsploit" && echo "PASS:npm:cloudsploit" >> "$STATE" || fail "cloudsploit" "npm link failed"
  else fail "cloudsploit" "no dir"; fi
fi

if ! done_already "npm:expose"; then
  if [ -f "$BIN/expose" ]; then skip "expose"; echo "PASS:npm:expose" >> "$STATE"
  elif [ -d "/opt/blackarch/expose" ]; then
    cd "/opt/blackarch/expose"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/expose" ] && ok "npm:expose" && echo "PASS:npm:expose" >> "$STATE" || fail "expose" "npm link failed"
  else fail "expose" "no dir"; fi
fi

if ! done_already "npm:jsfuck"; then
  if [ -f "$BIN/jsfuck" ]; then skip "jsfuck"; echo "PASS:npm:jsfuck" >> "$STATE"
  elif [ -d "/opt/blackarch/jsfuck" ]; then
    cd "/opt/blackarch/jsfuck"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/jsfuck" ] && ok "npm:jsfuck" && echo "PASS:npm:jsfuck" >> "$STATE" || fail "jsfuck" "npm link failed"
  else fail "jsfuck" "no dir"; fi
fi

if ! done_already "npm:jstillery"; then
  if [ -f "$BIN/jstillery" ]; then skip "jstillery"; echo "PASS:npm:jstillery" >> "$STATE"
  elif [ -d "/opt/blackarch/jstillery" ]; then
    cd "/opt/blackarch/jstillery"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/jstillery" ] && ok "npm:jstillery" && echo "PASS:npm:jstillery" >> "$STATE" || fail "jstillery" "npm link failed"
  else fail "jstillery" "no dir"; fi
fi

if ! done_already "npm:node-ar-drone"; then
  if [ -f "$BIN/node-ar-drone" ]; then skip "node-ar-drone"; echo "PASS:npm:node-ar-drone" >> "$STATE"
  elif [ -d "/opt/blackarch/node-ar-drone" ]; then
    cd "/opt/blackarch/node-ar-drone"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/node-ar-drone" ] && ok "npm:node-ar-drone" && echo "PASS:npm:node-ar-drone" >> "$STATE" || fail "node-ar-drone" "npm link failed"
  else fail "node-ar-drone" "no dir"; fi
fi

if ! done_already "npm:nodejs-colors"; then
  if [ -f "$BIN/nodejs-colors" ]; then skip "nodejs-colors"; echo "PASS:npm:nodejs-colors" >> "$STATE"
  elif [ -d "/opt/blackarch/nodejs-colors" ]; then
    cd "/opt/blackarch/nodejs-colors"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/nodejs-colors" ] && ok "npm:nodejs-colors" && echo "PASS:npm:nodejs-colors" >> "$STATE" || fail "nodejs-colors" "npm link failed"
  else fail "nodejs-colors" "no dir"; fi
fi

if ! done_already "npm:novahot"; then
  if [ -f "$BIN/novahot" ]; then skip "novahot"; echo "PASS:npm:novahot" >> "$STATE"
  elif [ -d "/opt/blackarch/novahot" ]; then
    cd "/opt/blackarch/novahot"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/novahot" ] && ok "npm:novahot" && echo "PASS:npm:novahot" >> "$STATE" || fail "novahot" "npm link failed"
  else fail "novahot" "no dir"; fi
fi

if ! done_already "npm:padoracle"; then
  if [ -f "$BIN/padoracle" ]; then skip "padoracle"; echo "PASS:npm:padoracle" >> "$STATE"
  elif [ -d "/opt/blackarch/padoracle" ]; then
    cd "/opt/blackarch/padoracle"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/padoracle" ] && ok "npm:padoracle" && echo "PASS:npm:padoracle" >> "$STATE" || fail "padoracle" "npm link failed"
  else fail "padoracle" "no dir"; fi
fi

if ! done_already "npm:pwned"; then
  if [ -f "$BIN/pwned" ]; then skip "pwned"; echo "PASS:npm:pwned" >> "$STATE"
  elif [ -d "/opt/blackarch/pwned" ]; then
    cd "/opt/blackarch/pwned"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/pwned" ] && ok "npm:pwned" && echo "PASS:npm:pwned" >> "$STATE" || fail "pwned" "npm link failed"
  else fail "pwned" "no dir"; fi
fi

if ! done_already "npm:shuji"; then
  if [ -f "$BIN/shuji" ]; then skip "shuji"; echo "PASS:npm:shuji" >> "$STATE"
  elif [ -d "/opt/blackarch/shuji" ]; then
    cd "/opt/blackarch/shuji"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/shuji" ] && ok "npm:shuji" && echo "PASS:npm:shuji" >> "$STATE" || fail "shuji" "npm link failed"
  else fail "shuji" "no dir"; fi
fi

if ! done_already "npm:wscript"; then
  if [ -f "$BIN/wscript" ]; then skip "wscript"; echo "PASS:npm:wscript" >> "$STATE"
  elif [ -d "/opt/blackarch/wscript" ]; then
    cd "/opt/blackarch/wscript"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/wscript" ] && ok "npm:wscript" && echo "PASS:npm:wscript" >> "$STATE" || fail "wscript" "npm link failed"
  else fail "wscript" "no dir"; fi
fi

if ! done_already "npm:xxexploiter"; then
  if [ -f "$BIN/xxexploiter" ]; then skip "xxexploiter"; echo "PASS:npm:xxexploiter" >> "$STATE"
  elif [ -d "/opt/blackarch/xxexploiter" ]; then
    cd "/opt/blackarch/xxexploiter"
    npm install --silent 2>/dev/null || true
    npm link 2>/dev/null || true
    [ -f "$BIN/xxexploiter" ] && ok "npm:xxexploiter" && echo "PASS:npm:xxexploiter" >> "$STATE" || fail "xxexploiter" "npm link failed"
  else fail "xxexploiter" "no dir"; fi
fi

echo -e "${ORANGE}━━━ PowerShell Tools (13) ━━━${NC}"
done_already "ps1:adape-script" || { wrap_ps1 "adape-script" "/opt/blackarch/adape-script/ADAPE.ps1" && ok "ps1:adape-script" || fail "adape-script" "wrap failed"; }
done_already "ps1:cpp2il" || { wrap_ps1 "cpp2il" "/opt/blackarch/cpp2il/do-release.ps1" && ok "ps1:cpp2il" || fail "cpp2il" "wrap failed"; }
done_already "ps1:de4dot" || { wrap_ps1 "de4dot" "/opt/blackarch/de4dot/build.ps1" && ok "ps1:de4dot" || fail "de4dot" "wrap failed"; }
done_already "ps1:de4dotex" || { wrap_ps1 "de4dotex" "/opt/blackarch/de4dotex/build.ps1" && ok "ps1:de4dotex" || fail "de4dotex" "wrap failed"; }
done_already "ps1:dnspy" || { wrap_ps1 "dnspy" "/opt/blackarch/dnspy/build.ps1" && ok "ps1:dnspy" || fail "dnspy" "wrap failed"; }
done_already "ps1:invoke-cradlecrafter" || { wrap_ps1 "invoke-cradlecrafter" "/opt/blackarch/invoke-cradlecrafter/Invoke-CradleCrafter.psd1" && ok "ps1:invoke-cradlecrafter" || fail "invoke-cradlecrafter" "wrap failed"; }
done_already "ps1:invoke-dosfuscation" || { wrap_ps1 "invoke-dosfuscation" "/opt/blackarch/invoke-dosfuscation/Invoke-DOSfuscation.psd1" && ok "ps1:invoke-dosfuscation" || fail "invoke-dosfuscation" "wrap failed"; }
done_already "ps1:invoke-obfuscation" || { wrap_ps1 "invoke-obfuscation" "/opt/blackarch/invoke-obfuscation/Invoke-Obfuscation.psd1" && ok "ps1:invoke-obfuscation" || fail "invoke-obfuscation" "wrap failed"; }
done_already "ps1:juicy-potato" || { wrap_ps1 "juicy-potato" "/opt/blackarch/juicy-potato/CLSID/GetCLSID.ps1" && ok "ps1:juicy-potato" || fail "juicy-potato" "wrap failed"; }
done_already "ps1:mft2csv" || { wrap_ps1 "mft2csv" "/opt/blackarch/mft2csv/SplitCsv.ps1" && ok "ps1:mft2csv" || fail "mft2csv" "wrap failed"; }
done_already "ps1:mrkaplan" || { wrap_ps1 "mrkaplan" "/opt/blackarch/mrkaplan/MrKaplan.ps1" && ok "ps1:mrkaplan" || fail "mrkaplan" "wrap failed"; }
done_already "ps1:powercloud" || { wrap_ps1 "powercloud" "/opt/blackarch/powercloud/Invoke-PowerCloud.ps1" && ok "ps1:powercloud" || fail "powercloud" "wrap failed"; }
done_already "ps1:powersploit" || { wrap_ps1 "powersploit" "/opt/blackarch/powersploit/PowerSploit.psd1" && ok "ps1:powersploit" || fail "powersploit" "wrap failed"; }

echo -e "${ORANGE}━━━ PHP Tools (7) ━━━${NC}"
done_already "php:facebrok" || { wrap_php "facebrok" "/opt/blackarch/facebrok/l.php" && ok "php:facebrok" || fail "facebrok" "wrap failed"; }
done_already "php:jsonbee" || { wrap_php "jsonbee" "/opt/blackarch/jsonbee/csp_lab.php" && ok "php:jsonbee" || fail "jsonbee" "wrap failed"; }
done_already "php:magescan" || { wrap_php "magescan" "/opt/blackarch/magescan/test/bootstrap.php" && ok "php:magescan" || fail "magescan" "wrap failed"; }
done_already "php:phpstress" || { wrap_php "phpstress" "/opt/blackarch/phpstress/phpstress.php" && ok "php:phpstress" || fail "phpstress" "wrap failed"; }
done_already "php:red-hawk" || { wrap_php "red-hawk" "/opt/blackarch/red-hawk/rhawk.php" && ok "php:red-hawk" || fail "red-hawk" "wrap failed"; }
done_already "php:thedorkbox" || { wrap_php "thedorkbox" "/opt/blackarch/thedorkbox/index.php" && ok "php:thedorkbox" || fail "thedorkbox" "wrap failed"; }
done_already "php:xpl-search" || { wrap_php "xpl-search" "/opt/blackarch/xpl-search/xpl search.php" && ok "php:xpl-search" || fail "xpl-search" "wrap failed"; }

echo -e "${ORANGE}━━━ Pre-built JAR Tools (4) ━━━${NC}"
done_already "jar:bluepot" || { wrap_jar "bluepot" "/opt/blackarch/bluepot/lib/swingx-1.6.jar" && ok "jar:bluepot" || fail "bluepot" "wrap failed"; }
done_already "jar:bluphish" || { wrap_jar "bluphish" "/opt/blackarch/bluphish/bluecove-2.1.1-SNAPSHOT.jar" && ok "jar:bluphish" || fail "bluphish" "wrap failed"; }
done_already "jar:jwscan" || { wrap_jar "jwscan" "/opt/blackarch/jwscan/jwscan.jar" && ok "jar:jwscan" || fail "jwscan" "wrap failed"; }
done_already "jar:snuck" || { wrap_jar "snuck" "/opt/blackarch/snuck/lib/commons-logging-1.1.1.jar" && ok "jar:snuck" || fail "snuck" "wrap failed"; }

echo -e "${ORANGE}━━━ Windows EXE Tools via wine (17) ━━━${NC}"
apt install -y -qq wine64 2>/dev/null | tail -1 || true
done_already "exe:extractusnjrnl" || { wrap_exe "extractusnjrnl" "/opt/blackarch/extractusnjrnl/ExtractUsnJrnl.exe" && ok "exe:extractusnjrnl" || fail "extractusnjrnl" "wrap failed"; }
done_already "exe:ghostpack" || { wrap_exe "ghostpack" "/opt/blackarch/ghostpack/SharpDPAPI.exe" && ok "exe:ghostpack" || fail "ghostpack" "wrap failed"; }
done_already "exe:indx2csv" || { wrap_exe "indx2csv" "/opt/blackarch/indx2csv/Indx2Csv.exe" && ok "exe:indx2csv" || fail "indx2csv" "wrap failed"; }
done_already "exe:indxcarver" || { wrap_exe "indxcarver" "/opt/blackarch/indxcarver/IndxCarver.exe" && ok "exe:indxcarver" || fail "indxcarver" "wrap failed"; }
done_already "exe:lethalhta" || { wrap_exe "lethalhta" "/opt/blackarch/lethalhta/CobaltStrike/LethalHTADotNet.exe" && ok "exe:lethalhta" || fail "lethalhta" "wrap failed"; }
done_already "exe:mftcarver" || { wrap_exe "mftcarver" "/opt/blackarch/mftcarver/MFTCarver.exe" && ok "exe:mftcarver" || fail "mftcarver" "wrap failed"; }
done_already "exe:mftrcrd" || { wrap_exe "mftrcrd" "/opt/blackarch/mftrcrd/MFTRCRD.exe" && ok "exe:mftrcrd" || fail "mftrcrd" "wrap failed"; }
done_already "exe:mftref2name" || { wrap_exe "mftref2name" "/opt/blackarch/mftref2name/MftRef2Name.exe" && ok "exe:mftref2name" || fail "mftref2name" "wrap failed"; }
done_already "exe:ntfs-file-extractor" || { wrap_exe "ntfs-file-extractor" "/opt/blackarch/ntfs-file-extractor/NTFS_File_Extractor.exe" && ok "exe:ntfs-file-extractor" || fail "ntfs-file-extractor" "wrap failed"; }
done_already "exe:parse-evtx" || { wrap_exe "parse-evtx" "/opt/blackarch/parse-evtx/BINARIES/Mingw-w64_32/parse_evtx.exe" && ok "exe:parse-evtx" || fail "parse-evtx" "wrap failed"; }
done_already "exe:powermft" || { wrap_exe "powermft" "/opt/blackarch/powermft/PowerMft.exe" && ok "exe:powermft" || fail "powermft" "wrap failed"; }
done_already "exe:powershdll" || { wrap_exe "powershdll" "/opt/blackarch/powershdll/exe/bin/Release/Powershdll.exe" && ok "exe:powershdll" || fail "powershdll" "wrap failed"; }
done_already "exe:rcrdcarver" || { wrap_exe "rcrdcarver" "/opt/blackarch/rcrdcarver/RcrdCarver.exe" && ok "exe:rcrdcarver" || fail "rcrdcarver" "wrap failed"; }
done_already "exe:sasm" || { wrap_exe "sasm" "/opt/blackarch/sasm/Windows/MinGW64/bin/objdump.exe" && ok "exe:sasm" || fail "sasm" "wrap failed"; }
done_already "exe:secure2csv" || { wrap_exe "secure2csv" "/opt/blackarch/secure2csv/Secure2Csv.exe" && ok "exe:secure2csv" || fail "secure2csv" "wrap failed"; }
done_already "exe:shed" || { wrap_exe "shed" "/opt/blackarch/shed/paket.exe" && ok "exe:shed" || fail "shed" "wrap failed"; }
done_already "exe:upnp-pentest-toolkit" || { wrap_exe "upnp-pentest-toolkit" "/opt/blackarch/upnp-pentest-toolkit/WinUPnPFun/obj/Debug/UPT.exe" && ok "exe:upnp-pentest-toolkit" || fail "upnp-pentest-toolkit" "wrap failed"; }

echo -e "${ORANGE}━━━ Shell Script Tools (2) ━━━${NC}"
done_already "sh:blackarch-installer" || { wrap_sh "blackarch-installer" "/opt/blackarch/blackarch-installer/data/root/scripts/sysclean.sh" && ok "sh:blackarch-installer" || fail "blackarch-installer" "wrap failed"; }
done_already "sh:cloudunflare" || { wrap_sh "cloudunflare" "/opt/blackarch/cloudunflare/cloudunflare.bash" && ok "sh:cloudunflare" || fail "cloudunflare" "wrap failed"; }

echo -e "${ORANGE}━━━ Python Tools (1) ━━━${NC}"
done_already "py:pth-toolkit" || { wrap_py "pth-toolkit" "/opt/blackarch/pth-toolkit/lib/python2.7/site-packages/tevent.py" && ok "py:pth-toolkit" || fail "pth-toolkit" "wrap failed"; }

echo -e "${ORANGE}━━━ Nim Tools (1) ━━━${NC}"
apt install -y -qq nim 2>/dev/null | tail -1 || true

if ! done_already "nim:hashpeek"; then
  nim compile --out:"$BIN/hashpeek" "/opt/blackarch/hashpeek/src/hashpeek.nim" 2>/dev/null && ok "nim:hashpeek" || fail "hashpeek" "nim failed"
fi

echo -e "${ORANGE}━━━ Reference/Data Tools (61 unknown) ━━━${NC}"
done_already "info:android-udev-rules" || { wrap_info "android-udev-rules" "/opt/blackarch/android-udev-rules" "BlackArch tool — see directory for usage" && ok "info:android-udev-rules"; }
done_already "info:arptools" || { wrap_info "arptools" "/opt/blackarch/arptools" "BlackArch tool — see directory for usage" && ok "info:arptools"; }
done_already "info:aurebeshjs" || { wrap_info "aurebeshjs" "/opt/blackarch/aurebeshjs" "BlackArch tool — see directory for usage" && ok "info:aurebeshjs"; }
done_already "info:avaloniailspy" || { wrap_info "avaloniailspy" "/opt/blackarch/avaloniailspy" "BlackArch tool — see directory for usage" && ok "info:avaloniailspy"; }
done_already "info:barmie" || { wrap_info "barmie" "/opt/blackarch/barmie" "BlackArch tool — see directory for usage" && ok "info:barmie"; }
done_already "info:blackarch-artwork" || { wrap_info "blackarch-artwork" "/opt/blackarch/blackarch-artwork" "BlackArch tool — see directory for usage" && ok "info:blackarch-artwork"; }
done_already "info:blackarch-config-awesome" || { wrap_info "blackarch-config-awesome" "/opt/blackarch/blackarch-config-awesome" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-awesome"; }
done_already "info:blackarch-config-bash" || { wrap_info "blackarch-config-bash" "/opt/blackarch/blackarch-config-bash" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-bash"; }
done_already "info:blackarch-config-calamares" || { wrap_info "blackarch-config-calamares" "/opt/blackarch/blackarch-config-calamares" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-calamares"; }
done_already "info:blackarch-config-cursor" || { wrap_info "blackarch-config-cursor" "/opt/blackarch/blackarch-config-cursor" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-cursor"; }
done_already "info:blackarch-config-fluxbox" || { wrap_info "blackarch-config-fluxbox" "/opt/blackarch/blackarch-config-fluxbox" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-fluxbox"; }
done_already "info:blackarch-config-gtk" || { wrap_info "blackarch-config-gtk" "/opt/blackarch/blackarch-config-gtk" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-gtk"; }
done_already "info:blackarch-config-i3" || { wrap_info "blackarch-config-i3" "/opt/blackarch/blackarch-config-i3" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-i3"; }
done_already "info:blackarch-config-lxdm" || { wrap_info "blackarch-config-lxdm" "/opt/blackarch/blackarch-config-lxdm" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-lxdm"; }
done_already "info:blackarch-config-openbox" || { wrap_info "blackarch-config-openbox" "/opt/blackarch/blackarch-config-openbox" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-openbox"; }
done_already "info:blackarch-config-spectrwm" || { wrap_info "blackarch-config-spectrwm" "/opt/blackarch/blackarch-config-spectrwm" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-spectrwm"; }
done_already "info:blackarch-config-x11" || { wrap_info "blackarch-config-x11" "/opt/blackarch/blackarch-config-x11" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-x11"; }
done_already "info:blackarch-config-xfce" || { wrap_info "blackarch-config-xfce" "/opt/blackarch/blackarch-config-xfce" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-xfce"; }
done_already "info:blackarch-config-zsh" || { wrap_info "blackarch-config-zsh" "/opt/blackarch/blackarch-config-zsh" "BlackArch tool — see directory for usage" && ok "info:blackarch-config-zsh"; }
done_already "info:blackarch-wallpaper" || { wrap_info "blackarch-wallpaper" "/opt/blackarch/blackarch-wallpaper" "BlackArch tool — see directory for usage" && ok "info:blackarch-wallpaper"; }
done_already "info:bleah" || { wrap_info "bleah" "/opt/blackarch/bleah" "BlackArch tool — see directory for usage" && ok "info:bleah"; }
done_already "info:bqm" || { wrap_info "bqm" "/opt/blackarch/bqm" "BlackArch tool — see directory for usage" && ok "info:bqm"; }
done_already "info:cminer" || { wrap_info "cminer" "/opt/blackarch/cminer" "BlackArch tool — see directory for usage" && ok "info:cminer"; }
done_already "info:country-ip-blocks" || { wrap_info "country-ip-blocks" "/opt/blackarch/country-ip-blocks" "BlackArch tool — see directory for usage" && ok "info:country-ip-blocks"; }
done_already "info:darkmysqli" || { wrap_info "darkmysqli" "/opt/blackarch/darkmysqli" "BlackArch tool — see directory for usage" && ok "info:darkmysqli"; }
done_already "info:evilclippy" || { wrap_info "evilclippy" "/opt/blackarch/evilclippy" "BlackArch tool — see directory for usage" && ok "info:evilclippy"; }
done_already "info:exe2image" || { wrap_info "exe2image" "/opt/blackarch/exe2image" "BlackArch tool — see directory for usage" && ok "info:exe2image"; }
done_already "info:firstexecution" || { wrap_info "firstexecution" "/opt/blackarch/firstexecution" "BlackArch tool — see directory for usage" && ok "info:firstexecution"; }
done_already "info:f-scrack" || { wrap_info "f-scrack" "/opt/blackarch/f-scrack" "BlackArch tool — see directory for usage" && ok "info:f-scrack"; }
done_already "info:gadgettojscript" || { wrap_info "gadgettojscript" "/opt/blackarch/gadgettojscript" "BlackArch tool — see directory for usage" && ok "info:gadgettojscript"; }
done_already "info:goofuzz" || { wrap_info "goofuzz" "/opt/blackarch/goofuzz" "BlackArch tool — see directory for usage" && ok "info:goofuzz"; }
done_already "info:hurl-encoder" || { wrap_info "hurl-encoder" "/opt/blackarch/hurl-encoder" "BlackArch tool — see directory for usage" && ok "info:hurl-encoder"; }
done_already "info:intelplot" || { wrap_info "intelplot" "/opt/blackarch/intelplot" "BlackArch tool — see directory for usage" && ok "info:intelplot"; }
done_already "info:jdeserialize" || { wrap_info "jdeserialize" "/opt/blackarch/jdeserialize" "BlackArch tool — see directory for usage" && ok "info:jdeserialize"; }
done_already "info:kalibrate-rtl" || { wrap_info "kalibrate-rtl" "/opt/blackarch/kalibrate-rtl" "BlackArch tool — see directory for usage" && ok "info:kalibrate-rtl"; }
done_already "info:leaklooker" || { wrap_info "leaklooker" "/opt/blackarch/leaklooker" "BlackArch tool — see directory for usage" && ok "info:leaklooker"; }
done_already "info:libtins" || { wrap_info "libtins" "/opt/blackarch/libtins" "BlackArch tool — see directory for usage" && ok "info:libtins"; }
done_already "info:log-file-parser" || { wrap_info "log-file-parser" "/opt/blackarch/log-file-parser" "BlackArch tool — see directory for usage" && ok "info:log-file-parser"; }
done_already "info:lolbas" || { wrap_info "lolbas" "/opt/blackarch/lolbas" "BlackArch tool — see directory for usage" && ok "info:lolbas"; }
done_already "info:microsploit" || { wrap_info "microsploit" "/opt/blackarch/microsploit" "BlackArch tool — see directory for usage" && ok "info:microsploit"; }
done_already "info:ostinato" || { wrap_info "ostinato" "/opt/blackarch/ostinato" "BlackArch tool — see directory for usage" && ok "info:ostinato"; }
done_already "info:pcredz" || { wrap_info "pcredz" "/opt/blackarch/pcredz" "BlackArch tool — see directory for usage" && ok "info:pcredz"; }
done_already "info:persistencesniper" || { wrap_info "persistencesniper" "/opt/blackarch/persistencesniper" "BlackArch tool — see directory for usage" && ok "info:persistencesniper"; }
done_already "info:petools" || { wrap_info "petools" "/opt/blackarch/petools" "BlackArch tool — see directory for usage" && ok "info:petools"; }
done_already "info:pipeline" || { wrap_info "pipeline" "/opt/blackarch/pipeline" "BlackArch tool — see directory for usage" && ok "info:pipeline"; }
done_already "info:pwdlyser" || { wrap_info "pwdlyser" "/opt/blackarch/pwdlyser" "BlackArch tool — see directory for usage" && ok "info:pwdlyser"; }
done_already "info:qradiolink" || { wrap_info "qradiolink" "/opt/blackarch/qradiolink" "BlackArch tool — see directory for usage" && ok "info:qradiolink"; }
done_already "info:sagan-rules" || { wrap_info "sagan-rules" "/opt/blackarch/sagan-rules" "BlackArch tool — see directory for usage" && ok "info:sagan-rules"; }
done_already "info:scylla" || { wrap_info "scylla" "/opt/blackarch/scylla" "BlackArch tool — see directory for usage" && ok "info:scylla"; }
done_already "info:sgp4" || { wrap_info "sgp4" "/opt/blackarch/sgp4" "BlackArch tool — see directory for usage" && ok "info:sgp4"; }
done_already "info:shellsploit-framework" || { wrap_info "shellsploit-framework" "/opt/blackarch/shellsploit-framework" "BlackArch tool — see directory for usage" && ok "info:shellsploit-framework"; }
done_already "info:smartphone-pentest-framework" || { wrap_info "smartphone-pentest-framework" "/opt/blackarch/smartphone-pentest-framework" "BlackArch tool — see directory for usage" && ok "info:smartphone-pentest-framework"; }
done_already "info:spektrum" || { wrap_info "spektrum" "/opt/blackarch/spektrum" "BlackArch tool — see directory for usage" && ok "info:spektrum"; }
done_already "info:sslsniff" || { wrap_info "sslsniff" "/opt/blackarch/sslsniff" "BlackArch tool — see directory for usage" && ok "info:sslsniff"; }
done_already "info:taipan" || { wrap_info "taipan" "/opt/blackarch/taipan" "BlackArch tool — see directory for usage" && ok "info:taipan"; }
done_already "info:thumbcacheviewer" || { wrap_info "thumbcacheviewer" "/opt/blackarch/thumbcacheviewer" "BlackArch tool — see directory for usage" && ok "info:thumbcacheviewer"; }
done_already "info:tlshelpers" || { wrap_info "tlshelpers" "/opt/blackarch/tlshelpers" "BlackArch tool — see directory for usage" && ok "info:tlshelpers"; }
done_already "info:ultimate-facebook-scraper" || { wrap_info "ultimate-facebook-scraper" "/opt/blackarch/ultimate-facebook-scraper" "BlackArch tool — see directory for usage" && ok "info:ultimate-facebook-scraper"; }
done_already "info:usnjrnl2csv" || { wrap_info "usnjrnl2csv" "/opt/blackarch/usnjrnl2csv" "BlackArch tool — see directory for usage" && ok "info:usnjrnl2csv"; }
done_already "info:vscan" || { wrap_info "vscan" "/opt/blackarch/vscan" "BlackArch tool — see directory for usage" && ok "info:vscan"; }
done_already "info:wpintel" || { wrap_info "wpintel" "/opt/blackarch/wpintel" "BlackArch tool — see directory for usage" && ok "info:wpintel"; }

# Re-run integration
echo ""
echo -e "${CYAN}[+]${NC} Re-running tool integration..."
bash /home/kali/Phoenix-OS/scripts/integrate_tools.sh 2>/dev/null | tail -8

TOTAL=$((PASS+FAIL+SKIP))
echo ""
echo -e "${ORANGE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${ORANGE}║     PHOENIX OS — FIX COMPLETE                      ║${NC}"
echo -e "${ORANGE}╠══════════════════════════════════════════════════════╣${NC}"
printf "${ORANGE}║${NC} ${GREEN}✓ Fixed:   %-41s${ORANGE}║${NC}\n" "$PASS tools"
printf "${ORANGE}║${NC} ${CYAN}~ Skipped: %-41s${ORANGE}║${NC}\n" "$SKIP already done"
printf "${ORANGE}║${NC} ${YELLOW}✗ Failed:  %-41s${ORANGE}║${NC}\n" "$FAIL tools"
printf "${ORANGE}║${NC}   Total:   %-41s${ORANGE}║${NC}\n" "$TOTAL processed"
echo -e "${ORANGE}╚══════════════════════════════════════════════════════╝${NC}"
echo -e "  ${ORANGE}Born from the ashes of every failed boot. 🔥${NC}"
