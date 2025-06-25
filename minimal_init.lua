-- Minimal Neovim configuration to debug nvim-tree
vim.g.mapleader = ' '

-- Only load lazy.nvim and nvim-tree
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
      
      -- Basic keybindings
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
      vim.keymap.set('n', '<leader>E', '<cmd>NvimTreeFocus<CR>', { desc = 'Focus NvimTree' })
      vim.keymap.set('n', '<leader>ff', '<cmd>NvimTreeFindFile<CR>', { desc = 'Find current file in NvimTree' })
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
})
