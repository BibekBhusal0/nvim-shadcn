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

  keys = {
    i = { doc = '<C-o>' },
    n = { doc = '<C-o>' },
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
