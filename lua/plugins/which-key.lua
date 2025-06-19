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

  -- Configure which-key
  which_key.setup({
    plugins = {
      marks = true,       -- shows a list of your marks on ' and `
      registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true,    -- adds help for operators like d, y, ...
        motions = true,      -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true,      -- default bindings on <c-w>
        nav = true,          -- misc bindings to work with windows
        z = true,            -- bindings for folds, spelling and others prefixed with z
        g = true,            -- bindings for prefixed with g
      },
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and its label
      group = "+",      -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
    window = {
      border = "rounded",      -- none, single, double, shadow
      position = "bottom",     -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0,            -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3,                    -- spacing between columns
      align = "left",                 -- align columns left, center or right
    },
    ignore_missing = false,   -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true,         -- show help message on the command line when the popup is visible
    show_keys = true,         -- show the currently pressed key and its label as a message in the command line
    triggers = "auto",        -- automatically setup triggers
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      i = { "j", "k" },
      v = { "j", "k" },
    },
  })

  -- Register groups and mappings
  which_key.register({
    ["<leader>"] = {
      -- File operations
      f = {
        name = "find/file",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
        d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
        i = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
        m = { function() require("conform").format() end, "Format document" },
      },

      -- Buffer operations
      b = {
        name = "buffer",
        d = { "<cmd>BufferClose<cr>", "Delete Buffer" },
        n = { "<cmd>BufferNext<cr>", "Next Buffer" },
        p = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
      },

      -- Git operations
      g = {
        name = "git",
        c = { "<cmd>Telescope git_commits<cr>", "Commits" },
        b = { "<cmd>Telescope git_branches<cr>", "Branches" },
        s = { "<cmd>Telescope git_status<cr>", "Status" },
        j = { function() require("gitsigns").next_hunk() end, "Next Hunk" },
        k = { function() require("gitsigns").prev_hunk() end, "Prev Hunk" },
        S = { function() require("gitsigns").stage_buffer() end, "Stage Buffer" },
        p = { function() require("gitsigns").preview_hunk() end, "Preview Hunk" },
        d = { function() require("gitsigns").diffthis() end, "Diff This" },
        B = { function() require("gitsigns").toggle_current_line_blame() end, "Toggle Blame" },
      },

      -- LSP operations
      l = {
        name = "lsp",
        a = { vim.lsp.buf.code_action, "Code Action" },
        d = { vim.lsp.buf.definition, "Definition" },
        D = { vim.lsp.buf.declaration, "Declaration" },
        i = { vim.lsp.buf.implementation, "Implementation" },
        r = { vim.lsp.buf.references, "References" },
        R = { vim.lsp.buf.rename, "Rename" },
        f = { vim.lsp.buf.format, "Format" },
        h = { vim.lsp.buf.hover, "Hover" },
      },

      -- Terminal operations
      t = {
        name = "terminal",
        t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float Terminal" },
        h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Terminal" },
        v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Terminal" },
      },

      -- Trouble diagnostics
      x = {
        name = "diagnostics",
        x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
        w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
        l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
      },

      -- NvimTree
      e = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
      E = { "<cmd>NvimTreeFocus<cr>", "Focus NvimTree" },

      -- Theme toggling
      th = {
        name = "theme",
        n = { function() require("plugins.themes").next_theme() end, "Next Theme" },
      },

      -- Quick save and quit
      w = { "<cmd>w<cr>", "Save" },
      q = { "<cmd>q<cr>", "Quit" },
      Q = { "<cmd>q!<cr>", "Force Quit" },
      W = { "<cmd>wq<cr>", "Save and Quit" },
      h = { "<cmd>nohlsearch<cr>", "Clear Highlights" },
    },

    -- LSP diagnostics navigation
    ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
    ["gl"] = { vim.diagnostic.open_float, "Line Diagnostics" },

    -- Go to LSP locations
    ["gd"] = { vim.lsp.buf.definition, "Go to Definition" },
    ["gD"] = { vim.lsp.buf.declaration, "Go to Declaration" },
    ["gi"] = { vim.lsp.buf.implementation, "Go to Implementation" },
    ["gr"] = { vim.lsp.buf.references, "Go to References" },
    ["gR"] = { "<cmd>TroubleToggle lsp_references<cr>", "References (Trouble)" },
  })
end

return M