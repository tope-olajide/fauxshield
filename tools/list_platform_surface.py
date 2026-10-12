"""Extract the CLI command tree and the MCP tool list, for the docs pages.

Prints a Dart map literal per command file, so the documentation page can state
the commands that exist. Run from the repository root:

    python tools/list_platform_surface.py
"""

import re
import sys
from pathlib import Path

CLI = Path("fauxshield_cli/lib/src/commands")
MCP = Path("fauxshield_mcp/lib/src/tools")

NAME = re.compile(r"String get name => '([\w-]+)'")
DESC = re.compile(r"String get description =>\s*\n?\s*'([^']*)'")


def cli_commands() -> list[tuple[str, str, list[str]]]:
    """Top-level commands, their description, and their subcommands, in source order."""
    rows: list[tuple[str, str, list[str]]] = []
    for path in sorted(CLI.glob("*.dart")):
        text = path.read_text(encoding="utf-8")
        names = NAME.findall(text)
        if not names:
            continue
        top = names[0]
        top_desc = ""
        match = re.search(
            r"String get name => '" + re.escape(top) + r"';\s*(?:@override\s*)?String get description =>\s*\n?\s*'([^']*)'",
            text,
        )
        if match:
            top_desc = match.group(1)
        # Subcommands live in the same file, declared in the order they are
        # registered: the first name is the command itself, the rest are its
        # subcommands.
        declared = NAME.findall(text)
        subcommands = declared[1:] if len(declared) > 1 else []
        rows.append((top, top_desc.strip(), subcommands))
    return rows


def mcp_tools() -> dict[str, list[str]]:
    """Tool names per tool file, read from the registry calls."""
    tools: dict[str, list[str]] = {}
    for path in sorted(MCP.glob("*.dart")):
        text = path.read_text(encoding="utf-8")
        names = re.findall(r"registry\.(?:read|write)\(\s*\n?\s*'([a-z0-9_]+)'", text)
        if names:
            tools[path.stem.replace("_tools", "")] = names
    return tools


def main() -> int:
    print("CLI commands (name, description, subcommands)")
    for name, description, subcommands in cli_commands():
        print(f"  {name}: {description}")
        if subcommands:
            print(f"      -> {', '.join(subcommands)}")
    print()
    print("MCP tools")
    total = 0
    for group, names in mcp_tools().items():
        total += len(names)
        print(f"  {group} ({len(names)}): {', '.join(names)}")
    print(f"  total: {total} tools")
    return 0


if __name__ == "__main__":
    sys.exit(main())
