-- Configuration for which-key.nvim
-- This module provides enhanced key binding documentation and navigation

local M = {}

function M.setup()
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    vim.notify("which-key.nvim not found!", vim.log.levels.ERROR)
    return
  end

  which_key.setup({
    preset = "modern",
    delay = 500,
    notify = true,
    replace = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
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
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      ellipsis = "…",
    },
  })

  -- Key mappings registration
  which_key.register({
    -- Find/Format group
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
      m = { function() require("conform").format() end, "Format document" },
    },

    -- Buffer group
    ["<leader>b"] = {
      name = "+buffer",
      n = { "<cmd>BufferNext<cr>", "Next Buffer" },
      p = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
      d = { "<cmd>BufferClose<cr>", "Delete Buffer" },
    },

    -- Git group
    ["<leader>g"] = {
      name = "+git",
      c = { "<cmd>Telescope git_commits<cr>", "Commits" },
      bc = { "<cmd>Telescope git_bcommits<cr>", "Buffer Commits" },
      B = { "<cmd>Telescope git_branches<cr>", "Branches" },
      s = { "<cmd>Telescope git_status<cr>", "Status" },
      j = { function() require("gitsigns").next_hunk() end, "Next Hunk" },
      k = { function() require("gitsigns").prev_hunk() end, "Prev Hunk" },
      S = { function() require("gitsigns").stage_buffer() end, "Stage Buffer" },
      p = { function() require("gitsigns").preview_hunk() end, "Preview Hunk" },
      d = { function() require("gitsigns").diffthis() end, "Diff This" },
      bl = { function() require("gitsigns").blame_line({ full = true }) end, "Blame Line" },
      r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
      R = { "<cmd>Gitsigns reset_buffer<CR>", "Reset Buffer" },
      u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk" },
    },

    -- LSP group
    ["<leader>l"] = {
      name = "+lsp",
      a = { function() vim.lsp.buf.code_action() end, "Code Action" },
      d = { function() vim.diagnostic.open_float() end, "Line Diagnostics" },
      D = { function() vim.lsp.buf.declaration() end, "Go to Declaration" },
      f = { function() vim.lsp.buf.format({ async = true }) end, "Format Buffer" },
      h = { function() vim.lsp.buf.hover() end, "Hover Documentation" },
      i = { function() vim.lsp.buf.implementation() end, "Go to Implementation" },
      n = { function() vim.lsp.buf.rename() end, "Rename Symbol" },
      r = { function() vim.lsp.buf.references() end, "Show References" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
      t = { function() vim.lsp.buf.type_definition() end, "Go to Type Definition" },
      k = { function() vim.lsp.buf.signature_help() end, "Signature Help" },
      w = { name = "+workspace",
        a = { function() vim.lsp.buf.add_workspace_folder() end, "Add Workspace Folder" },
        r = { function() vim.lsp.buf.remove_workspace_folder() end, "Remove Workspace Folder" },
        l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders" },
      },
      q = { function() vim.diagnostic.setloclist() end, "Diagnostics to Location List" },
      p = { function() vim.diagnostic.goto_prev() end, "Previous Diagnostic" },
      n = { function() vim.diagnostic.goto_next() end, "Next Diagnostic" },
    },

    -- Terminal group
    ["<leader>t"] = {
      name = "+terminal",
      t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
      f = { "<cmd>ToggleTerm direction=float<cr>", "Float Terminal" },
      v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Terminal" },
      z = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Terminal" },
    },

    -- Diagnostics / Trouble
    ["<leader>x"] = {
      name = "+diagnostics",
      x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
      w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
      d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
      l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
      q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
      e = { "<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.ERROR<cr>", "Show Errors" },
      W = { "<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.WARN<cr>", "Show Warnings" },
    },

    -- Theme toggling
    ["<leader>th"] = {
      name = "+theme",
      n = { function() require("plugins.themes").next_theme() end, "Next Theme" },
      p = { function() require("plugins.themes").prev_theme() end, "Previous Theme" },
    },

    -- Write/quit
    ["<leader>w"] = {
      name = "+write/quit",
      s = { "<cmd>w<cr>", "Save" },
      q = { "<cmd>wq<cr>", "Save and Quit" },
    },

    -- Other simple mappings
    ["<leader>q"] = { "<cmd>q<cr>", "Quit" },
    ["<leader>Q"] = { "<cmd>q!<cr>", "Force Quit" },
    ["<leader>h"] = { "<cmd>nohlsearch<cr>", "Clear Highlights" },
    ["<leader>e"] = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
    ["<leader>E"] = { "<cmd>NvimTreeFocus<cr>", "Focus NvimTree" },

    -- LSP navigation (non-leader for consistency with standard Vim)
    ["gd"] = { function() vim.lsp.buf.definition() end, "Go to Definition" },
    ["gD"] = { function() vim.lsp.buf.declaration() end, "Go to Declaration" },
    ["gi"] = { function() vim.lsp.buf.implementation() end, "Go to Implementation" },
    ["gr"] = { "<cmd>TroubleToggle lsp_references<cr>", "References (Trouble)" },
    ["gt"] = { function() vim.lsp.buf.type_definition() end, "Go to Type Definition" },
    ["gR"] = { "<cmd>TroubleToggle lsp_references<cr>", "References (Trouble)" },

    -- Diagnostics navigation
    ["[d"] = { function() vim.diagnostic.goto_prev() end, "Previous Diagnostic" },
    ["]d"] = { function() vim.diagnostic.goto_next() end, "Next Diagnostic" },
  }, { mode = "n" })

  -- Visual mode mappings
  which_key.register({
    ["<leader>c"] = {
      name = "+Comment",
      c = { "<Plug>(comment_toggle_linewise_visual)", "Toggle line comment" },
      b = { "<Plug>(comment_toggle_blockwise_visual)", "Toggle block comment" },
    },
  }, { mode = "v" })
end

return M