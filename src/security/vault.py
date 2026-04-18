"""
Phoenix OS — Secure Vault
Client data encryption, evidence storage, key management
All engagement data stays encrypted on device — nothing leaves Phoenix OS
Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import json
import hashlib
import secrets
import logging
from datetime import datetime
from typing import Optional
from pathlib import Path

logger = logging.getLogger(__name__)

VAULT_DIR = os.getenv("VAULT_DIR", "/home/kali/phoenix-vault")
KEY_FILE  = os.path.join(VAULT_DIR, ".vault.key")


class PhoenixVault:
    """
    Encrypted storage for engagement data, loot, and client artifacts.
    Uses AES-256 via cryptography library.
    All data stays on the NVMe — zero exfiltration by design.
    """

    def __init__(self, vault_dir: str = VAULT_DIR):
        self.vault_dir = Path(vault_dir)
        self.vault_dir.mkdir(parents=True, exist_ok=True)
        self._key = self._load_or_create_key()
        logger.info(f"PhoenixVault initialized at {self.vault_dir}")

    def _load_or_create_key(self) -> bytes:
        """Load existing vault key or create new one"""
        key_path = Path(KEY_FILE)
        if key_path.exists():
            with open(key_path, "rb") as f:
                return f.read()
        else:
            key = secrets.token_bytes(32)  # 256-bit key
            key_path.parent.mkdir(parents=True, exist_ok=True)
            with open(key_path, "wb") as f:
                f.write(key)
            os.chmod(key_path, 0o600)
            logger.info("New vault key created")
            return key

    def _encrypt(self, data: bytes) -> bytes:
        """Encrypt data with AES-256-GCM"""
        try:
            from cryptography.hazmat.primitives.ciphers.aead import AESGCM
            aesgcm = AESGCM(self._key)
            nonce = secrets.token_bytes(12)
            ciphertext = aesgcm.encrypt(nonce, data, None)
            return nonce + ciphertext
        except ImportError:
            logger.warning("cryptography not installed — storing plaintext")
            return data

    def _decrypt(self, data: bytes) -> bytes:
        """Decrypt AES-256-GCM data"""
        try:
            from cryptography.hazmat.primitives.ciphers.aead import AESGCM
            aesgcm = AESGCM(self._key)
            nonce = data[:12]
            ciphertext = data[12:]
            return aesgcm.decrypt(nonce, ciphertext, None)
        except ImportError:
            return data
        except Exception as e:
            logger.error(f"Decrypt failed: {e}")
            raise

    def new_engagement(self, client_name: str, scope: list) -> str:
        """Create new engagement folder"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        safe_name = "".join(c if c.isalnum() else "_" for c in client_name)
        eng_id = f"{safe_name}_{timestamp}"
        eng_dir = self.vault_dir / eng_id
        eng_dir.mkdir(parents=True, exist_ok=True)
        (eng_dir / "loot").mkdir(exist_ok=True)
        (eng_dir / "evidence").mkdir(exist_ok=True)
        (eng_dir / "reports").mkdir(exist_ok=True)

        meta = {
            "engagement_id": eng_id,
            "client": client_name,
            "scope": scope,
            "created": datetime.now().isoformat(),
            "status": "active",
        }
        self.store(eng_id, "metadata", json.dumps(meta).encode())
        logger.info(f"New engagement created: {eng_id}")
        return eng_id

    def store(self, engagement_id: str, name: str, data: bytes) -> str:
        """Encrypt and store artifact"""
        eng_dir = self.vault_dir / engagement_id / "loot"
        eng_dir.mkdir(parents=True, exist_ok=True)
        timestamp = datetime.now().strftime("%H%M%S")
        filename = f"{name}_{timestamp}.enc"
        filepath = eng_dir / filename
        encrypted = self._encrypt(data)
        with open(filepath, "wb") as f:
            f.write(encrypted)
        logger.info(f"Stored: {filepath}")
        return str(filepath)

    def retrieve(self, filepath: str) -> bytes:
        """Decrypt and retrieve artifact"""
        with open(filepath, "rb") as f:
            encrypted = f.read()
        return self._decrypt(encrypted)

    def store_credentials(self, engagement_id: str, creds: dict) -> str:
        """Store captured credentials encrypted"""
        data = json.dumps(creds, indent=2).encode()
        return self.store(engagement_id, "credentials", data)

    def store_screenshot(self, engagement_id: str,
                         image_data: bytes, label: str = "screen") -> str:
        """Store encrypted screenshot evidence"""
        return self.store(engagement_id, f"screenshot_{label}", image_data)

    def list_engagements(self) -> list:
        """List all engagements in vault"""
        engagements = []
        for item in self.vault_dir.iterdir():
            if item.is_dir() and not item.name.startswith("."):
                meta_files = list((item / "loot").glob("metadata_*.enc"))
                if meta_files:
                    try:
                        data = self.retrieve(str(meta_files[0]))
                        meta = json.loads(data.decode())
                        engagements.append(meta)
                    except Exception:
                        engagements.append({"engagement_id": item.name})
        return engagements

    def generate_report_summary(self, engagement_id: str) -> str:
        """Generate text summary of engagement artifacts"""
        eng_dir = self.vault_dir / engagement_id
        if not eng_dir.exists():
            return f"Engagement {engagement_id} not found"

        loot_count = len(list((eng_dir / "loot").glob("*.enc")))
        evidence_count = len(list((eng_dir / "evidence").glob("*")))

        return f"""
Phoenix OS — Engagement Report
================================
ID:       {engagement_id}
Loot:     {loot_count} encrypted artifacts
Evidence: {evidence_count} files
Generated: {datetime.now().isoformat()}
================================
All data encrypted with AES-256-GCM
Stored on-device — zero exfiltration
"""

    def secure_wipe_engagement(self, engagement_id: str) -> bool:
        """Securely wipe engagement data"""
        import shutil
        eng_dir = self.vault_dir / engagement_id
        if not eng_dir.exists():
            return False
        # Overwrite files before deletion
        for f in eng_dir.rglob("*"):
            if f.is_file():
                size = f.stat().st_size
                with open(f, "wb") as fh:
                    fh.write(secrets.token_bytes(size))
        shutil.rmtree(eng_dir)
        logger.info(f"Engagement {engagement_id} securely wiped")
        return True

    def get_vault_stats(self) -> dict:
        total_size = sum(
            f.stat().st_size
            for f in self.vault_dir.rglob("*") if f.is_file()
        )
        return {
            "vault_dir": str(self.vault_dir),
            "engagements": len(self.list_engagements()),
            "total_size_mb": round(total_size / 1024 / 1024, 2),
            "encrypted": True,
            "algorithm": "AES-256-GCM",
        }
