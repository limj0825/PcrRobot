-- 猜头像

local exec = require("common.osexec").exec
local json = require("common.json")

local game = false
local pcr = "..."
local data = "..."
local url = "https://redive.estertion.win/icon/unit/"
local pwd = exec("pwd")[1]
local avatarPath = pwd.."/static/avatar/"
local path = ""
local pre = 0
local id = 0
local turn = 0
local rankPath = pwd.."/database/guessAvatar.json"

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
  local star = math.random(1, 10)
  path = avatarPath..pcr
  if star <= 8 then
    star = 3
  else
    star = 6
  end
  path = path..star.."1.png"
  pcr = url..pcr..star.."1.webp"
  local file = io.open(path, "r")
  if file ~= nil then
    io.close(file)
  else
    os.execute("python3 common/image.py download "..pcr.." "..path)
  end
end

local start = function (event)
  local msg = event.message
  local sender = event.sender
  local group = event.group
  if msg == "猜头像" then
    if game and os.time() - pre <= 25 then
      group:sendMessage("此轮游戏还没结束")
      return
    end
    turn = turn + 1
    local nowTurn = turn
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
      if game and nowTurn == turn then
        group:sendMessage("很遗憾，没有人猜对，正确答案是 "..data[id][1].."\n"..ImageUrl("file://"..path, group))
        game = false
      end
    end)
  elseif msg == "猜头像排行榜" then
    local rank = json.read(rankPath)
    local msg = "猜头像排行榜如下"
    local now = {}
    local num = 0
    for k, v in pairs(rank) do
      if num == 10 then
        break
      end
      num = num + 1
      now[num] = {id=tonumber(k), times=v}
    end
    num = 0
    table.sort(now, function(a, b) return a.times > b.times end)
    for k, v in pairs(now) do
      local member = group:getMember(v.id)
      num = num + 1
      msg = msg.."\n"..num..". "..member.nameCardOrNick.." "..v.times.." 次"
    end
    if num == 0 then
      msg = msg.."\n还没有人猜头像呢!"
    end
    group:sendMessage(msg)
  else
    if not game or data == "..." then
      return
    end
    for i = 1, #data[id] do
      if msg == data[id][i] then
        local rank = json.read(rankPath)
        game = false
        if rank[tostring(sender.id)] == nil then
          rank[tostring(sender.id)] = 0
        end
        rank[tostring(sender.id)] = rank[tostring(sender.id)] + 1
        group:sendMessage(At(sender).." 猜对了，正确答案是 "..data[id][1].." TA已经猜对了 "..tostring(rank[tostring(sender.id)]).." 次了\n"..ImageUrl("file://"..path, group))
        json.write(rankPath, rank)
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