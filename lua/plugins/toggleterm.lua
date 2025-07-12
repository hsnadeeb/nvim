-- local vim = require("vim")

return {
  {
    repo = "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      -- Keybindings
      vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>', { desc = 'Float Terminal' })
      vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=horizontal<CR>', { desc = 'Horizontal Terminal' })
      vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical<CR>', { desc = 'Vertical Terminal' })
      vim.keymap.set('n', '<leader>`', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
      vim.keymap.set('t', '<leader>`', '<C-\\><C-n>:ToggleTerm<CR>', { desc = 'Toggle Terminal' })
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
      vim.keymap.set('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Move to left window' })
      vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Move to lower window' })
      vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Move to upper window' })
      vim.keymap.set('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Move to right window' })

      -- Terminal buffer options
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          -- local opts = { buffer = 0 }
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.cmd("startinsert!")
        end,
      })
    end,
  },
}