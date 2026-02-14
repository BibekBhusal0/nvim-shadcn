M = {}
local components = require('nvim-shadcn.components')

---@param argLead string
---@param cmdLine string
---@return string candidates_string
M.complete_shadcn_add = function(argLead, cmdLine)
  local candidates = {}
  for _, component in ipairs(components) do
    local added = cmdLine:find(component, 1, true) ~= nil
    if not added then
      table.insert(candidates, component)
    end
  end

  return table.concat(candidates, '\n')
end

return M
