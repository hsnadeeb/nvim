local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

function M.setup()
  -- Defer setup to reduce startup time
  vim.defer_fn(function()
    local status_ok, which_key = pcall(require, "which-key")
    if not status_ok then
      vim.notify("which-key.nvim not found!", vim.log.levels.ERROR)
      return
    end

    -- Simplified error handling for keymap registration
    local function safe_register(keys, opts)
      pcall(which_key.register, keys, opts)
    end

    which_key.setup({
      preset = "modern",
      delay = 500,
      win = { border = "rounded", padding = { 1, 2 }, title = true, title_pos = "center" },
      layout = { width = { min = 20, max = 50 }, spacing = 3, align = "left" },
      keys = { scroll_down = "<c-d>", scroll_up = "<c-u>" },
      icons = { breadcrumb = "»", separator = "➜", group = "+" },
    })

    -- Register keymaps (consolidated, duplicates removed)
    safe_register({
      -- Autosave
      ["<leader>a"] = { name = "+autosave", a = { "<cmd>AutoSaveToggle<cr>", "Toggle AutoSave" } },

      -- Find/Format
      ["<leader>f"] = {
        name = "+find/format",
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
        m = { "<cmd>lua require('conform').format()<cr>", "Format document" },
      },

      -- Buffer
      ["<leader>b"] = {
        name = "+buffer",
        d = { "<cmd>BufferClose<cr>", "Delete Buffer" },
        n = { "<cmd>BufferNext<cr>", "Next Buffer" },
        p = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
      },

      -- Git
      ["<leader>g"] = {
        name = "+git",
        c = { "<cmd>Telescope git_commits<cr>", "Commits" },
        b = { "<cmd>Telescope git_bcommits<cr>", "Buffer Commits" },
        B = { "<cmd>Telescope git_branches<cr>", "Branches" },
        s = { "<cmd>Telescope git_status<cr>", "Status" },
        j = { "<cmd>lua require('gitsigns').next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require('gitsigns').prev_hunk()<cr>", "Prev Hunk" },
        S = { "<cmd>lua require('gitsigns').stage_buffer()<cr>", "Stage Buffer" },
        p = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", "Preview Hunk" },
        d = { "<cmd>lua require('gitsigns').diffthis()<cr>", "Diff This" },
        l = { "<cmd>lua require('gitsigns').blame_line({full=true})<cr>", "Blame Line" },
      },

      -- LSP
      ["<leader>l"] = {
        name = "+lsp",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Diagnostics (Line)" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
        r = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
        n = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
        h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
      },

      -- Terminal
      ["<leader>t"] = {
        name = "+terminal",
        ["`"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float Terminal" },
        v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Terminal" },
        t = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Terminal" },
      },

      -- Diagnostics
      ["<leader>x"] = {
        name = "+diagnostics",
        x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
        w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
        l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
      },

      -- Theme
      ["<leader>th"] = {
        name = "+theme",
        n = { "<cmd>NextTheme<cr>", "Next Theme" },
        p = { "<cmd>lua require('plugins.themes').previous_theme()<cr>", "Previous Theme" },
      },

      -- Write/Quit
      ["<leader>w"] = { name = "+write/quit", s = { "<cmd>w<cr>", "Save" }, q = { "<cmd>wq<cr>", "Save and Quit" } },

      -- Simple Mappings
      ["<leader>q"] = { "<cmd>if &ft != 'NvimTree' | q | endif<cr>", "Quit" },
      ["<leader>Q"] = { "<cmd>if &ft != 'NvimTree' | q! | endif<cr>", "Force Quit" },
      ["<leader>h"] = { "<cmd>nohlsearch<cr>", "Clear Highlights" },

      -- Diagnostics Navigation
      ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
      ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },

      -- LSP Navigation
      ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration" },
      ["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation" },
      ["gR"] = { "<cmd>TroubleToggle lsp_references<cr>", "References (Trouble)" },
    })
  end, 50) -- Defer setup by 50ms
end

return M