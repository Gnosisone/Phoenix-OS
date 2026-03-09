"""
Phoenix OS — Hailo-10H NPU Integration
Bridges ERR0RS AI agents to the Hailo-10H hardware accelerator
Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import logging
from typing import Optional

logger = logging.getLogger(__name__)

HAILO_ENABLED = os.getenv("HAILO_ENABLED", "false").lower() == "true"
PI5_MODE = os.getenv("PI5_MODE", "false").lower() == "true"


class HailoNPU:
    """
    Interface to the Hailo-10H AI HAT+ (26 TOPS)
    Handles model loading, inference routing, and fallback to CPU/Ollama
    """

    def __init__(self):
        self.available = False
        self.device = None
        self.runner = None
        self._init_hailo()

    def _init_hailo(self):
        """Attempt to initialize Hailo-10H hardware"""
        if not HAILO_ENABLED:
            logger.info("Hailo NPU disabled (HAILO_ENABLED=false)")
            return
        try:
            import hailo_platform as hp
            devices = hp.Device.scan()
            if devices:
                self.device = hp.VDevice()
                self.available = True
                logger.info(f"✓ Hailo-10H initialized | Device: {devices[0]}")
            else:
                logger.warning("Hailo-10H not detected — falling back to CPU/Ollama")
        except ImportError:
            logger.warning("hailort not installed — run: pip3 install hailort")
        except Exception as e:
            logger.warning(f"Hailo init failed: {e} — falling back to Ollama")

    def is_available(self) -> bool:
        return self.available

    def load_model(self, hef_path: str) -> bool:
        """Load a compiled HEF model onto the Hailo-10H"""
        if not self.available:
            return False
        try:
            from hailo_platform import HEF, ConfigureParams, InputVStreamParams, OutputVStreamParams
            self.hef = HEF(hef_path)
            logger.info(f"✓ Model loaded on Hailo NPU: {hef_path}")
            return True
        except Exception as e:
            logger.error(f"Model load failed: {e}")
            return False

    def infer(self, input_data) -> Optional[dict]:
        """Run inference on the Hailo-10H NPU"""
        if not self.available or not hasattr(self, 'hef'):
            return None
        try:
            # Run inference through HailoRT
            result = self.runner.infer(input_data)
            return result
        except Exception as e:
            logger.error(f"Hailo inference error: {e}")
            return None

    def get_status(self) -> dict:
        return {
            "available": self.available,
            "pi5_mode": PI5_MODE,
            "hailo_enabled": HAILO_ENABLED,
            "device": str(self.device) if self.device else None,
            "tops": 26 if self.available else 0,
        }


class PhoenixAIBridge:
    """
    Routes AI inference between Hailo-10H NPU and Ollama
    Uses NPU for vision/classification tasks, Ollama for LLM tasks
    """

    def __init__(self):
        self.npu = HailoNPU()
        self.ollama_url = os.getenv("OLLAMA_HOST", "http://localhost:11434")
        logger.info(f"PhoenixAIBridge initialized | NPU: {self.npu.is_available()} | Ollama: {self.ollama_url}")

    def route_inference(self, task_type: str, payload: dict) -> dict:
        """
        Route inference to the best available backend:
        - Vision/classification tasks → Hailo-10H NPU (fast, local)
        - LLM/chat tasks → Ollama (flexible, local)
        """
        if task_type in ("vision", "classification", "embedding") and self.npu.is_available():
            result = self.npu.infer(payload.get("data"))
            return {"backend": "hailo_npu", "result": result, "tops": 26}
        else:
            # Fall through to Ollama
            return {"backend": "ollama", "result": None, "message": "Route to Ollama LLM"}

    def status(self) -> dict:
        return {
            "npu": self.npu.get_status(),
            "ollama": self.ollama_url,
            "pi5_mode": PI5_MODE,
        }


# Singleton
_bridge: Optional[PhoenixAIBridge] = None

def get_bridge() -> PhoenixAIBridge:
    global _bridge
    if _bridge is None:
        _bridge = PhoenixAIBridge()
    return _bridge
