-- local vim = require("vim")
return {
    {
      repo = 'mfussenegger/nvim-dap',
      dependencies = {
        { repo = 'rcarriga/nvim-dap-ui' },
        { repo = 'theHamsta/nvim-dap-virtual-text' },
        { repo = 'nvim-telescope/telescope-dap.nvim' },
        { repo = 'nvim-neotest/nvim-nio' },
      },
      config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
          { desc = 'Debug: Set Conditional Breakpoint' })
        dapui.setup()
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
        require('nvim-dap-virtual-text').setup()
        require('telescope').load_extension('dap')
      end
    },
  }