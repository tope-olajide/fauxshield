#!/usr/bin/env python3
"""Cross-language checks for the FauxShield developer platform.

Three clients are published against one API: the generated Dart client, the
Node.js SDK, and the Python SDK. The API contract in
``fauxshield_contract/contract/api_contract.json`` is extracted from the Dart
client, so it is the neutral description the other two are generated from —
and this script is what proves they still agree with it.

Run from the repository root::

    python tools/check_parity.py

Exit code 0 means every SDK covers the API, nothing extra was invented, and
every SDK still defaults to the hosted API rather than to localhost. Anything
else prints the drift and exits 1, so CI fails before a release does.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTRACT = ROOT / "fauxshield_contract" / "contract" / "api_contract.json"

DART_CLIENT = ROOT / "fauxshield_client" / "lib" / "src" / "protocol"
NODE_GENERATED = ROOT / "fauxshield_node" / "src" / "generated"
PYTHON_GENERATED = ROOT / "fauxshield_python" / "src" / "fauxshield" / "generated"

#: The hosted deployment, established in docs/DEPLOYMENT.md and baked into
#: every published SDK. Localhost must never take its place.
HOSTED_API = "https://fauxshield.api.serverpod.space"

DOCS_CONTENT = ROOT / "fauxshield_server" / "lib" / "src" / "web" / "docs"
DOCS_CLI_PAGE = DOCS_CONTENT / "docs_ops.dart"
DOCS_REFERENCE = DOCS_CONTENT / "docs_reference.dart"
CLI_COMMANDS = ROOT / "fauxshield_cli" / "lib" / "src" / "commands"
MCP_TOOLS = ROOT / "fauxshield_mcp" / "lib" / "src" / "tools"

DEFAULT_URL_SOURCES = {
    "Node.js SDK": (ROOT / "fauxshield_node" / "src" / "config.ts", r"DEFAULT_BASE_URL\s*=\s*['\"]([^'\"]+)['\"]"),
    "Python SDK": (ROOT / "fauxshield_python" / "src" / "fauxshield" / "config.py", r'DEFAULT_BASE_URL\s*=\s*"([^"]+)"'),
    "CLI": (ROOT / "fauxshield_cli" / "lib" / "src" / "config.dart", r"defaultServerUrl\s*=\s*'([^']+)'"),
    "MCP server": (ROOT / "fauxshield_mcp" / "lib" / "src" / "config.dart", r"'(https://[^']+)'"),
}

failures: list[str] = []


def fail(message: str) -> None:
    failures.append(message)


def contract() -> dict:
    return json.loads(CONTRACT.read_text(encoding="utf-8"))


def contract_pairs(data: dict) -> set[tuple[str, str]]:
    return {
        (endpoint["name"], method["name"])
        for endpoint in data["endpoints"]
        for method in endpoint["methods"]
    }


def pairs_from(pattern: str, paths: list[Path]) -> set[tuple[str, str]]:
    found: set[tuple[str, str]] = set()
    for path in paths:
        text = path.read_text(encoding="utf-8")
        found.update(re.findall(pattern, text))
    return found


def compare(
    owner: str,
    expected: set[tuple[str, str]],
    found: set[tuple[str, str]],
    endpoints: set[str] | None = None,
) -> None:
    if endpoints is not None:
        found = {(endpoint, method) for endpoint, method in found if endpoint in endpoints}
    missing = sorted("{} {}".format(endpoint, method) for endpoint, method in expected - found)
    extra = sorted("{} {}".format(endpoint, method) for endpoint, method in found - expected)
    print("  {}: {} of {} methods".format(owner, len(found & expected), len(expected)))
    if missing:
        fail("{} is missing {} method(s): {}".format(owner, len(missing), ", ".join(missing[:12])))
    if extra:
        fail(
            "{} has {} method(s) the API does not: {}".format(
                owner, len(extra), ", ".join(extra[:12])
            )
        )


def check_sdk_parity(data: dict) -> None:
    print("SDK coverage against the API contract")
    expected = contract_pairs(data)
    names = {endpoint["name"] for endpoint in data["endpoints"]}

    # The generated client also carries the auth module's own endpoints
    # (emailIdp, jwtRefresh), which are not part of this API's surface, so the
    # comparison is scoped to the endpoints the contract describes.
    dart = pairs_from(
        r"\.callServerEndpoint<[^(]*?>\(\s*'([\w]+)',\s*'([\w]+)'",
        sorted(DART_CLIENT.rglob("*.dart")),
    )
    compare("Dart client", expected, dart, endpoints=names)

    node = pairs_from(
        r"\.call\(\s*'([\w]+)',\s*'([\w]+)'",
        [NODE_GENERATED / "resources.ts"],
    )
    compare("Node.js SDK", expected, node)

    python = pairs_from(
        r'\.call\(\s*"([\w]+)",\s*"([\w]+)"',
        [PYTHON_GENERATED / "resources.py"],
    )
    compare("Python SDK", expected, python)

    # The same fifteen endpoints, by name, so a renamed resource is caught even
    # if its methods happen to line up.
    for owner, path, pattern in (
        ("Node.js SDK", NODE_GENERATED / "resources.ts", r"export class (\w+)Resource"),
        ("Python SDK", PYTHON_GENERATED / "resources.py", r"class (\w+)Resource"),
    ):
        declared = {name.lower() for name in re.findall(pattern, path.read_text(encoding="utf-8"))}
        wanted = {name.lower() for name in names}
        if declared != wanted:
            fail(
                "{} resource classes differ from the API: missing {}, extra {}".format(
                    owner,
                    ", ".join(sorted(wanted - declared)) or "nothing",
                    ", ".join(sorted(declared - wanted)) or "nothing",
                )
            )


def check_models(data: dict) -> None:
    print("Models and enums")
    wanted = {model["name"] for model in data["models"]} | {
        value["name"] for value in data["enums"]
    }

    # Presence is the Dart-side check: the generated tree also holds the auth
    # module's models, which this API does not describe.
    dart_text = "\n".join(
        path.read_text(encoding="utf-8") for path in sorted(DART_CLIENT.rglob("*.dart"))
    )
    dart = set(
        re.findall(
            r"^(?:abstract |final |sealed )?(?:class|enum) (\w+)",
            dart_text,
            re.MULTILINE,
        )
    )

    node = set(
        re.findall(
            r"^export (?:interface|type|const enum|enum) (\w+)",
            (NODE_GENERATED / "models.ts").read_text(encoding="utf-8"),
            re.MULTILINE,
        )
    )
    python = set(
        re.findall(
            r"^class (\w+)",
            (PYTHON_GENERATED / "models.py").read_text(encoding="utf-8"),
            re.MULTILINE,
        )
    )

    for owner, found in (("Dart client", dart), ("Node.js SDK", node), ("Python SDK", python)):
        missing = sorted(wanted - found)
        print("  {}: {} of {} models and enums".format(owner, len(wanted & found), len(wanted)))
        if missing:
            fail("{} is missing {} model(s): {}".format(owner, len(missing), ", ".join(missing[:12])))


def check_default_urls() -> None:
    print("Default API URL in every published client")
    for owner, (path, pattern) in DEFAULT_URL_SOURCES.items():
        text = path.read_text(encoding="utf-8")
        matches = re.findall(pattern, text)
        if not matches:
            fail("{}: no default API URL found in {}".format(owner, path.relative_to(ROOT)))
            continue
        default = matches[-1]
        print("  {}: {}".format(owner, default))
        if default != HOSTED_API:
            fail(
                "{} defaults to {} instead of {}".format(
                    owner, default, HOSTED_API
                )
            )
        if "localhost" in " ".join(matches):
            fail("{} names localhost among its defaults".format(owner))


def check_cli_coverage() -> None:
    """Every command the CLI registers is named in the CLI documentation page.

    The page is written by hand because a command needs a sentence, not a
    signature; this is the check that keeps it honest.
    """
    print("CLI documentation coverage")
    names: set[str] = set()
    for path in sorted(CLI_COMMANDS.glob("*.dart")):
        names.update(re.findall(r"String get name => '([\w-]+)'", path.read_text(encoding="utf-8")))
    text = DOCS_CLI_PAGE.read_text(encoding="utf-8")
    missing = sorted(name for name in names if "'{}'".format(name) not in text)
    print("  {} command names in the CLI, {} documented".format(len(names), len(names) - len(missing)))
    if missing:
        fail("the CLI page does not document: {}".format(", ".join(missing)))


def check_mcp_coverage() -> None:
    """Every tool the MCP server registers is named in the MCP documentation."""
    print("MCP documentation coverage")
    names: set[str] = set()
    for path in sorted(MCP_TOOLS.glob("*.dart")):
        names.update(
            re.findall(r"registry\.(?:read|write)\(\s*'([a-z0-9_]+)'", path.read_text(encoding="utf-8"))
        )
    text = DOCS_CLI_PAGE.read_text(encoding="utf-8")
    missing = sorted(name for name in names if "'{}'".format(name) not in text)
    print("  {} tools in the MCP server, {} documented".format(len(names), len(names) - len(missing)))
    if missing:
        fail("the MCP page does not document: {}".format(", ".join(missing)))


def check_docs_route_coverage(data: dict) -> None:
    """The portal documents every endpoint, and the search index every page.

    The structural checks — unique slugs, anchors, links — run in the server's
    own suite (`dart test` in fauxshield_server). What is asserted here is the
    link between the contract and the reference: an endpoint the API gained
    cannot be missing from the documentation site.
    """
    print("Documentation coverage")
    generated = DOCS_CONTENT / "api_reference.g.dart"
    if not generated.exists():
        fail("api_reference.g.dart is missing; run `dart run tool/generate_docs.dart`")
        return
    text = generated.read_text(encoding="utf-8")
    missing = [
        endpoint["name"] for endpoint in data["endpoints"] if "name: '{}'".format(endpoint["name"]) not in text
    ]
    print(
        "  {} of {} endpoints have a generated reference page".format(
            len(data["endpoints"]) - len(missing), len(data["endpoints"])
        )
    )
    if missing:
        fail("the docs reference does not cover: {}".format(", ".join(missing)))

    render_source = (DOCS_CONTENT / "docs_render.dart").read_text(encoding="utf-8")
    if "searchIndexJson" not in render_source:
        fail("the docs site does not build a search index")

    routes = (ROOT / "fauxshield_server" / "lib" / "src" / "web" / "routes" / "docs_routes.dart")
    server = (ROOT / "fauxshield_server" / "lib" / "server.dart").read_text(encoding="utf-8")
    if "search.json" not in routes.read_text(encoding="utf-8"):
        fail("the docs route does not serve the search index")
    for path in ("'/docs'", "'/docs/**'"):
        if "DocsRoute(), {}".format(path) not in server and "DocsRoute(), {}".format(
            path.replace("'", '"')
        ) not in server:
            fail("server.dart does not register the docs route at {}".format(path))
    print("  search index and route registration present")


def check_documented_url() -> None:
    """The Dart client takes its host from the caller, so the README is where
    the Dart story lives: it has to name the hosted API, not a local address."""
    print("Dart client documentation")
    readme = (ROOT / "fauxshield_client" / "README.md").read_text(encoding="utf-8")
    if HOSTED_API not in readme:
        fail("fauxshield_client/README.md does not show the hosted API URL")
    else:
        print("  fauxshield_client/README.md: shows {}".format(HOSTED_API))
    if re.search(r"Client\('http://localhost", readme):
        fail("fauxshield_client/README.md documents a localhost client as the normal case")


def main() -> int:
    data = contract()
    print(
        "Contract: {} endpoints, {} methods, {} models, {} enums".format(
            len(data["endpoints"]),
            len(contract_pairs(data)),
            len(data["models"]),
            len(data["enums"]),
        )
    )
    check_sdk_parity(data)
    check_models(data)
    check_default_urls()
    check_documented_url()
    check_cli_coverage()
    check_mcp_coverage()
    check_docs_route_coverage(data)

    print()
    if failures:
        print("Drift found:")
        for failure in failures:
            print("  - {}".format(failure))
        return 1
    print("No drift: every SDK matches the API contract and defaults to the hosted API.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
