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

function M.setup_gitsigns()
  local gitsigns = require('gitsigns')
  gitsigns.setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
    },
  })
  -- Keymaps for Gitsigns
  map('n', '<leader>gj', gitsigns.next_hunk, { desc = 'Next Git Hunk' })
  map('n', '<leader>gk', gitsigns.prev_hunk, { desc = 'Previous Git Hunk' })

  map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage Git Hunk' })
  map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
  map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })

  map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset Git Hunk' })
  map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
  map('n', '<leader>gU', gitsigns.reset_buffer_index, { desc = 'Reset Buffer Index' })

  map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Git Diff' })
  map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = 'Git Diff (Staged)' })

  map('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end, { desc = 'Git Blame Line' })
  map('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'Toggle Git Blame' })

  map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview Git Hunk' })
  map('n', '<leader>gP', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })

  map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = 'Toggle Git Deleted' })
  map('n', '<leader>gtl', gitsigns.toggle_linehl, { desc = 'Toggle Git Line Highlight' })
  map('n', '<leader>gtw', gitsigns.toggle_word_diff, { desc = 'Toggle Git Word Diff' })
  map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle Git Blame' })
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