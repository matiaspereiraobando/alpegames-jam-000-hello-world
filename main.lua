local VIRTUAL_WIDTH = 400
local VIRTUAL_HEIGHT = 300

local windowWidth = 800
local windowHeight = 600
local renderScale = 2
local offsetX = 0
local offsetY = 0

local clickCount = 0
local button = {
    x = 0,
    y = 0,
    w = 120,
    h = 40,
    baseColor = {0.18, 0.42, 0.96},
    activeColor = {1.00, 0.40, 0.20},
    flash = 0,
    punch = 0
}

local canvas
local fontSmall
local fontBig

local function updateViewport(w, h)
    windowWidth = w
    windowHeight = h
    renderScale = math.floor(math.min(windowWidth / VIRTUAL_WIDTH, windowHeight / VIRTUAL_HEIGHT))
    renderScale = math.max(1, renderScale)

    local drawWidth = VIRTUAL_WIDTH * renderScale
    local drawHeight = VIRTUAL_HEIGHT * renderScale

    offsetX = math.floor((windowWidth - drawWidth) / 2)
    offsetY = math.floor((windowHeight - drawHeight) / 2)
end

local function screenToVirtual(x, y)
    local vx = (x - offsetX) / renderScale
    local vy = (y - offsetY) / renderScale
    return vx, vy
end

local function insideButton(vx, vy)
    return vx >= button.x and vx <= button.x + button.w and vy >= button.y and vy <= button.y + button.h
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    local w, h = love.graphics.getDimensions()
    updateViewport(w, h)

    canvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    canvas:setFilter("nearest", "nearest")

    fontSmall = love.graphics.newFont(8)
    fontBig = love.graphics.newFont(16)

    button.x = math.floor((VIRTUAL_WIDTH - button.w) / 2)
    button.y = math.floor((VIRTUAL_HEIGHT - button.h) / 2)
end

function love.resize(w, h)
    updateViewport(w, h)
end

function love.update(dt)
    button.flash = math.max(0, button.flash - dt * 3.8)
    button.punch = math.max(0, button.punch - dt * 6.0)
end

function love.mousepressed(x, y, mouseButton)
    if mouseButton ~= 1 then
        return
    end

    local vx, vy = screenToVirtual(x, y)
    if insideButton(vx, vy) then
        clickCount = clickCount + 1
        button.flash = 1
        button.punch = 1
    end
end

local function drawRetroBackground()
    love.graphics.clear(0.06, 0.05, 0.09)

    -- Pixel grid backdrop
    love.graphics.setColor(0.10, 0.09, 0.16)
    for y = 0, VIRTUAL_HEIGHT, 8 do
        love.graphics.rectangle("fill", 0, y, VIRTUAL_WIDTH, 1)
    end
    for x = 0, VIRTUAL_WIDTH, 8 do
        love.graphics.rectangle("fill", x, 0, 1, VIRTUAL_HEIGHT)
    end

    -- Center panel
    love.graphics.setColor(0.12, 0.12, 0.2)
    love.graphics.rectangle("fill", 64, 56, 272, 188)
    love.graphics.setColor(0.30, 0.26, 0.46)
    love.graphics.rectangle("line", 64, 56, 272, 188)
end

local function drawButton()
    local flashMix = button.flash
    local c = {
        button.baseColor[1] * (1 - flashMix) + button.activeColor[1] * flashMix,
        button.baseColor[2] * (1 - flashMix) + button.activeColor[2] * flashMix,
        button.baseColor[3] * (1 - flashMix) + button.activeColor[3] * flashMix,
    }

    local punchScale = 1 + 0.12 * button.punch
    local cx = button.x + button.w / 2
    local cy = button.y + button.h / 2

    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.scale(punchScale, punchScale)
    love.graphics.translate(-cx, -cy)

    -- Shadow
    love.graphics.setColor(0, 0, 0, 0.45)
    love.graphics.rectangle("fill", button.x + 2, button.y + 2, button.w, button.h)

    -- Button body
    love.graphics.setColor(c)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)

    -- Border + highlight
    love.graphics.setColor(0.05, 0.05, 0.12)
    love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
    love.graphics.setColor(1, 1, 1, 0.20)
    love.graphics.rectangle("fill", button.x + 1, button.y + 1, button.w - 2, 6)

    love.graphics.setFont(fontSmall)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("CLICK ME", button.x, button.y + 15, button.w, "center")

    love.graphics.pop()
end

function love.draw()
    love.graphics.setCanvas(canvas)
    drawRetroBackground()

    love.graphics.setFont(fontBig)
    love.graphics.setColor(1, 0.96, 0.72)
    love.graphics.printf("ALPE GAMES JAM #0", 0, 76, VIRTUAL_WIDTH, "center")

    love.graphics.setColor(0.72, 1, 0.78)
    love.graphics.printf("HELLO, WORLD!", 0, 98, VIRTUAL_WIDTH, "center")

    drawButton()

    love.graphics.setFont(fontBig)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("CLICKS: " .. tostring(clickCount), 0, 186, VIRTUAL_WIDTH, "center")

    love.graphics.setColor(0.78, 0.78, 0.88)
    love.graphics.setFont(fontSmall)
    love.graphics.printf("Love2D -> WASM -> Browser", 0, 210, VIRTUAL_WIDTH, "center")

    love.graphics.setCanvas()

    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canvas, offsetX, offsetY, 0, renderScale, renderScale)
end
