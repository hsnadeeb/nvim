local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

function M.setup()
  local status_ok, conform = pcall(require, "conform")
  if not status_ok then
    vim.notify("conform.nvim not found!", vim.log.levels.ERROR)
    return
  end

  -- Configure conform
  conform.setup({
    formatters_by_ft = {
      -- Web development
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      
      -- Go
      go = { "goimports", "gofmt" },
      
      -- Lua
      lua = { "stylua" },
      
      -- Python
      python = { "isort", "black" },
    },
    
    formatters = {
      prettier = {
        command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
        args = { "--stdin-filepath", "$FILENAME" },
      },
      goimports = {
        command = vim.fn.stdpath("data") .. "/mason/bin/goimports",
      },
      stylua = {
        command = vim.fn.stdpath("data") .. "/mason/bin/stylua",
      },
      black = {
        command = vim.fn.stdpath("data") .. "/mason/bin/black",
        args = { "--quiet", "-" },
      },
      isort = {
        command = vim.fn.stdpath("data") .. "/mason/bin/isort",
        args = { "--profile", "black", "-" },
      },
    },
    
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    
    format_after_save = {
      lsp_fallback = true,
    },
  })

  -- Set up keybindings for manual formatting
  map("n", "<leader>fm", function()
    conform.format({ 
      timeout_ms = 1000, 
      lsp_fallback = true,
      async = false 
    })
  end, { desc = "Format document" })
  
  -- Format visual selection
  map("v", "<leader>fm", function()
    conform.format({ 
      timeout_ms = 1000, 
      lsp_fallback = true,
      async = false 
    })
  end, { desc = "Format selection" })

  -- Mappings are now centrally managed in which-key.lua
end

return M