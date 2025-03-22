-- tests/init_spec.lua
local config_module = require('nvim-shadcn.config')
local add_component = require('nvim-shadcn.utils').add_component
local pick_component = require('nvim-shadcn.telescope').pick_component
local init = require('nvim-shadcn.init') -- Adjust the path as necessary

describe('nvim-shadcn.init', function()
  local original_config

  before_each(function()
    -- Store the original config to restore later
    original_config = vim.deepcopy(config_module.config)
    -- Reset the config to a known state
    config_module.config = { components = { 'component1', 'component2' } }
  end)

  after_each(function()
    -- Restore the original config
    config_module.config = original_config
  end)

  describe('setup', function()
    it('should extend the configuration with provided options', function()
      local opts = { components = { 'component1', 'component3' } }
      init.setup(opts)
      assert.are.same(config_module.config.components, { 'component1', 'component3' })
    end)
  end)

  describe('ShadcnAdd command', function()
    before_each(function()
      init.setup({ components = { 'component1', 'component2' } })
    end)

    it('should add a component when a valid component is provided', function()
      local add_component_called = false

      -- Mock the add_component function
      _G.add_component = function(component)
        add_component_called = true
        assert.are.equal(component, 'component1')
      end

      -- Execute the command
      vim.api.nvim_command('ShadcnAdd component1')

      assert.is_true(add_component_called)
    end)

    it('should call pick_component when an invalid component is provided', function()
      local pick_component_called = false

      -- Mock the pick_component function
      _G.pick_component = function()
        pick_component_called = true
      end

      -- Execute the command
      vim.api.nvim_command('ShadcnAdd invalid_component')

      assert.is_true(pick_component_called)
    end)
  end)
end)
