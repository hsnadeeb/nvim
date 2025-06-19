local M = {}

local map = vim.keymap.set -- Helper for setting keymaps

function M.setup_which_key()
  local wk = require('which-key')
  local themes_module = require("plugins.themes") -- Access the themes module

  -- Configure which-key with updated options
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
      winblend = 0,
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
  })

  -- Register theme groups and commands in the correct format
  wk.register({
    ["<leader>th"] = { name = "theme" },
  })
  
  wk.register({
    ["<leader>thn"] = { themes_module.next_theme, desc = "Next theme" },
  })
end


function M.setup_conform()
  require("conform").setup({
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      go = { "goimports" },
    },
    formatters = {
      prettier = {
        command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
      },
      goimports = {
        command = vim.fn.stdpath("data") .. "/mason/bin/goimports",
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end



function M.setup_lualine()
  require("lualine").setup({
    options = { theme = "auto" },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

return M