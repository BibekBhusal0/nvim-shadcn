local config_module = require('nvim-shadcn.config')
local config = config_module.config
local pick_component = require('nvim-shadcn.telescope').pick_component
local add_component = require('nvim-shadcn.utils').add_component

M = { pick_component = pick_component }

M.setup = function(opts)
  config = vim.tbl_deep_extend('force', config, opts)
  config_module.config = config

  vim.api.nvim_create_user_command('ShadcnAdd', function(args)
    local user_args = args.args
    for _, component in ipairs(config.components) do
      if component == user_args then
        add_component(user_args)
        return
      end
    end
    pick_component()
  end, { nargs = '*' })
end

return M
