-- ============================================================================
-- Neovim Configuration Entry Point
-- ============================================================================
-- Modular structure: config/ | keymaps/ | plugins/ | lsp/

local g = vim.g
local opt = vim.opt

-- Set leader keys
g.mapleader = " "
g.maplocalleader = " "

-- Disable optional language providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Ensure PATH
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

-- Theme persistence
local theme_persistence = require("theme_persistence")
g.saved_theme = theme_persistence.load_theme()

-- Package Manager: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim...", vim.log.levels.INFO)
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
opt.rtp:prepend(lazypath)

-- Load modules
require("config.settings")
require("config.utils")
require("plugins")
require("lsp")
require("keymaps")

-- Theme setup after plugins
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local ok, themes = pcall(require, "plugins.config.themes")
    if ok and themes and themes.setup then
      local setup_ok = pcall(themes.setup)
      if not setup_ok then
        -- If theme setup fails, fall back to default
        pcall(vim.cmd.colorscheme, "default")
      end
    else
      pcall(vim.cmd.colorscheme, "default")
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
})

-- Handle opening nvim with a directory argument
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argv = vim.fn.argv()
    if #argv > 0 and vim.fn.isdirectory(argv[1]) == 1 then
      -- Open nvim-tree when starting with a directory
      local ok, api = pcall(require, "nvim-tree.api")
      if ok then
        vim.cmd("enew")  -- Create empty buffer first
        api.tree.open({ path = argv[1] })
      end
    end
  end,
})
