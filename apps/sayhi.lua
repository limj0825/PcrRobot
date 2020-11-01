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

return {
run = function (data,sendMessage)
    for i = 1, #lsp do
        if data.msg:find(lsp[i]) ~= nil then
            if data.qq ~= Utils.setting.AdminQQ then
                cqSetGroupBanSpeak(data.group, data.qq, 600)
                sendMessage(Utils.CQCode_At(data.qq).."一开口就是lsp了，爪巴")
            else
                sendMessage(Utils.CQCode_At(data.qq).."主人你老实一点, 我有防狼喷雾哟")
            end
            return true
        end
    end
    for i = 1, #ban do
        if data.msg:find(ban[i]) ~= nil then
            if data.qq ~= Utils.setting.AdminQQ then
                cqSetGroupBanSpeak(data.group, data.qq, 600)
                sendMessage(Utils.CQCode_At(data.qq).."请不要嘴臭")
            else
                sendMessage(Utils.CQCode_At(data.qq).."主人别骂我QAQ")
            end
            return true
        end
    end
    if data.msg:find("喷水") ~= nil then
        sys.taskInit(function ()
            sendMessage(asyncImage("https://patchwiki.biligame.com/images/pcr/6/64/6wqojx2cvmntjflaij172rbjduqs898.gif"))
        end)
        return true
    end
    for i = 1, #message do
        if data.msg:find(message[i]) ~= nil then
            sendMessage(Utils.CQCode_At(data.qq)..send[i])
        return true
        end
    end
    return false
end
}
