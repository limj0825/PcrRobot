local exec = require("common/osexec").exec

local function loadDir(bot, dir)
  local files = exec("ls "..dir)
  for k, v in ipairs(files) do
    local app = require(dir.."/"..v:gsub("%.lua", ""))
    for i = 1, #app.event do
     bot:subscribe(app.event[i], app.run)
    end
  end
end

local function onLoad(bot)
  loadDir(bot, "groupMessage")
end

local config = require("config")
local bot = Bot(config.Username, config.Password, "device.json")
bot:login()
onLoad(bot)