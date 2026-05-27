# Alpe Games Jam #0 — Love2D Hello World

A tiny retro-styled Love2D test game for the Alpe Games jam pipeline:

**Love2D → WASM (love.js) → Browser**

## What this includes

- `main.lua`: Retro pixel-art style scene with a center button.
  - Clicking the button flashes its color
  - Brief "punch" scale animation
  - Click counter updates on each click
- `conf.lua`: Window configuration (`800x600`, title `Alpe Games - Jam #0`)
- `build.sh`: Build script to package and compile with `love.js`
- `index.html`: Browser wrapper page (pixelated canvas styling)

## Run locally with Love2D (desktop)

From this folder:

```bash
love .
```

## Build for WebAssembly with love.js

### 1) Install love.js

```bash
git clone https://github.com/Davidobot/love.js.git ~/love.js
cd ~/love.js
git submodule update --init --recursive
python3 -m pip install --user -r requirements.txt
```

> Depending on your system, you may also need to install and activate Emscripten (`emsdk`).

### 2) Build this project

From the game project folder:

```bash
chmod +x build.sh
./build.sh
```

If `love.js` is in a custom location:

```bash
LOVEJS_DIR=/path/to/love.js ./build.sh
```

### 3) Serve the built files

The build output goes to:

- `dist/alpegames-jam-000-hello-world.love`
- `dist/web/` (browser build)

Run a local web server in `dist/web`:

```bash
cd dist/web
python3 -m http.server 8080
```

Then open:

- http://localhost:8080

## Notes

- The game renders to a low-resolution virtual canvas (`400x300`) scaled up with nearest-neighbor filtering for a retro pixel look.
- `index.html` expects the love.js output files (`game.js`, `game.wasm`, `game.data`) to be present in the same directory.
