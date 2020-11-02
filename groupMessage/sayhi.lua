-- 日常互动
local bot = {"镜华", "xcw", "小仓唯"}
local message = {"摸摸头", "亲亲", "抱抱", "晚安", "早上好", "中午好", "下午好", "晚上好", "老婆"}
local send = {"我很乖哒！", "mua木马", "给你一个大大的拥抱", "晚安呀，祝你做个好梦", "早上好呀，今天又是元气满满的一天",
              "中午好呀，需要午休吗？", "下午好呀，摸会儿鱼就可以下班啦！", "晚上好呀，今晚有没有吃饱饱？", "你在想peach，爪巴"}
local lsp = {"kkp", "摸摸胸", "看看批"}
local ban = {"sb", "傻逼", "煞笔", "爬", "爪巴"}

local check = function(msg)
  for i = 1, #bot do
      if msg:find(bot[i]) ~= nil then
          return true
      end
  end
  return false
end

local config = require("config")

return {
run = function (event)
  local msg = event.message
  local sender = event.sender
  local group = event.group
  if not check(msg) then
    return false
  end
  for i = 1, #lsp do
    if msg:find(lsp[i]) ~= nil then
      if sender.id ~= config.AdminQQ then
        sender:mute(10)
        group:sendMessage(At(sender).." 一开口就是lsp了，爪巴")
      else
        group:sendMessage(At(sender).." 主人你老实一点, 我有防狼喷雾哟")
      end
      return true
    end
  end
  for i = 1, #ban do
    if msg:find(ban[i]) ~= nil then
      if sender.id ~= config.AdminQQ then
        sender:mute(10)
        group:sendMessage(At(sender).." 请不要嘴臭")
      else
        group:sendMessage(At(sender).."主人别骂我QAQ")
      end
      return true
    end
  end
  if msg:find("喷水") ~= nil then
    ImageFile("static/gif/xcwub.gif", group)
    return true
  end
  for i = 1, #message do
    if msg:find(message[i]) ~= nil then
      group:sendMessage(At(sender).." "..send[i])
      return true
    end
  end
  return false
end,
event = {"GroupMessageEvent"}
}
