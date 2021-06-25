------------
-- Uncomplicated Desktop for OpenComputers.
-- - [Homepage](https://github.com/quentinrossetti/undesk)
-- - [API documentation](https://quentinrossetti.github.io/undesk)
-- @module undesk.Init
-- @license ICS 
-- @copyright 2020 Quentin Rossetti <code@bleu.gdn>

package.loaded["themes"] = nil
package.loaded["init"] = nil
pretty=require("libun").pretty
local event = require("event")

local undesk = {}
undesk.WindowManager = loadfile('wm.lua')(nil)
-- undesk.Workspace = loadfile("workspace.lua")(nil)
-- undesk.Window = loadfile("window.lua")(nil)
-- undesk.Bar = loadfile("bar.lua")(nil)

local wm = undesk.WindowManager:new()

wm:addDisplay("center", 8, "4d14b7c9-6ae5-4fcf-8c0f-979d99a8b615")
wm:addDisplay("right", 0, "dee8d427-0181-495f-8cf0-62627025d543")
wm:addDisplay("left", 1, "23f882ae-578a-4b2d-b141-9f21660ca44e")


-- function login()
--   -- workspaces
--   workspace1 = Workspace:new("center"):active():draw()

--   -- normal
--   win1 = Window:new(1)
--     :setLayout("x1 y3 w6 h4")
--     :setTitle("Big graph with lots of things")
--     :draw()
--   win2 = Window:new(1)
--     :setLayout("x1 y1 w2 h2")
--     :setTitle("Small monitor")
--     :draw()
--   win3 = Window:new(1)
--     :setLayout("x3 y1 w2 h2")
--     :setTitle("Keep in check")
--     :draw()
--   win4 = Window:new(1)
--     :setLayout("x5 y1 w2 h4")
--     :setTitle("Some controls")
--     :draw()
-- end

-- -- login()

-- -- loop
-- local running = false

-- local handlers = setmetatable({}, { __index = function () return function () end end })

-- function handlers.interrupted()
--   running = false
-- end

-- function handlers.drag(address, char_x, char_y)
--   local x, y = tonumber(char_x), tonumber(char_y)
--   local ws = wm.workspaces[wm.screen_to_active_workspace[address]]
--   local interact = wm.screen_to_interact[address]
--   if not interact.window then return end
--   local w = interact.window
--   w.pos_x = x - interact.drag_offset_x
--   w.pos_y = y
--   ws:draw()
--   for _, win in pairs(ws.windows) do
--     if win ~= w then
--         win:draw()
--     end
--   end
--   w:draw()
-- end

-- function handlers.touch(address, char_x, char_y)
--   local x, y = tonumber(char_x), tonumber(char_y)
--   local ws = wm.workspaces[wm.screen_to_active_workspace[address]]
--   local interact = wm.screen_to_interact[address]
--   interact.window, interact.drag_offset_x = ws:touchTitlebar(x, y)
--   if interact.window then -- title bar is being touched
--     interact.window:draw()
--   end
--   -- @TODO when OC has vram this code may work :)
--   -- local vram = wm.screen_to_vram[address]
--   -- if interact.window then
--   --   for k,v in pairs(ws.gpu) do print(k,v) end
--   --   vram.interact_windows = ws.gpu.allocateBuffer(w.pos_x, w.pos_y)
--   --   ws.gpu.bitblt(vram.interact_windows, 1, 1, 0, w.pos_x, w.pos_y)
--   -- end
-- end

-- function handlers.drop(address, char_x, char_y)
--   local x, y = tonumber(char_x), tonumber(char_y)
--   local ws = wm.workspaces[wm.screen_to_active_workspace[address]]
--   local interact = wm.screen_to_interact[address]
--   interact.window, interact.drag_offset_x = ws:touchTitlebar(x, y)
--   if interact.drag_offset_x then -- 
--     interact.window:draw()
--   end
--   interact = {} -- reset interaction state @TODO reset initial table like in wm.lua
-- end

-- function handle_events(event_id, ...)
--   if event_id then
--     handlers[event_id](...)
--   end
-- end

-- while running do
--   handle_events(event.pull())
-- end

-- @TODO.txt
-- resize? see how content could adjust
-- tiling wm with vim-like keybinding
-- bars and widgets
-- help page (keybindings, etc)
-- windows with special colors