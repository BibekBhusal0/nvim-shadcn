local config_module = require('nvim-shadcn.config')
local config = config_module.config
local pick_component = require('nvim-shadcn.telescope').pick_component
local add_component = require('nvim-shadcn.utils').add_component
local init = require('nvim-shadcn.utils').init

M = { pick_component = pick_component }

M.setup = function(opts)
  config = vim.tbl_deep_extend('force', config, opts)
  config_module.config = config

  vim.api.nvim_create_user_command('ShadcnAdd', function(args)
    local user_args = args.args

    -- Split the arguments by spaces
    if user_args and string.find(user_args, '%s') then
      local components = vim.split(user_args, '%s')
      for _, component in ipairs(components) do
        local found = false
        for _, valid_component in ipairs(config.components) do
          if valid_component == component then
            add_component(component)
            found = true
            break
          end
        end
        if not found then
          print(string.format("Component '%s' not found in config.components", component))
        end
      end

      -- Single argument case
    elseif user_args then
      local found = false
      for _, component in ipairs(config.components) do
        if component == user_args then
          add_component(user_args)
          found = true
          break
        end
      end
      if not found then
        pick_component()
      end
    else
      -- No arguments provided
      pick_component()
    end
  end, { nargs = '*' })

  vim.api.nvim_create_user_command('ShadcnInit', function(args)
    init()
  end, { nargs = '*' })

  --
end

return M
