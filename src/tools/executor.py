"""
Phoenix OS — Tool Executor
Runs security tools as subprocesses with timeout, output capture,
and AI-friendly result formatting.

Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import shlex
import subprocess
import threading
import logging
from typing import Optional
from datetime import datetime

logger = logging.getLogger(__name__)


class ToolResult:
    """Structured result from a tool execution."""
    def __init__(self, tool: str, command: str, returncode: int,
                 stdout: str, stderr: str, duration: float, success: bool):
        self.tool       = tool
        self.command    = command
        self.returncode = returncode
        self.stdout     = stdout
        self.stderr     = stderr
        self.duration   = duration
        self.success    = success
        self.timestamp  = datetime.now().isoformat()

    def to_dict(self) -> dict:
        return {
            "tool":       self.tool,
            "command":    self.command,
            "returncode": self.returncode,
            "stdout":     self.stdout,
            "stderr":     self.stderr,
            "duration":   round(self.duration, 2),
            "success":    self.success,
            "timestamp":  self.timestamp,
        }

    def summary(self) -> str:
        """Short human-readable summary for AI context."""
        status = "✅ SUCCESS" if self.success else f"❌ FAILED (rc={self.returncode})"
        lines = self.stdout.strip().splitlines()
        preview = "\n".join(lines[:20]) if lines else "(no output)"
        if len(lines) > 20:
            preview += f"\n... [{len(lines)-20} more lines]"
        return (
            f"Tool: {self.tool} | {status} | {self.duration:.1f}s\n"
            f"Command: {self.command}\n"
            f"Output:\n{preview}"
        )


class ToolExecutor:
    """
    Runs Phoenix OS security tools safely.
    - Validates tool exists before running
    - Enforces timeout (default 300s)
    - Captures stdout+stderr separately
    - Streams output via callback for live UI
    - Never runs with shell=True on untrusted input
    """

    def __init__(self, timeout: int = 300, output_dir: str = "/home/kali/phoenix-vault/tool-output"):
        self.timeout    = timeout
        self.output_dir = output_dir
        os.makedirs(output_dir, exist_ok=True)

    def _find_binary(self, name: str) -> Optional[str]:
        """Locate tool binary — checks PATH, /opt/tools/, common paths."""
        import shutil
        found = shutil.which(name)
        if found:
            return found
        opt_path = f"/opt/tools/{name}/{name}"
        if os.path.isfile(opt_path) and os.access(opt_path, os.X_OK):
            return opt_path
        return None

    def run(self, tool_name: str, args: list, timeout: Optional[int] = None,
            stream_callback=None, env_extra: dict = None) -> ToolResult:
        """
        Execute a tool with the given args list.
        
        Args:
            tool_name:       Name of the tool binary
            args:            Argument list (NOT shell string — safe)
            timeout:         Override default timeout in seconds
            stream_callback: callable(line: str) for live output streaming
            env_extra:       Extra env vars to add
        
        Returns:
            ToolResult with all output and metadata
        """
        import time

        binary = self._find_binary(tool_name)
        if not binary:
            logger.error(f"Tool not found: {tool_name}")
            return ToolResult(
                tool=tool_name, command=tool_name,
                returncode=-1, stdout="", stderr=f"Tool not found: {tool_name}",
                duration=0.0, success=False
            )

        cmd = [binary] + [str(a) for a in args]
        cmd_str = " ".join(shlex.quote(c) for c in cmd)
        logger.info(f"Executing: {cmd_str}")

        env = os.environ.copy()
        if env_extra:
            env.update(env_extra)

        t_start = time.time()
        try:
            proc = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                env=env,
            )
        except PermissionError:
            return ToolResult(
                tool=tool_name, command=cmd_str,
                returncode=-1, stdout="",
                stderr="Permission denied — try running Phoenix OS with appropriate privileges.",
                duration=0.0, success=False
            )

        stdout_lines = []
        stderr_lines = []

        def _read_stream(stream, collector, label):
            for line in stream:
                line = line.rstrip()
                collector.append(line)
                if stream_callback:
                    try:
                        stream_callback(f"[{label}] {line}")
                    except Exception:
                        pass

        t_out = threading.Thread(target=_read_stream, args=(proc.stdout, stdout_lines, "OUT"), daemon=True)
        t_err = threading.Thread(target=_read_stream, args=(proc.stderr, stderr_lines, "ERR"), daemon=True)
        t_out.start()
        t_err.start()

        try:
            proc.wait(timeout=timeout or self.timeout)
        except subprocess.TimeoutExpired:
            proc.kill()
            logger.warning(f"Tool timed out after {timeout or self.timeout}s: {tool_name}")
            stderr_lines.append(f"TIMEOUT: Tool killed after {timeout or self.timeout}s")

        t_out.join(timeout=5)
        t_err.join(timeout=5)

        duration  = time.time() - t_start
        stdout    = "\n".join(stdout_lines)
        stderr    = "\n".join(stderr_lines)
        rc        = proc.returncode if proc.returncode is not None else -1
        success   = rc == 0

        result = ToolResult(
            tool=tool_name, command=cmd_str,
            returncode=rc, stdout=stdout, stderr=stderr,
            duration=duration, success=success
        )

        # Auto-save output
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        out_file = os.path.join(self.output_dir, f"{tool_name}_{ts}.txt")
        try:
            with open(out_file, "w") as f:
                f.write(f"Command: {cmd_str}\n")
                f.write(f"Duration: {duration:.2f}s | RC: {rc}\n")
                f.write(f"{'='*60}\n{stdout}\n")
                if stderr:
                    f.write(f"\nSTDERR:\n{stderr}\n")
            logger.info(f"Output saved: {out_file}")
        except Exception as e:
            logger.warning(f"Could not save output: {e}")

        return result

    def check_installed(self, tool_names: list) -> dict:
        """Check which tools are actually installed on the system."""
        results = {}
        for name in tool_names:
            results[name] = self._find_binary(name) is not None
        return results

    def check_all_registry(self) -> dict:
        """Check installation status of every tool in the registry."""
        from .registry import TOOL_REGISTRY
        return self.check_installed([t["name"] for t in TOOL_REGISTRY.values()])
