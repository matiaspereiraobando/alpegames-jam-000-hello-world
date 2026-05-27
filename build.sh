#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="alpegames-jam-000-hello-world"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST_DIR="$ROOT_DIR/dist"
LOVE_FILE="$DIST_DIR/$PROJECT_NAME.love"
WEB_DIR="$DIST_DIR/web"

mkdir -p "$DIST_DIR"

if ! command -v zip >/dev/null 2>&1; then
  echo "ERROR: zip is required. Install with: sudo apt-get install -y zip"
  exit 1
fi

echo "[1/4] Packaging .love archive..."
cd "$ROOT_DIR"
zip -9 -r "$LOVE_FILE" . \
  -x "./.git/*" \
  -x "./dist/*" \
  -x "./node_modules/*" \
  -x "./*.love" \
  -x "./build.sh"

echo "[2/4] Building web target with love.js (compat mode)..."
# -c: compatibility mode for broader browser support
# -m: raise initial memory to avoid FS preload errors on some environments
npx --yes love.js -c -m 67108864 -t "Alpe Games Jam 000" "$LOVE_FILE" "$WEB_DIR"

echo "[3/4] Build output files:"
ls -lh "$WEB_DIR" | sed -n '1,120p'

echo "[4/4] Done"
echo
echo "Play locally by serving:"
echo "  cd $WEB_DIR && python3 -m http.server 8080"
echo "Then open: http://localhost:8080"
echo

echo "Deploy target on VPS:"
echo "  /opt/alpegames/games/jam-000/"
echo "Public URL: https://jam.alpegames.cl/games/jam-000/"
echo

echo "Note: conf.lua pins Love version to 11.4 for love.js compatibility."
echo "Desktop builds can still use newer Love2D by adjusting conf.lua as needed."

exit 0
