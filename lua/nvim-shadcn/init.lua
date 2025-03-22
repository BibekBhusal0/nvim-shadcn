local components = require('nvim-shadcn.components')

local function add_component(component)
  local cmd = string.format('echo "yes" | npx shadcn@latest add %s', component)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    print('Component added successfully!')
  else
    print('Error adding component: ' .. result)
  end
end

local function pick_component()
  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Shadcn UI Components',
      finder = require('telescope.finders').new_table({
        results = components.components,
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

vim.api.nvim_create_user_command('ShadcnAdd', pick_component, {})

return {
  pick_component = pick_component,
}
