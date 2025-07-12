-- Neovim Configuration Entry Point
-- Bootstraps lazy.nvim and loads all configuration modules in the correct order.
-- -- local vim = require "vim"-- Set leader keys before plugins to avoid initialization issues
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load theme persistence early and cache the saved theme
local theme_persistence = require('theme_persistence')
vim.g.saved_theme = theme_persistence.load_theme() or 'everforest'

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim...", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  vim.notify("lazy.nvim installed successfully!", vim.log.levels.INFO)
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration modules
require("settings") -- Editor behavior, UI settings, and options
require("lazy").setup("plugins") -- Plugin management via lazy.nvim

-- Initialize theme system after plugins are loaded
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local ok, theme_manager = pcall(require, 'theme_manager')
    if ok and theme_manager and type(theme_manager.setup) == 'function' then
      theme_manager.setup()
    else
      vim.notify('Could not load theme manager, applying saved theme: ' .. vim.g.saved_theme, vim.log.levels.WARN)
      pcall(vim.cmd.colorscheme, vim.g.saved_theme)
    end
  end,
  once = true,
  desc = 'Initialize theme system'
})