local run = function(cmd)
  local ans = {}
  local handle = io.popen(cmd)
  for line in handle:lines() do
    table.insert(ans, line)
  end
  handle:close()
  return ans
end

return {
  exec = run
}