local config_module = require('nvim-shadcn.config')
local config = config_module.config
local pick_component = require('nvim-shadcn.telescope').pick_component

M = { pick_component = pick_component }

M.setup = function(opts)
  config = vim.tbl_deep_extend('force', config, opts)
  config_module.config = config

  vim.api.nvim_create_user_command('ShadcnAdd', pick_component, {})
end

return M
