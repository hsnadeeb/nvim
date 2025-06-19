-- Configuration for which-key.nvim
-- This module provides enhanced key binding documentation and navigation

local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

function M.setup()
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    vim.notify("which-key.nvim not found!", vim.log.levels.ERROR)
    return
  end

  -- Configure which-key with new spec
  which_key.setup({
    preset = "modern",
    delay = 500,
    expand = 1,
    notify = true,
    replace = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
    spec = {},
    win = {
      border = "rounded",
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      zindex = 1000,
    },
    layout = {
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    sort = { "local", "order", "group", "alphanum", "mod" },
    expand = 0,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      ellipsis = "…",
      mappings = true,
      rules = false,
      colors = true,
      keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        ScrollWheelDown = "󱕐 ",
        ScrollWheelUp = "󱕑 ",
        NL = "󰌑 ",
        BS = "󰁮",
        Space = "󱁐 ",
        Tab = "󰌒 ",
        F1 = "󱊫",
        F2 = "󱊬",
        F3 = "󱊭",
        F4 = "󱊮",
        F5 = "󱊯",
        F6 = "󱊰",
        F7 = "󱊱",
        F8 = "󱊲",
        F9 = "󱊳",
        F10 = "󱊴",
        F11 = "󱊵",
        F12 = "󱊶",
      },
    },
  })

  -- Add key mappings with new spec
  which_key.add({
    -- File operations (consolidating find and format into one group)
    { "<leader>f", group = "find/format" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
    { "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
    { "<leader>fm", function() require("conform").format() end, desc = "Format document" },

    -- Buffer operations
    { "<leader>b", group = "buffer" },
    { "<leader>bd", "<cmd>BufferClose<cr>", desc = "Delete Buffer" },
    { "<leader>bc", "<cmd>BufferClose<cr>", desc = "Close Current Buffer" },
    { "<leader>bn", "<cmd>BufferNext<cr>", desc = "Next Buffer" },
    { "<leader>bp", "<cmd>BufferPrevious<cr>", desc = "Previous Buffer" },

    -- Git operations
    { "<leader>g", group = "git" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
    { "<leader>gbc", "<cmd>Telescope git_bcommits<cr>", desc = "Buffer Commits" },
    { "<leader>gbr", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
    { "<leader>gj", function() require("gitsigns").next_hunk() end, desc = "Next Hunk" },
    { "<leader>gk", function() require("gitsigns").prev_hunk() end, desc = "Prev Hunk" },
    { "<leader>gS", function() require("gitsigns").stage_buffer() end, desc = "Stage Buffer" },
    { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
    { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Diff This" },
    { "<leader>gB", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Blame" },

    -- LSP operations
    { "<leader>l", group = "lsp" },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
    { "<leader>ld", vim.lsp.buf.definition, desc = "Definition" },
    { "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration" },
    { "<leader>li", vim.lsp.buf.implementation, desc = "Implementation" },
    { "<leader>lr", vim.lsp.buf.references, desc = "References" },
    { "<leader>lR", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>lf", vim.lsp.buf.format, desc = "Format" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
    
    -- LSP Format (duplicate under f for consistency)
    { "<leader>fm", function() require("conform").format() end, desc = "Format document" },

    -- Terminal operations
    { "<leader>t", group = "terminal/theme" },
    { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical Terminal" },
    { "<leader>tz", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" }, -- Changed from 'th' to 'tz' to avoid conflict

    -- Trouble diagnostics
    { "<leader>x", group = "diagnostics" },
    { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },

    -- NvimTree
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    { "<leader>E", "<cmd>NvimTreeFocus<cr>", desc = "Focus NvimTree" },

    -- Theme toggling (now under the shared terminal/theme group)
    { "<leader>th", group = "theme" },
    { "<leader>thn", function() require("plugins.themes").next_theme() end, desc = "Next Theme" },

    -- Quick save and quit
    { "<leader>w", group = "write/quit" },
    { "<leader>ws", "<cmd>w<cr>", desc = "Save" },
    { "<leader>wq", "<cmd>wq<cr>", desc = "Save and Quit" },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>Q", "<cmd>q!<cr>", desc = "Force Quit" },
    { "<leader>h", "<cmd>nohlsearch<cr>", desc = "Clear Highlights" },

    -- LSP diagnostics navigation
    { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
    { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
    { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },

    -- Go to LSP locations (restructured to avoid 'gr' overlap)
    { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
    { "gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
    { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "References (Trouble)" },
    
    -- LSP References (separate from other 'g' commands to avoid overlap warning)
    { "gr", vim.lsp.buf.references, desc = "References" },
  })
end

return M
