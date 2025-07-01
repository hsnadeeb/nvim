--------------------------------------------------
-- Neovim Configuration Entry Point
--------------------------------------------------
-- This file bootstraps the entire configuration and loads all modules
-- in the correct order. The config is organized in a modular way with
-- each aspect of the editor handled by a dedicated file.

-- Set leader key before anything else to avoid plugin initialization issues
-- The space key is used as the leader key for easy access to commands
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load theme persistence early and cache the saved theme
local theme_persistence = require('theme_persistence')
vim.g.saved_theme = theme_persistence.load_theme()

--------------------------------------------------
-- Package Manager: lazy.nvim
--------------------------------------------------
-- Bootstrap lazy.nvim if it's not already installed
-- This auto-installs the plugin manager on first run
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim - the package manager...", vim.log.levels.INFO)
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

--------------------------------------------------
-- Load Configuration Modules
--------------------------------------------------
-- Load utility functions first
require("utils") -- Common utility functions and helpers

-- Load basic settings before plugins
require("settings") -- Editor behavior, UI settings, and options

-- Load plugins (themes will be loaded here via lazy loading)
require("plugins") -- Plugin management via lazy.nvim

-- Load development tools
require("lsp") -- Language server protocols and completions

-- Load keybindings last to override any plugin defaults
require("keybindings") -- Global and plugin-specific key mappings

-- Initialize theme system after all plugins are loaded
-- This ensures all theme plugins are available before setup
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy", -- Triggered after all lazy-loaded plugins
  callback = function()
    -- Try different possible locations for the themes module
    local themes
    local theme_paths = {
      "plugins.themes",  -- If themes.lua is in plugins/ directory
      "themes",          -- If themes.lua is in lua/ root
      "config.themes"    -- Alternative location
    }
    
    for _, path in ipairs(theme_paths) do
      local ok, module = pcall(require, path)
      if ok then
        themes = module
        break
      end
    end
    
    if themes and themes.setup then
      themes.setup()
    else
      vim.notify("Could not load themes module", vim.log.levels.WARN)
    end
  end,
  once = true -- Only run once
})