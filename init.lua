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
-- First load utility functions used throughout the config
require("utils")         -- Common utility functions and helpers

-- Then load all other configuration files in the correct order:
-- 1. Basic settings (must be loaded before plugins)
require("settings")      -- Editor behavior, UI settings, and options

-- 2. Plugin definitions and setup
require("plugins")       -- Plugin management via lazy.nvim

-- 3. Development tools and IDE features
require("lsp")           -- Language server protocols and completions

-- 4. Key bindings (must be loaded last to override any plugin defaults)
require("keybindings")   -- Global and plugin-specific key mappings

-- Note: Many plugin-specific keybindings are defined in their respective
-- configuration files under lua/plugins/*.lua to keep related settings together
