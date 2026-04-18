"""
Phoenix OS — FastAPI Server
REST API exposing tool registry, executor, vault, and system status
to the ERR0RS web UI and any external clients on the local network.

Endpoints:
  GET  /api/status              — full system status JSON
  GET  /api/tools               — list all registered tools
  GET  /api/tools/{name}        — single tool detail
  POST /api/tools/search        — NLP search for matching tools
  POST /api/tools/run           — execute a tool (async, streams output)
  GET  /api/tools/installed     — check which tools are actually on disk
  GET  /api/phases              — list kill chain phases
  GET  /api/vault/engagements   — list engagements
  POST /api/vault/new           — create new engagement
  GET  /api/vault/{id}          — get engagement detail
  WS   /ws/tool-stream          — WebSocket for live tool output

Author: Gary Holden Schneider (Eros) | GitHub: Gnosisone
"""

import os
import sys
import asyncio
import logging
from typing import Optional
from datetime import datetime

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel

logger = logging.getLogger(__name__)

# ── App Init ───────────────────────────────────────────────────────────────────
app = FastAPI(
    title="Phoenix OS API",
    description="AI-powered pentest platform API — Phoenix OS by Gnosisone",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Active WebSocket connections for streaming tool output
_ws_clients: list[WebSocket] = []

# ── Request/Response Models ────────────────────────────────────────────────────

class ToolSearchRequest(BaseModel):
    query: str
    limit: int = 5

class ToolRunRequest(BaseModel):
    tool:    str
    args:    list = []
    timeout: Optional[int] = 300

class NewEngagementRequest(BaseModel):
    client: str
    scope:  list = []
    notes:  str = ""

# ── Helpers ───────────────────────────────────────────────────────────────────

def _get_system():
    """Lazy-load PhoenixSystem (avoids re-init on import)."""
    from src.core.system import PhoenixSystem
    return PhoenixSystem()

_system_cache = None

def get_system():
    global _system_cache
    if _system_cache is None:
        _system_cache = _get_system()
    return _system_cache

# ── Status ─────────────────────────────────────────────────────────────────────

@app.get("/api/status")
async def get_status():
    """Full system status — hardware, AI, wireless, vault, tools."""
    try:
        sys_mgr = get_system()
        return sys_mgr.get_status()
    except Exception as e:
        return {"error": str(e), "timestamp": datetime.now().isoformat()}

@app.get("/api/health")
async def health():
    return {"status": "ok", "service": "Phoenix OS API", "timestamp": datetime.now().isoformat()}

# ── Tool Registry ──────────────────────────────────────────────────────────────

@app.get("/api/tools")
async def list_tools(phase: Optional[str] = None, category: Optional[str] = None):
    """List all registered tools, optionally filtered by phase or category."""
    from src.tools import TOOL_REGISTRY, get_tools_by_phase
    tools = TOOL_REGISTRY
    if phase:
        tools = get_tools_by_phase(phase)
    if category:
        tools = {k: v for k, v in tools.items() if v.get("category") == category}
    return {
        "count": len(tools),
        "tools": [{"key": k, **v} for k, v in tools.items()],
    }

@app.get("/api/tools/installed")
async def check_installed():
    """Check which registered tools are actually installed on this system."""
    from src.tools import TOOL_REGISTRY, ToolExecutor
    executor = ToolExecutor()
    names = [t["name"] for t in TOOL_REGISTRY.values()]
    status = executor.check_installed(names)
    installed = sum(1 for v in status.values() if v)
    return {
        "total_registered": len(status),
        "installed": installed,
        "missing": len(status) - installed,
        "tools": status,
    }

@app.get("/api/tools/{tool_key}")
async def get_tool(tool_key: str):
    """Get full detail for a single tool by its registry key."""
    from src.tools import TOOL_REGISTRY
    tool = TOOL_REGISTRY.get(tool_key)
    if not tool:
        raise HTTPException(status_code=404, detail=f"Tool '{tool_key}' not in registry")
    return {"key": tool_key, **tool}

@app.post("/api/tools/search")
async def search_tools(req: ToolSearchRequest):
    """NLP search — find tools matching a natural language query."""
    from src.tools import find_tool_by_trigger
    matches = find_tool_by_trigger(req.query)[:req.limit]
    return {
        "query": req.query,
        "count": len(matches),
        "results": [{"key": k, **t} for k, t in matches],
    }

@app.get("/api/phases")
async def list_phases():
    """List all kill chain phases in the registry."""
    from src.tools import list_phases as _lp, get_tools_by_phase
    phases = _lp()
    return {
        "phases": [
            {"name": p, "tool_count": len(get_tools_by_phase(p))}
            for p in phases
        ]
    }

# ── Tool Execution ─────────────────────────────────────────────────────────────

@app.post("/api/tools/run")
async def run_tool(req: ToolRunRequest, background_tasks: BackgroundTasks):
    """
    Run a tool. Output is streamed to connected WebSocket clients.
    Returns immediately with a job_id — poll /api/jobs/{id} for results
    or subscribe to WebSocket /ws/tool-stream for live output.
    """
    from src.tools import ToolExecutor, TOOL_REGISTRY
    import uuid

    # Validate tool exists in registry
    if req.tool not in TOOL_REGISTRY:
        raise HTTPException(status_code=404, detail=f"Tool '{req.tool}' not registered. Use /api/tools to list available tools.")

    tool_entry = TOOL_REGISTRY[req.tool]
    job_id = str(uuid.uuid4())[:8]

    async def _broadcast(line: str):
        """Send live output to all connected WebSocket clients."""
        dead = []
        for ws in _ws_clients:
            try:
                await ws.send_json({"job_id": job_id, "tool": req.tool, "line": line})
            except Exception:
                dead.append(ws)
        for ws in dead:
            _ws_clients.remove(ws)

    def _run():
        executor = ToolExecutor(timeout=req.timeout)

        def _cb(line):
            asyncio.run(_broadcast(line))

        result = executor.run(
            tool_name=tool_entry["name"],
            args=req.args,
            timeout=req.timeout,
            stream_callback=_cb,
        )
        return result

    background_tasks.add_task(_run)

    return {
        "job_id": job_id,
        "tool": req.tool,
        "binary": tool_entry["name"],
        "args": req.args,
        "timeout": req.timeout,
        "status": "running",
        "stream": "ws://localhost:8767/ws/tool-stream",
        "message": f"Tool '{req.tool}' launched. Connect to WebSocket for live output.",
    }

# ── WebSocket Stream ────────────────────────────────────────────────────────────

@app.websocket("/ws/tool-stream")
async def tool_stream(websocket: WebSocket):
    """WebSocket endpoint — receives live tool output lines as JSON."""
    await websocket.accept()
    _ws_clients.append(websocket)
    try:
        while True:
            # Keep connection alive; tool output is pushed from run_tool background task
            await asyncio.sleep(30)
            await websocket.send_json({"type": "ping", "timestamp": datetime.now().isoformat()})
    except WebSocketDisconnect:
        _ws_clients.remove(websocket)

# ── Vault ───────────────────────────────────────────────────────────────────────

@app.get("/api/vault/engagements")
async def list_engagements():
    """List all engagements in the vault."""
    try:
        from src.security.vault import PhoenixVault
        vault = PhoenixVault()
        return {"engagements": vault.list_engagements(), "stats": vault.get_vault_stats()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/vault/new")
async def new_engagement(req: NewEngagementRequest):
    """Create a new encrypted engagement in the vault."""
    try:
        from src.security.vault import PhoenixVault
        vault = PhoenixVault()
        eng_id = vault.new_engagement(req.client, req.scope)
        return {"engagement_id": eng_id, "client": req.client, "status": "created"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/vault/{engagement_id}")
async def get_engagement(engagement_id: str):
    """Get detail on a specific engagement."""
    try:
        from src.security.vault import PhoenixVault
        vault = PhoenixVault()
        eng = vault.get_engagement(engagement_id)
        if not eng:
            raise HTTPException(status_code=404, detail=f"Engagement '{engagement_id}' not found")
        return eng
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ── Server entry point ─────────────────────────────────────────────────────────

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PHOENIX_API_PORT", "8767"))
    logger.info(f"Starting Phoenix OS API on :{port}")
    uvicorn.run(app, host="0.0.0.0", port=port, log_level="info")
