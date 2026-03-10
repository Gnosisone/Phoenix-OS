#!/usr/bin/env python3
"""
Phoenix OS — Main Entry Point
Usage:
  python3 main.py              # Boot Phoenix OS (dashboard + ERR0RS)
  python3 main.py --status     # Show system status
  python3 main.py --hud        # Live hardware HUD
  python3 main.py --vault      # Vault management
  python3 main.py --wireless   # Wireless stack status

Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import sys
import time
import signal
import argparse

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def main():
    parser = argparse.ArgumentParser(
        description="Phoenix OS — AI-Powered Pi 5 Pentest Field Unit",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 main.py              Boot Phoenix OS
  python3 main.py --status     System status JSON
  python3 main.py --hud        Live hardware monitor
  python3 main.py --wireless   Wireless stack info
  python3 main.py --vault list List engagements
        """
    )
    parser.add_argument("--status",   action="store_true", help="Show system status")
    parser.add_argument("--hud",      action="store_true", help="Live hardware HUD")
    parser.add_argument("--wireless", action="store_true", help="Wireless stack status")
    parser.add_argument("--vault",    choices=["list","new","wipe"], help="Vault management")
    parser.add_argument("--no-errz",  action="store_true", help="Boot without launching ERR0RS UI")
    parser.add_argument("--client",   type=str, help="Client name for new engagement")
    parser.add_argument("--scope",    type=str, nargs="+", help="Scope IPs/domains for engagement")
    args = parser.parse_args()

    # ── Live HUD mode ──────────────────────────────────────────────────────────
    if args.hud:
        from src.ui.phoenix_dashboard import live_hud
        live_hud()
        return

    # ── Status mode ───────────────────────────────────────────────────────────
    if args.status:
        import json
        from src.core.system import PhoenixSystem
        sys_mgr = PhoenixSystem()
        print(json.dumps(sys_mgr.get_status(), indent=2, default=str))
        return

    # ── Wireless mode ─────────────────────────────────────────────────────────
    if args.wireless:
        import json
        from src.network.wireless import WirelessStack
        ws = WirelessStack()
        print(json.dumps(ws.get_status(), indent=2))
        networks = ws.scan_networks()
        if networks:
            print(f"\nNetworks found: {len(networks)}")
            for n in networks:
                enc = "🔒" if n.get("encrypted") else "🔓"
                print(f"  {enc} {n.get('ssid','<hidden>')} | {n.get('bssid','')} | {n.get('signal','?')} dBm")
        return

    # ── Vault mode ────────────────────────────────────────────────────────────
    if args.vault:
        from src.security.vault import PhoenixVault
        vault = PhoenixVault()
        if args.vault == "list":
            engagements = vault.list_engagements()
            if not engagements:
                print("No engagements in vault.")
            for e in engagements:
                print(f"  [{e.get('status','?')}] {e.get('engagement_id')} — {e.get('client','?')}")
        elif args.vault == "new":
            if not args.client:
                print("Error: --client NAME required for new engagement")
                sys.exit(1)
            scope = args.scope or []
            eng_id = vault.new_engagement(args.client, scope)
            print(f"✓ New engagement created: {eng_id}")
        print(f"\nVault stats: {vault.get_vault_stats()}")
        return

    # ── Default: Full boot sequence ───────────────────────────────────────────
    from src.ui.phoenix_dashboard import animated_boot
    from src.core.system import PhoenixSystem

    # Animated boot screen
    animated_boot()

    # Initialize system
    sys_mgr = PhoenixSystem()

    # Launch ERR0RS unless --no-errz
    if not args.no_errz:
        sys_mgr.launch_errz()

    # Handle clean shutdown on Ctrl+C
    def _shutdown(sig, frame):
        print("\n")
        sys_mgr.shutdown()
        sys.exit(0)

    signal.signal(signal.SIGINT, _shutdown)
    signal.signal(signal.SIGTERM, _shutdown)

    print("\n  Phoenix OS running — press Ctrl+C to shutdown\n")

    # Keep alive
    while True:
        time.sleep(5)
        # Restart ERR0RS if it crashes
        if not args.no_errz and sys_mgr.errz_proc:
            if sys_mgr.errz_proc.poll() is not None:
                print("  ERR0RS crashed — restarting...")
                sys_mgr.launch_errz()


if __name__ == "__main__":
    main()
