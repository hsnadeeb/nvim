--------------------------------------------------
-- Neovim Configuration Entry Point
--------------------------------------------------
-- This file bootstraps the entire configuration and loads all modules
-- in the correct order. The config is organized in a modular way with
-- each aspect of the editor handled by a dedicated file.

-- Set leader key before anything else to avoid plugin initialization issues
-- The space key is used as the leader key for easy access to commands
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable optional language providers we don't use to keep :checkhealth clean
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Make sure external tools are discoverable even if Neovim is launched from a GUI
-- (Mason needs real executables on PATH, not shell functions from .zshrc).
local function prepend_path(dir)
	if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then
		local path = vim.env.PATH or ""
		if not string.find(path, dir, 1, true) then
			vim.env.PATH = dir .. ":" .. path
		end
	end
end

prepend_path("/opt/homebrew/bin")
prepend_path("/opt/homebrew/sbin")
prepend_path("/usr/local/bin")
prepend_path(vim.fn.expand("~/.local/bin"))
prepend_path(vim.fn.expand("~/go/bin"))

-- Load theme persistence early and cache the saved theme
local theme_persistence = require("theme_persistence")
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
local function setup_themes()
	local ok, themes = pcall(require, "plugins.themes")
	if ok and themes and themes.setup then
		return themes.setup()
	end
	vim.notify("Could not load themes module", vim.log.levels.ERROR)
	vim.cmd.colorscheme("default")
end

-- Set up theme initialization after all plugins are loaded
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = setup_themes,
	once = true,
	desc = "Initialize theme system",
})

vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	command = "wincmd =",
})
