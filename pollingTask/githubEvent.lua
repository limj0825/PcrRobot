-- github推送

local user = "limj0825"
local repo = "PcrRobot"
local json = require("common.json")

local github = function ()
  local admin = bot:getFriend(require("config").AdminQQ)
  while true do
    local body,isSuccessful,code,message = Http.get(
      "https://api.github.com/repos/"..user.."/"..repo.."/events",
      {
          connectTimeout = 5000,
          readTimeout = 5000,
          followRedirects = true,
          writeTimeout = 5000
      }
    )

    if isSuccessful and code == 200 then
      local data = json.decode(body)
      local githubId = json.read("githubPushId.json")
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
          print(data[i].payload.sha)
          admin:sendMessage("https://github.com/"..user.."/"..repo.."/commits/"..commit.sha.."\n"
                            ..commit.author.name.." push "..data[i].payload.ref.." "..commit.message)
          os.execute("sleep 5")
        end
        ::continue::
      end
      json.write("githubPushId.json", githubId)
    else
      admin:sendMessage("获取仓库信息失败")
    end
    os.execute("sleep 30")
  end
end

return {
  run = github
}