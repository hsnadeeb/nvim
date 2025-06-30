local M = {}

-- Load utility functions
local utils = require("utils")

function M.setup()
  local status_ok, toggleterm = pcall(require, "toggleterm")
  if not status_ok then
    vim.notify("toggleterm.nvim not found!", vim.log.levels.ERROR)
    return
  end

  -- Configure toggleterm
  toggleterm.setup({
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

  -- Setup keybindings
  -- Directional terminals
  utils.map('n', '<leader>tf', ':ToggleTerm direction=float<CR>', { desc = 'Float Terminal' })
  utils.map('n', '<leader>tt', ':ToggleTerm direction=horizontal<CR>', { desc = 'Horizontal Terminal' })
  utils.map('n', '<leader>tv', ':ToggleTerm direction=vertical<CR>', { desc = 'Vertical Terminal' })
  -- Toggle between terminal and last buffer
  utils.map('n', '<leader>`', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
  utils.map('t', '<leader>`', '<C-\\><C-n>:ToggleTerm<CR>', { desc = 'Toggle Terminal' })
  
  -- Terminal window navigation (when in terminal mode)
  utils.map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  utils.map('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Move to left window' })
  utils.map('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Move to lower window' })
  utils.map('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Move to upper window' })
  utils.map('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Move to right window' })

  -- Function to set terminal buffer options when a terminal is opened
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
      local opts = {buffer = 0}
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.cmd("startinsert!")
    end,
  })
end

return M