local add_component = require('nvim-shadcn.utils').add_component
local open_doc = require('nvim-shadcn.utils').open_doc

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
        local run_action = function(callback)
          return function()
            local selection = require('telescope.actions.state').get_selected_entry()
            actions.close(prompt_bufnr)
            callback(selection.value)
          end
        end
        actions.select_default:replace(run_action(add_component))

        for key, value in pairs(config.keys.i) do
          if key == 'doc' then
            map({ 'i' }, value, run_action(open_doc))
          else
            map(
              { 'i' },
              value,
              run_action(function(component)
                add_component(component, key)
              end)
            )
          end
        end
        for key, value in pairs(config.keys.n) do
          if key == 'doc' then
            map({ 'n' }, value, run_action(open_doc))
          else
            map(
              { 'n' },
              value,
              run_action(function(component)
                add_component(component, key)
              end)
            )
          end
        end
        return true
      end,
    })
    :find()
end

return { pick_component = pick_component }
