"""
Phoenix OS — Pre-built Attack Wrappers
AI-callable functions for common pentest workflows.
Each wrapper builds the right command, runs it via ToolExecutor,
and returns structured output the LLM can reason about.

Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))

from src.tools.executor import ToolExecutor, ToolResult

_ex = ToolExecutor()


# ══════════════════════════════════════════════════════════════
# RECON WRAPPERS
# ══════════════════════════════════════════════════════════════

def nmap_quick(target: str) -> ToolResult:
    """Fast top-1000 port scan with version detection."""
    return _ex.run("nmap", ["-sV", "--open", "-T4", target], timeout=120)

def nmap_full(target: str) -> ToolResult:
    """Full 65535 port scan with service/OS detection and default scripts."""
    return _ex.run("nmap", ["-sV", "-sC", "-O", "-p-", "--open", "-T4", target], timeout=600)

def nmap_udp(target: str) -> ToolResult:
    """Top UDP port scan — finds SNMP, DNS, NTP misconfigs."""
    return _ex.run("nmap", ["-sU", "--top-ports", "200", "-T4", target], timeout=300)

def nmap_vuln(target: str) -> ToolResult:
    """Run nmap vuln scripts against target."""
    return _ex.run("nmap", ["-sV", "--script=vuln", target], timeout=300)

def nmap_smb(target: str) -> ToolResult:
    """SMB-focused scan — finds shares, version, EternalBlue exposure."""
    return _ex.run("nmap", [
        "-p", "139,445",
        "--script", "smb-enum-shares,smb-enum-users,smb-vuln-ms17-010,smb2-security-mode",
        target
    ], timeout=120)

def masscan_sweep(target_range: str, ports: str = "0-65535", rate: int = 50000) -> ToolResult:
    """Blazing fast port sweep across large ranges — use before nmap."""
    return _ex.run("masscan", [target_range, f"-p{ports}", f"--rate={rate}"], timeout=300)

def theharvester_osint(domain: str, sources: str = "google,bing,linkedin,duckduckgo") -> ToolResult:
    """Harvest emails, subdomains, IPs from public sources."""
    return _ex.run("theHarvester", ["-d", domain, "-b", sources, "-l", "300"], timeout=180)

def amass_enum(domain: str, passive: bool = True) -> ToolResult:
    """Enumerate subdomains. passive=True for stealth, False for active brute."""
    args = ["enum", "-d", domain]
    if passive:
        args.append("-passive")
    return _ex.run("amass", args, timeout=300)

def subfinder_passive(domain: str) -> ToolResult:
    """Fast passive subdomain enumeration."""
    return _ex.run("subfinder", ["-d", domain, "-all", "-silent"], timeout=120)

def whatweb_fingerprint(url: str, aggression: int = 3) -> ToolResult:
    """Fingerprint web tech stack — CMS, framework, server version."""
    return _ex.run("whatweb", [f"-a{aggression}", url], timeout=60)

def wafw00f_detect(url: str) -> ToolResult:
    """Detect WAF presence and vendor."""
    return _ex.run("wafw00f", [url, "-a"], timeout=60)

def nikto_scan(url: str) -> ToolResult:
    """Web server vulnerability scan — misconfigs, dangerous files, outdated software."""
    return _ex.run("nikto", ["-h", url, "-C", "all"], timeout=300)


# ══════════════════════════════════════════════════════════════
# WEB ATTACK WRAPPERS
# ══════════════════════════════════════════════════════════════

def ffuf_dirbrute(url: str, wordlist: str = "/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt",
                  extensions: str = "php,html,txt,js,bak") -> ToolResult:
    """Directory and file brute-force with common extensions."""
    return _ex.run("ffuf", [
        "-u", f"{url}/FUZZ",
        "-w", wordlist,
        "-e", f".{extensions.replace(',', ',.')}",
        "-mc", "200,201,204,301,302,307,401,403",
        "-t", "50",
        "-c",
    ], timeout=300)

def ffuf_vhost(domain: str, ip: str,
               wordlist: str = "/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt") -> ToolResult:
    """Virtual host discovery — finds hidden vhosts on shared IP."""
    return _ex.run("ffuf", [
        "-u", f"http://{ip}/",
        "-H", f"Host: FUZZ.{domain}",
        "-w", wordlist,
        "-mc", "200,204,301,302",
        "-t", "40",
    ], timeout=180)

def ffuf_param_fuzz(url: str, wordlist: str = "/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt") -> ToolResult:
    """Parameter name fuzzing — finds hidden GET parameters."""
    return _ex.run("ffuf", [
        "-u", f"{url}?FUZZ=test",
        "-w", wordlist,
        "-mc", "200",
        "-t", "40",
    ], timeout=120)

def sqlmap_scan(url: str, data: str = None, level: int = 2, risk: int = 2) -> ToolResult:
    """Automated SQLi detection and exploitation."""
    args = ["-u", url, "--batch", f"--level={level}", f"--risk={risk}", "--dbs"]
    if data:
        args += ["--data", data, "--method", "POST"]
    return _ex.run("sqlmap", args, timeout=300)

def sqlmap_dump(url: str, db: str, table: str = None) -> ToolResult:
    """Dump a specific database or table via SQLi."""
    args = ["-u", url, "--batch", "-D", db]
    if table:
        args += ["-T", table, "--dump"]
    else:
        args += ["--tables"]
    return _ex.run("sqlmap", args, timeout=300)

def nuclei_scan(url: str, severity: str = "critical,high,medium",
                templates: str = "cves,exposures,misconfiguration") -> ToolResult:
    """Template-based CVE and misconfiguration scan."""
    return _ex.run("nuclei", [
        "-u", url,
        "-t", templates,
        "-severity", severity,
        "-silent",
    ], timeout=300)

def wpscan_enum(url: str, api_token: str = None) -> ToolResult:
    """WordPress enumeration — users, plugins, themes, vulns."""
    args = ["--url", url, "--enumerate", "u,p,t", "--random-user-agent"]
    if api_token:
        args += ["--api-token", api_token]
    return _ex.run("wpscan", args, timeout=180)


# ══════════════════════════════════════════════════════════════
# PASSWORD ATTACK WRAPPERS
# ══════════════════════════════════════════════════════════════

def hashcat_ntlm(hashfile: str, wordlist: str = "/usr/share/wordlists/rockyou.txt",
                 rules: bool = True) -> ToolResult:
    """Crack NTLM hashes (mode 1000) with rockyou + best64 rules."""
    args = ["-m", "1000", hashfile, wordlist, "--force"]
    if rules:
        args += ["-r", "/usr/share/hashcat/rules/best64.rule"]
    return _ex.run("hashcat", args, timeout=1800)

def hashcat_auto(hashfile: str, hash_mode: int,
                 wordlist: str = "/usr/share/wordlists/rockyou.txt") -> ToolResult:
    """Crack arbitrary hash type — provide hashcat mode number."""
    return _ex.run("hashcat", ["-m", str(hash_mode), hashfile, wordlist, "--force"], timeout=1800)

def john_crack(hashfile: str, wordlist: str = "/usr/share/wordlists/rockyou.txt",
               format_hint: str = None) -> ToolResult:
    """John the Ripper wordlist attack."""
    args = [f"--wordlist={wordlist}", hashfile]
    if format_hint:
        args.insert(0, f"--format={format_hint}")
    return _ex.run("john", args, timeout=1800)

def hydra_ssh(target: str, username: str, wordlist: str = "/usr/share/wordlists/rockyou.txt",
              threads: int = 4) -> ToolResult:
    """Brute force SSH login."""
    return _ex.run("hydra", [
        "-l", username, "-P", wordlist,
        "-t", str(threads), "-V",
        target, "ssh"
    ], timeout=600)

def hydra_http_form(target: str, path: str, user_field: str, pass_field: str,
                    username: str, wordlist: str, fail_string: str) -> ToolResult:
    """Brute force HTTP POST login form."""
    post_data = f"{user_field}={username}&{pass_field}=^PASS^"
    return _ex.run("hydra", [
        "-l", username, "-P", wordlist,
        target, "http-post-form",
        f"{path}:{post_data}:{fail_string}"
    ], timeout=600)

def hydra_smb(target: str, username: str, wordlist: str) -> ToolResult:
    """Brute force SMB credentials."""
    return _ex.run("hydra", ["-l", username, "-P", wordlist, target, "smb"], timeout=300)


# ══════════════════════════════════════════════════════════════
# WIRELESS ATTACK WRAPPERS
# ══════════════════════════════════════════════════════════════

def airodump_scan(interface: str = "wlan1mon", output: str = "/tmp/capture") -> ToolResult:
    """Scan for all visible APs and clients."""
    return _ex.run("airodump-ng", [interface, "-w", output, "--output-format", "csv"], timeout=30)

def airodump_target(interface: str, bssid: str, channel: int,
                    output: str = "/tmp/handshake") -> ToolResult:
    """Capture handshake from specific AP."""
    return _ex.run("airodump-ng", [
        interface,
        "--bssid", bssid,
        "-c", str(channel),
        "-w", output,
    ], timeout=120)

def aireplay_deauth(interface: str, bssid: str, client: str = None,
                    count: int = 10) -> ToolResult:
    """Send deauth frames to force WPA handshake."""
    args = ["-0", str(count), "-a", bssid]
    if client:
        args += ["-c", client]
    args.append(interface)
    return _ex.run("aireplay-ng", args, timeout=30)

def aircrack_wpa(capfile: str, wordlist: str = "/usr/share/wordlists/rockyou.txt",
                 bssid: str = None) -> ToolResult:
    """Crack WPA handshake from capture file."""
    args = [capfile, "-w", wordlist]
    if bssid:
        args += ["-b", bssid]
    return _ex.run("aircrack-ng", args, timeout=1800)


# ══════════════════════════════════════════════════════════════
# ACTIVE DIRECTORY WRAPPERS
# ══════════════════════════════════════════════════════════════

def cme_smb_enum(target: str, username: str = None, password: str = None,
                 hash_val: str = None) -> ToolResult:
    """CME SMB enumeration — shares, users, password policy."""
    args = ["smb", target, "--shares", "--users", "--pass-pol"]
    if username:
        args += ["-u", username]
    if hash_val:
        args += ["-H", hash_val]
    elif password:
        args += ["-p", password]
    return _ex.run("crackmapexec", args, timeout=120)

def cme_spray(target_range: str, username_file: str, password: str) -> ToolResult:
    """Password spray against SMB — single password, many users."""
    return _ex.run("crackmapexec", [
        "smb", target_range,
        "-u", username_file,
        "-p", password,
        "--continue-on-success",
    ], timeout=300)

def cme_exec(target: str, username: str, password: str, command: str) -> ToolResult:
    """Execute command on Windows target via SMB."""
    return _ex.run("crackmapexec", [
        "smb", target,
        "-u", username, "-p", password,
        "-x", command,
    ], timeout=60)

def enum4linux_full(target: str) -> ToolResult:
    """Full SMB/LDAP enumeration — users, groups, shares, password policy."""
    return _ex.run("enum4linux-ng", ["-A", target], timeout=120)

def secretsdump(target: str, username: str, password: str = None,
                hash_val: str = None, domain: str = ".") -> ToolResult:
    """Dump SAM/NTDS hashes via impacket secretsdump."""
    if hash_val:
        creds = f"{domain}/{username}@{target}"
        args = [creds, "-hashes", f":{hash_val}"]
    else:
        creds = f"{domain}/{username}:{password}@{target}"
        args = [creds]
    args.append("-just-dc-ntlm")
    return _ex.run("impacket-secretsdump", args, timeout=120)


# ══════════════════════════════════════════════════════════════
# UTILITY WRAPPERS
# ══════════════════════════════════════════════════════════════

def whois_lookup(domain: str) -> ToolResult:
    return _ex.run("whois", [domain], timeout=30)

def dig_any(domain: str) -> ToolResult:
    """Get all DNS records for a domain."""
    return _ex.run("dig", [domain, "ANY", "+noall", "+answer"], timeout=30)

def sslscan_target(host: str, port: int = 443) -> ToolResult:
    """Scan SSL/TLS config — weak ciphers, protocol versions, cert info."""
    return _ex.run("sslscan", [f"{host}:{port}", "--show-certificate"], timeout=60)

def tcpdump_capture(interface: str = "eth0", output: str = "/tmp/capture.pcap",
                    duration: int = 30, filter_expr: str = "") -> ToolResult:
    """Capture network traffic to pcap file."""
    args = ["-i", interface, "-w", output, "-G", str(duration), "-W", "1"]
    if filter_expr:
        args.append(filter_expr)
    return _ex.run("tcpdump", args, timeout=duration + 10)


# ══════════════════════════════════════════════════════════════
# WRAPPER INDEX — maps tool registry keys → wrapper functions
# ══════════════════════════════════════════════════════════════

WRAPPER_MAP = {
    # Recon
    "nmap":           {"quick": nmap_quick, "full": nmap_full, "udp": nmap_udp,
                       "vuln": nmap_vuln, "smb": nmap_smb},
    "masscan":        {"sweep": masscan_sweep},
    "theharvester":   {"osint": theharvester_osint},
    "amass":          {"enum": amass_enum},
    "subfinder":      {"passive": subfinder_passive},
    "whatweb":        {"fingerprint": whatweb_fingerprint},
    "wafw00f":        {"detect": wafw00f_detect},
    "nikto":          {"scan": nikto_scan},
    # Web
    "ffuf":           {"dirbrute": ffuf_dirbrute, "vhost": ffuf_vhost, "param": ffuf_param_fuzz},
    "sqlmap":         {"scan": sqlmap_scan, "dump": sqlmap_dump},
    "nuclei":         {"scan": nuclei_scan},
    "wpscan":         {"enum": wpscan_enum},
    # Password
    "hashcat":        {"ntlm": hashcat_ntlm, "auto": hashcat_auto},
    "john":           {"crack": john_crack},
    "hydra":          {"ssh": hydra_ssh, "http_form": hydra_http_form, "smb": hydra_smb},
    # Wireless
    "airodump-ng":    {"scan": airodump_scan, "target": airodump_target},
    "aireplay-ng":    {"deauth": aireplay_deauth},
    "aircrack-ng":    {"wpa": aircrack_wpa},
    # AD
    "crackmapexec":   {"smb_enum": cme_smb_enum, "spray": cme_spray, "exec": cme_exec},
    "enum4linux":     {"full": enum4linux_full},
    "impacket":       {"secretsdump": secretsdump},
    # Utility
    "tcpdump":        {"capture": tcpdump_capture},
    "sslscan":        {"target": sslscan_target},
}
