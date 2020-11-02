local exec = require("common/osexec").exec

local function loadDir(bot, dir)
  local files = exec("ls "..dir)
  for k, v in ipairs(files) do
    os.execute("echo 加载"..v:gsub("%.lua", ""))
    local app = require(dir.."/"..v:gsub("%.lua", ""))
    for i = 1, #app.event do
      os.execute("echo 绑定事件"..app.event[i])
      bot:subscribe(app.event[i], app.run)
    end
  end
end

local function onLoad(bot)
  loadDir(bot, "groupMessage")
end

os.execute("> log")
local config = require("config")
local bot = Bot(config.Username, config.Password, "device.json")
bot:login()
onLoad(bot)