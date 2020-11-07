-- 猜头像

local exec = require("common.osexec").exec
local json = require("common.json")

local game = false
local pcr = "..."
local data = "..."
local url = "https://redive.estertion.win/icon/unit/"
local avatarPath = exec("pwd")[1].."/static/avatar/"
local path = ""
local pre = 0
local id = 0

local getRandAvatar = function ()
  math.randomseed(os.time())
  local len = 0
  for k, v in pairs(data) do
    len = len + 1
  end
  local idx = math.random(1, len)
  for k, v in pairs(data) do
    if idx == 1 then
      pcr = k
      id = k
      break
    end
    idx = idx - 1
  end
  local star = math.random(1, 3)
  path = avatarPath..pcr
  if star == 2 then
    star = 3
  elseif star == 3 then
    star = 6
  end
  path = path..star.."1.jpg"
  pcr = url..pcr..star.."1.webp"
  os.execute("python3 common/image.py download "..pcr.." "..path)
end

local start = function (event)
  local msg = event.message
  local sender = event.sender
  local group = event.group
  if msg == "猜头像" then
    if game or os.time() - pre <= 25 then
      group:sendMessage("此轮游戏还没结束")
      return
    end
    pre = os.time()
    game = true
    data = json.read("static/characterInfo/name.json")
    getRandAvatar()
    while true do
      local ret = os.execute("ls "..path)
      if ret ~= nil then
        break
      end
      getRandAvatar()
    end
    local crop = exec("python3 common/image.py guessAvatar "..path)[1]
    bot:launch(function()
      group:sendMessage("猜猜下面这个图片是来自哪位角色头像的一部分(20s后公布答案)\n"..ImageUrl("file://"..crop, group))
      os.execute("sleep 20s")
      if game then
        group:sendMessage("很遗憾，没有人猜对，正确答案是"..data[id][1].."\n"..ImageUrl("file://"..path, group))
        game = false
      end
    end)
  else
    if not game then
      return
    end
    for i = 1, #data[id] do
      if msg == data[id][i] then
        game = false
        group:sendMessage(At(sender).. "猜对了，正确答案是"..data[id][1].."\n"..ImageUrl("file://"..path, group).."\n此轮游戏将在若干秒后结束")
      end
    end
  end
end

local guessAvatar = function (event)
  print("guessAvatar")
  start(event)
end

return {
  run = guessAvatar
}