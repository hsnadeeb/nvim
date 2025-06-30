-- Neovim Configuration Entry Point
-- Bootstraps the configuration and loads modules in an optimized order

-- Set leader keys early
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
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
  vim.notify("lazy.nvim installed!", vim.log.levels.INFO)
end
vim.opt.rtp:prepend(lazypath)

-- Defer non-essential module loading
vim.defer_fn(function()
  -- Load utility functions
  require("utils")

  -- Load basic settings
  require("settings")

  -- Load plugins (lazy.nvim)
  require("plugins")

  -- Load LSP configurations
  require("lsp")

  -- Load keybindings (last to override plugin defaults)
  require("keybindings")

  -- Load theme persistence after plugins
  local theme_persistence = require("theme_persistence")
  local saved_theme = theme_persistence.load_theme()
  vim.g.saved_theme = saved_theme
end, 50) -- Defer by 50ms