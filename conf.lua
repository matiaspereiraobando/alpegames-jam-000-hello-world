function love.conf(t)
    t.identity = "alpegames-jam-000-hello-world"
    t.version = "11.4" -- Pinned for love.js web runtime compatibility (jam best practice)
    t.console = false

    t.window.title = "Alpe Games - Jam #0"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.vsync = 1
    t.window.msaa = 0
    t.window.highdpi = false
end
