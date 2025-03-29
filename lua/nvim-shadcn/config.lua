local M = {}

M.config = {
  default_installer = 'npm',

  format = {
    doc = 'https://ui.shadcn.com/docs/components/%s',
    npm = 'npx shadcn@latest add %s',
    pnpm = 'pnpm dlx shadcn@latest add %s',
    yarn = 'npx shadcn@latest add %s',
    bun = 'bunx --bun shadcn@latest add %s',
  },

  components = require('nvim-shadcn.components'),
  important = { 'button', 'card', 'checkbox', 'tooltip' },

  keys = {
    i = { doc = '<C-o>' },
    n = { doc = '<C-o>' },
  },

  init_command = {
    commands = {
      npm = 'npx shadcn@latest init',
      pnpm = 'pnpm dlx shadcn@latest init',
      yarn = 'npx shadcn@latest init',
      bun = 'bunx --bun shadcn@latest init',
    },
    flags = { defaults = false, force = false },
    default_color = 'Gray',
  },

  telescope_config = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
      width = function(_, max_columns, _)
        return math.min(max_columns, 80)
      end,
      height = function(_, _, max_lines)
        return math.min(max_lines, 20)
      end,
    },
    prompt_title = 'Shadcn UI components',
  },
}

return M
