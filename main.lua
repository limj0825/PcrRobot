function listener(event)
  local msg = event.message
  local sender = event.group
  if msg:find("青萝") ~= nil then
    sender:sendMessage(Quote(msg) .. "青萝和鬼姬好漂亮")
  end
end

function onLoad(bot)
  bot:subscribe("GroupMessageEvent",listener)
end

local config = require("config")
local bot = Bot(config.username, config.password, "device.json")
bot:login()
onLoad(bot)