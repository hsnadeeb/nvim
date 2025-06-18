-- Set leader key before anything else to avoid which-key issues
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
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

-- Load all configuration files in correct order
require("settings")
require("plugins")  -- Loads which-key and other plugins
require("lsp")
require("trouble").setup()  -- Enhanced diagnostics UI
require("keybindings")

-- All keybindings now handled in keybindings.lua and plugins.lua
