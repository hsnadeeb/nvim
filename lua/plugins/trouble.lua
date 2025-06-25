return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' },
  keys = {
    {
      '<leader>xx',
      function() require('trouble').toggle() end,
      mode = 'n',
      desc = 'Toggle Trouble',
    },
  },
  config = function()
    require('trouble').setup({
      -- Minimal configuration
      position = 'bottom',
      height = 10,
      width = 50,
      icons = true,
      mode = 'workspace_diagnostics',
      auto_open = false,
      auto_close = false,
      use_diagnostic_signs = true,
    })

    -- Set up keymaps after plugin is loaded
    vim.keymap.set('n', '<leader>xw', function() require('trouble').toggle('workspace_diagnostics') end, { silent = true, noremap = true, desc = 'Workspace diagnostics' })
    vim.keymap.set('n', '<leader>xd', function() require('trouble').toggle('document_diagnostics') end, { silent = true, noremap = true, desc = 'Document diagnostics' })
    vim.keymap.set('n', '<leader>xq', function() require('trouble').toggle('quickfix') end, { silent = true, noremap = true, desc = 'Quickfix list' })
    vim.keymap.set('n', 'gR', function() require('trouble').toggle('lsp_references') end, { silent = true, noremap = true, desc = 'LSP References' })

    vim.notify('Trouble.nvim loaded with minimal configuration', vim.log.levels.INFO)
  end
}
