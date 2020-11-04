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

local function pollingTask(bot, dir)
  local files = exec("ls "..dir)
  for k, v in ipairs(files) do
    os.execute("echo 加载"..v:gsub("%.lua", ""))
    local app = require(dir.."/"..v:gsub("%.lua", ""))
    -- 由文件自行开启线程
    app.run()
  end
end

local function onLoad(bot)
  loadDir(bot, "groupMessage")
  pollingTask(bot, "pollingTask")
end

local config = require("config")
bot = Bot(config.Username, config.Password, "device.json")
bot:login()
onLoad(bot)