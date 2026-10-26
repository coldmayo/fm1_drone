
#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Point to the existing Linux WASI SDK
export FM1_WASI_SDK="$HOME/opt/wasi-sdk-27.0-x86_64-linux"

BUILD_SCRIPT="tools/Build-Web-Linux.ps1"
PREVIEW="build/preview/index.html"

# Validate dependencies
for cmd in pwsh xdg-open; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

if [[ ! -x "$FM1_WASI_SDK/bin/clang" ]]; then
    echo "Error: WASI SDK clang not found:"
    echo "  $FM1_WASI_SDK/bin/clang"
    exit 1
fi

if [[ ! -f "$BUILD_SCRIPT" ]]; then
    echo "Error: $BUILD_SCRIPT not found."
    exit 1
fi

echo "==> Using WASI SDK: $FM1_WASI_SDK"
echo "==> Building FM-1 WebAssembly preview..."

pwsh -NoProfile -File "./$BUILD_SCRIPT" -LocalPreview

if [[ ! -s "$PREVIEW" ]]; then
    echo "Error: Preview missing or empty: $PREVIEW" >&2
    exit 1
fi

echo "==> Build successful: $PREVIEW"
xdg-open "$PREVIEW"
