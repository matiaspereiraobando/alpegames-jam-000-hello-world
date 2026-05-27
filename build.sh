#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="alpegames-jam-000-hello-world"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST_DIR="$ROOT_DIR/dist"
LOVE_FILE="$DIST_DIR/$PROJECT_NAME.love"

LOVEJS_DIR="${LOVEJS_DIR:-$HOME/love.js}"
EMSDK_ENV_DEFAULT="$LOVEJS_DIR/emsdk/emsdk_env.sh"

mkdir -p "$DIST_DIR"

echo "[1/4] Packaging .love archive..."
cd "$ROOT_DIR"
zip -9 -r "$LOVE_FILE" . \
  -x "./.git/*" \
  -x "./dist/*" \
  -x "./love.js/*" \
  -x "./*.love" \
  -x "./build.sh"

echo "[2/4] Checking love.js..."
if [[ ! -d "$LOVEJS_DIR" ]]; then
  cat <<EOF
ERROR: love.js not found at: $LOVEJS_DIR

Install instructions:
  git clone https://github.com/Davidobot/love.js.git "$LOVEJS_DIR"
  cd "$LOVEJS_DIR"
  git submodule update --init --recursive
  python3 -m pip install --user -r requirements.txt
  python3 platform/love.js --help

Then rerun this script, optionally with:
  LOVEJS_DIR=/path/to/love.js ./build.sh
EOF
  exit 1
fi

if [[ -f "$EMSDK_ENV_DEFAULT" ]]; then
  # shellcheck disable=SC1090
  source "$EMSDK_ENV_DEFAULT"
fi

echo "[3/4] Building web target with love.js..."
python3 "$LOVEJS_DIR/platform/love.js" "$LOVE_FILE" "$DIST_DIR/web"

echo "[4/4] Applying custom HTML wrapper..."
cp "$ROOT_DIR/index.html" "$DIST_DIR/web/index.html"

echo
echo "Build complete. Open:"
echo "  $DIST_DIR/web/index.html"
