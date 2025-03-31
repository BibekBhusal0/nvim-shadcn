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

local function add_component(component, installer)
  local config = require('nvim-shadcn.config').config
  if installer == 'doc' then
    open_doc(component)
    return
  end
  installer = installer or config.default_installer
  local command_format = config.format[installer]
  if not command_format then
    return
  end
  local cmd = string.format('echo "yes" | %s', command_format:format(component))

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify(
          string.format('Component %s added successfully!', component),
          vim.log.levels.INFO
        )
      else
        vim.notify(string.format('Error adding component %s', component), vim.log.levels.ERROR)
      end
    end,
    on_stdout = function(_, data)
      if config.verbose then
        print(table.concat(data, '\n'))
      end
    end,
    on_stderr = function(_, data)
      if config.verbose then
        print(table.concat(data, '\n'))
      end
    end,
  })
end

local function init(installer)
  local config = require('nvim-shadcn.config').config

  local flags = config.init_command.flags
  installer = installer or config.default_installer
  local command_format = config.init_command.commands[installer]
  if not command_format then
    return
  end

  local flag_string = ''
  if flags then
    for k, v in pairs(flags) do
      if v == true then
        flag_string = flag_string .. ' ' .. '--' .. k
      elseif type(v) == 'string' then
        flag_string = flag_string .. ' ' .. '--' .. k .. '=' .. v
      end
    end
  end
  local cmd = string.format('%s %s', command_format, flag_string)

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify('Shadcn UI initialized successfully!', vim.log.levels.INFO)
      else
        vim.notify('Error initializing Shadcn UI', vim.log.levels.ERROR)
      end
    end,

    stdout_buffered = false,
    stderr_buffered = false,
    pty = true,
    stdin_close = false,

    on_stdout = function(job_id, data)
      local function strip_ansi_codes(str)
        str = str:gsub('\27%[[%d;]*[mK]?', '')
        str = str:gsub('lH%?25h', '')
        str = str:gsub('%?25.', '')
        str = str:gsub('JH%[%d*;?%]', '')
        return str
      end

      local output = table.concat(data, '\n')

      output = strip_ansi_codes(output)

      local color_options = { 'Neutral', 'Gray', 'Zinc', 'Stone', 'Slate' }
      local default_color = config.init_command.default_color or 'Gray'

      if output:find('Which color would you like to use as the base color') then
        local default_index = 1
        for i, color in ipairs(color_options) do
          if color == default_color then
            default_index = i
            break
          end
        end

        for _ = 1, default_index - 1 do
          vim.fn.jobsend(job_id, '\27[B')
        end
        vim.fn.jobsend(job_id, '\13')
      end
    end,

    on_stderr = function(_, data)
      if config.verbose then
        print('')
        for _, line in ipairs(data) do
          vim.notify(line, vim.log.levels.INFO)
        end
      end
    end,
  })
end

return { add_component = add_component, open_doc = open_doc, init = init }
