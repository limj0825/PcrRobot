local lfs = require("lfs")
local function onLoad(bot)
  for file in lfs.dir("./apps") do
    local app = require(file)
    for i = 1, #app.event do 
      bot:subscribe(app.event[i], app.run)
    end
  end
end

local config = require("config")
local bot = Bot(config.Username, config.Password, "device.json")
bot:login()
onLoad(bot)