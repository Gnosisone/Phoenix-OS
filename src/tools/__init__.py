"""
Phoenix OS — Tools Package
Exposes the tool registry, executor, and pre-built attack wrappers.
"""
from .registry import (
    TOOL_REGISTRY,
    get_tools_by_phase,
    get_tool,
    find_tool_by_trigger,
    list_phases,
    list_categories,
    tool_count,
    get_tools_requiring_sudo,
)
from .executor import ToolExecutor
from .wrappers import WRAPPER_MAP

__all__ = [
    "TOOL_REGISTRY",
    "get_tools_by_phase",
    "get_tool",
    "find_tool_by_trigger",
    "list_phases",
    "list_categories",
    "tool_count",
    "get_tools_requiring_sudo",
    "ToolExecutor",
    "WRAPPER_MAP",
]
