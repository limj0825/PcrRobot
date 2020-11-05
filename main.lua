local exec = require("common/osexec").exec

local function loadDir(bot, dir)
  local files = exec("ls "..dir)
  for k, v in ipairs(files) do
    os.execute("echo 加载"..v:gsub("%.lua", ""))
    local app = require(dir.."/"..v:gsub("%.lua", ""))
    os.execute("echo 绑定事件 "..dir)
    bot:subscribe(dir, app.run)
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

local function init()
  -- 创建database
  local ret = os.execute("cd database")
  if ret ~= true then
    os.execute("mkdir database")
  end
end

local function onLoad(bot)
  init()
  loadDir(bot, "GroupMessageEvent")
  -- 如果因为网络问题不能访问github，请注释掉下面的任务
  -- pollingTask(bot, "pollingTask")
end

local config = require("config")
bot = Bot(config.Username, config.Password, "device.json")
bot:login()
onLoad(bot)