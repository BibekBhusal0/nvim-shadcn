M = {}

local function add_component(component, installer)
  local config = require('nvim-shadcn.config').config
  installer = installer or config.default_installer
  local command_format = config.format[installer]
  if not command_format then
    return
  end
  local cmd = string.format('echo "yes" | %s', command_format:format(component))
  print('running command ' .. cmd)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    print('Component added successfully!')
  else
    print('Error adding component: ' .. result)
  end
end

local function pick_component()
  local config = require('nvim-shadcn.config').config
  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Shadcn UI Components',
      finder = require('telescope.finders').new_table({
        results = config.components,
      }),
      sorter = require('telescope.config').values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local actions = require('telescope.actions')
        actions.select_default:replace(function()
          local selection = require('telescope.actions.state').get_selected_entry()
          actions.close(prompt_bufnr)
          add_component(selection.value)
        end)
        return true
      end,
    })
    :find()
end

return { pick_component = pick_component }
