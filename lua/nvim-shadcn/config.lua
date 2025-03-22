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
}

return M
