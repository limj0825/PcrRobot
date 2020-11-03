local commandList = {
    '今日人品', '今日运势', '抽签', '人品', '运势',
    'kkr签', '妈签',
    'xcw签', '炼签',
    'kyaru签', '臭鼬签'
}
local check = function (msg)
  for i = 1, #commandList do
    if msg == commandList[i] then
      return true
    end
  end
  return false
end

local fortune = function (event)
  print("fortune")
  local msg = event.message
  local sender = event.sender
  local group = event.group
  if not check(msg) then
    return false
  end
  local exec = require("common.osexec").exec
  local now_path = exec("pwd")[1]
  local path = exec("python3 models/opqqq-plugin/plugins/bot_pcr_fortune.py "..msg.." "..sender.id)[1]
  if path == "0" then
    group:sendMessage(At(sender).." 你今天已经抽过签啦！")
  else
    group:sendImage("file://"..now_path.."/"..path)
  end
end

return {
  run = fortune,
  event = {"GroupMessageEvent"}
}