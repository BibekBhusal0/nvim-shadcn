local config_module = require('nvim-shadcn.config')
local config = config_module.config
local pick_component = require('nvim-shadcn.telescope').pick_component
local init = require('nvim-shadcn.utils').init

M = { pick_component = pick_component, init = init }

M.setup = function(opts)
  config = vim.tbl_deep_extend('force', config, opts)
  config_module.config = config
end

return M
