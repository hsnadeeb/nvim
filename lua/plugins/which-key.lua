local M = {}

-- Load utility functions
local utils = require("utils")

function M.setup()
  local status_ok, wk = pcall(require, "which-key")
  if not status_ok then
    vim.notify("which-key not found!", vim.log.levels.ERROR)
    return
  end

  -- Configure which-key
  wk.setup({
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    win = {
      border = "rounded",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 2, 2, 2, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    filter = function() return true end,
    show_help = true,
    show_keys = true,
    triggers = "auto",
  })

  -- Register common groups
  wk.register({
    ["<leader>d"] = { name = "debug" },
    ["<leader>f"] = { name = "find" },
    ["<leader>g"] = { name = "git" },
    ["<leader>x"] = { name = "trouble" },
    ["<leader>th"] = { name = "theme" },
    ["<leader>t"] = { name = "terminal/toggle" },
    ["<leader>w"] = { name = "window/write" },
  })

  -- Register theme mappings
  local themes_module = require("plugins.themes")
  wk.register({
    ["<leader>thn"] = { themes_module.next_theme, desc = "Next theme" },
  })
  
  -- Make sure space key shows which-key
  utils.map('n', '<space>', ':WhichKey<CR>', { silent = true, noremap = true })
end

return M