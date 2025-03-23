# nvim-shadcn

A Neovim plugin to add Shadcn UI components to your project with ease. This plugin integrates with Telescope to provide a user-friendly interface for selecting and installing shadcn components directly.

## Demo

![nvim-shadcn-demo](demo/nvim-shadcn.gif)

## Prerequisites

- Neovim 0.8+
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'BibekBhusal/nvim-shadcn',
  dependencies = {
    'nvim-telescope/telescope.nvim'
  },
  config = function()
    require('nvim-shadcn').setup({
      -- Configuration options here
    })
  end
}
```

## Configuration

The following is the default configuration for the plugin. You can customize it by modifying the options in the setup function:

```lua
require('nvim-shadcn').setup({
  default_installer = 'npm',

  format = {
    doc = 'https://ui.shadcn.com/docs/components/%s',
    npm = 'npx shadcn@latest add %s',
    pnpm = 'pnpm dlx shadcn@latest add %s',
    yarn = 'npx shadcn@latest add %s',
    bun = 'bunx --bun shadcn@latest add %s',
  },

  keys = { -- for telescope
    i = { doc = '<C-o>' },
    n = { doc = '<C-o>' },
  },

  telescope_config = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
      ...
    },
    prompt_title = 'Shadcn UI components',
  },
})
```

### Customization Options

- **`default_installer`**: Set the package manager to use for installing components. Options include `npm`, `pnpm`, `yarn`, `bun` or you can even add your own.
- **`format`**: Customize the command format for adding components and the documentation URL. You can modify the commands for each package manager as needed or even add new package manager.
- **`components`**: Includes all components from shadcn website but if something is messing that can be added all components can be seen list [here](lua/nvim-shadcn/components.lua).
- **`keys`**: Customize key mappings for opening documentation or installing with different package manager. The default is only for documentation set to `<C-o>`.
- **`telescope_config`**: Adjust the Telescope settings.

## Usage

`:ShadcnAdd` - Opens a Telescope picker to select a component to add.

`:ShadcnAdd <component_name>` - Adds the specified component directly.

## Keymaps

`doc`: Opens the documentation for the selected component from telescope (default: `<C-o>`).

if you want to install component with different package manager you can set custom keymap for it like:

```lua
require('nvim-shadcn').setup({
    keys = {
        i = { yarn = '<C-y>' },
        n = { yarn = '<C-y>' }
    },
    ...
})
```

Setting up custom keymaps for installing can be done this way:

```lua
vim.keymap.set('n', '<leader>sa', ':ShadcnAdd<CR>', { noremap = true, silent = true })
```

## License

This project is licensed under the [MIT License](LICENSE).

## Credits

[browser.nvim](https://github.com/lalitmee/browse.nvim)
[shadcn/ui](https://ui.shadcn.com/docs)
