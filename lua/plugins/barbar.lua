-- local vim = require("vim")

return {
    {
      repo = 'romgrk/barbar.nvim',
      dependencies = {
        { repo = 'lewis6991/gitsigns.nvim' },
        { repo = 'nvim-tree/nvim-web-devicons' },
      },
      init = function()
        vim.g.barbar_auto_setup = false
      end,
      config = function()
        require('barbar').setup({
          animation = true,
          auto_hide = 1,
          tabpages = true,
          clickable = true,
          icons = {
            filetype = { enabled = true },
            button = '󰖭',
            modified = { button = '●' },
            inactive = { button = '×' },
          },
        })
      end,
    },
  }