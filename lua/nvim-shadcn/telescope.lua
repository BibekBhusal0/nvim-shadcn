M = {}

local function add_component(component, installer)
  local config = require('nvim-shadcn.config').config
  installer = installer or config.default_installer
  local command_format = config.format[installer]
  if not command_format then
    return
  end
  local cmd = string.format('echo "yes" | %s', command_format:format(component))
  local result = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    print('Component added successfully!')
  else
    print('Error adding component: ' .. result)
  end
end

-- https://github.com/lalitmee/browse.nvim/blob/main/lua/browse/utils.lua
local get_os_name = function()
  local os = vim.loop.os_uname()
  local os_name = os.sysname
  return os_name
end

-- WSL
local is_wsl = function()
  local output = vim.fn.systemlist('uname -r')
  return not not string.find(output[1] or '', 'WSL')
end

-- get open cmd
local get_open_cmd = function()
  local os_name = get_os_name()
  local open_cmd = nil
  if os_name == 'Windows_NT' or os_name == 'Windows' then
    open_cmd = { 'cmd', '/c', 'start' }
  elseif os_name == 'Darwin' then
    open_cmd = { 'open' }
  else
    if is_wsl() then
      open_cmd = { 'wsl-open' }
    else
      open_cmd = { 'xdg-open' }
    end
  end
  return open_cmd
end

-- start the browser job
local open_browser = function(target)
  target = vim.fn.trim(target)
  local open_cmd = vim.fn.extend(get_open_cmd(), { target })
  vim.fn.jobstart(open_cmd, { detach = true })
end

local open_doc = function(component)
  local config = require('nvim-shadcn.config').config
  open_browser(string.format(config.format.doc:format(component)))
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
          -- map(key, value.doc, run_action(add_component))
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
          -- map(key, value.doc, run_action(add_component))
        end
        -- map({ 'i', 'n' }, '<C-o>', run_action(open_doc))
        return true
      end,
    })
    :find()
end

return { pick_component = pick_component }
