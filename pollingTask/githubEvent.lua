-- github推送

local config = require("config")
local receiver = {
   {
    user = "limj0825",
    repo = "PcrRobot",
    type = "friend",
    id = config["Id"][0],
    token = config["Token"][0]
  }
}
local user = "limj0825"
local repo = "PcrRobot"
local json = require("common.json")

local github = function (user, repo, token, sender)
  while true do
    local body,isSuccessful,code,message = Http.get(
      "https://api.github.com/repos/"..user.."/"..repo.."/events",
      {
          connectTimeout = 5000,
          readTimeout = 5000,
          followRedirects = true,
          writeTimeout = 5000
      },

      {
        Authorization = token
      }
    )

    if isSuccessful and code == 200 then
      local data = json.decode(body)
      local githubId = json.read("database/githubPushId.json")
      for i = math.min(10, #data), 1, -1 do
        if data[i].type ~= "PushEvent" then
          goto continue
        end
        if githubId[data[i].id] ~= nil then
          goto continue
        end
        githubId[data[i].id] = 1
        for j = 1, #(data[i].payload.commits) do
          local commit = data[i].payload.commits[j]
          sender:sendMessage("https://github.com/"..user.."/"..repo.."/commits/"..commit.sha.."\n"
                            ..commit.author.name.." push "..data[i].payload.ref.." "..commit.message)
          os.execute("sleep 5")
        end
        ::continue::
      end
      json.write("database/githubPushId.json", githubId)
    else
      print("获取仓库信息失败 "..message.." "..code)
    end
    os.execute("sleep 30")
  end
end

local genLaunch = function ()
  for k, v in ipairs(receiver) do
    if v.type == "friend" then
      if not bot:containsFriend(v.id) then
        print(v.id.." 好友不存在")
        return
      end
      local sender = bot:getFriend(v.id)
      github(v.user, v.repo, v.token, sender)
    elseif v.type == "group" then
      if not bot:containsGroup(v.id) then
        print(v.id.. " 群不存在")
        return
      end
      local sender = bot:getGroup(v.id)
      github(v.user, v.repo, v.token, sender)
    end
  end
end

return {
  run = genLaunch
}