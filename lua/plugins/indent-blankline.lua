-- local vim = require("vim")

return {
      repo = 'lukas-reineke/indent-blankline.nvim',
      event = { 'BufReadPost', 'BufNewFile' },
      main = 'ibl',
      opts = {
        indent = {
          char = '┊',
          tab_char = '▏',
          highlight = { 'Whitespace', 'IblIndent' },
          smart_indent_cap = true,
          priority = 1,
        },
        scope = {
          show_start = true,
          show_end = true,
          show_exact_scope = false,
          highlight = { 'IblScope' },
          priority = 2,
        },
        exclude = {
          filetypes = {
            'help', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason',
            'notify', 'toggleterm', 'lazyterm', 'qf', 'terminal'
          },
          buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
        },
      },
      config = function(_, opts)
        vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3b4048', nocombine = true })
        vim.api.nvim_set_hl(0, 'IblScope', { fg = '#4b5262', nocombine = true })
        require('ibl').setup(opts)
        vim.keymap.set('n', '<leader>ui', function()
          local ibl = require('ibl')
          ibl.toggle()
          vim.notify('Indent guides ' .. (ibl.is_enabled() and 'enabled' or 'disabled'))
        end, { desc = 'Toggle indent guides' })
        vim.api.nvim_create_autocmd('ColorScheme', {
          callback = function()
            vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3b4048', nocombine = true })
            vim.api.nvim_set_hl(0, 'IblScope', { fg = '#4b5262', nocombine = true })
            require('ibl').update()
          end,
        })
      end,
    }