-- 查新闻

local json = require("common.json")

local news = function (msg)
  if msg == "查看新闻" then
    local body,isSuccessful,code,message = Http.get(
      "https://api.biligame.com/news/list?gameExtensionId=267&positionId=2&pageNum=1&pageSize=50&typeId=4",
      {
          connectTimeout = 5000,
          readTimeout = 5000,
          followRedirects = true,
          writeTimeout = 5000
      }
    )
    if isSuccessful and code == 200 then
      local data = json.decode(body)
      local allnews = {}
      for i = 1, 3 do
        table.insert(allnews, tostring(i)..". "..data.data[i].title.." 新闻id "..tostring(data.data[i].id))
      end
      return "已为骑士君查到以下新闻，输入 [查看新闻 id] 即可查看详情内容哟~\n"..
             table.concat(allnews, "\n")
    else
      print("查询错误 "..code.." "..message)
      return "查询出错啦，稍后再试吧！"
    end
  elseif msg:find("%d+") then
    local v = tonumber(msg:match("(%d+)"))
    return "新闻链接 https://game.bilibili.com/pcr/news.html#detail="..tostring(v)
  else
    return "没有匹配到任何命令"
  end
end

local check = function(msg)
    return msg:find("查看新闻") == 1
end

local function getNews(event)
  print("getNews")
  local msg = event.message
  local sender = event.sender
  local group = event.group
  if not check(msg) then
    return false
  end
  group:sendMessage(At(sender).." "..news(msg))
end

return {
  run = getNews
}
