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
  
  -- Add error handling for buffer operations
  local function safe_register(keys, opts)
    local ok, err = pcall(function()
      which_key.register(keys, opts)
    end)
    if not ok then
      vim.notify_once("which-key: Failed to register keymap: " .. vim.inspect(err), vim.log.levels.WARN)
    end
  end

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
    },
  })

  -- Register the keymaps
  safe_register({
    -- Autosave toggle
    ["<leader>a"] = { 
      name = "+autosave",
      s = { function() 
        if _G.toggle_autosave then 
          _G.toggle_autosave() 
        else 
          vim.notify("AutoSave not loaded yet", vim.log.levels.WARN) 
        end 
      end, "Toggle AutoSave" },
    },

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
      d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
      i = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
      m = { function() require("conform").format() end, "Format document" },
    },

    -- Buffer group (also contains IntelliJ-like navigation)
    ["<leader>b"] = {
      name = "+buffer/navigation",
      d = { "<cmd>BufferClose<cr>", "Delete Buffer" },
      c = { "<cmd>BufferClose<cr>", "Close Current Buffer" },
      n = { "<cmd>BufferNext<cr>", "Next Buffer" },
      p = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
      -- IntelliJ-like navigation (Cmd+B equivalents) - LSP buffer-local
      b = { vim.lsp.buf.definition, "Go to Definition (Cmd+B)" },
      i = { vim.lsp.buf.implementation, "Go to Implementation (Cmd+Alt+B)" },
      t = { vim.lsp.buf.type_definition, "Go to Type Definition" },
      r = { vim.lsp.buf.references, "Find Usages (Alt+F7)" },
      s = { vim.lsp.buf.definition, "Go to Super Method" },
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
      -- Changed from 'bl' to 'l' to avoid conflict
      l = { function() require("gitsigns").blame_line({ full = true }) end, "Blame Line" },
      b = { name = "+buffer" },
    },

    -- LSP group
    ["<leader>l"] = {
      name = "+lsp",
      a = { vim.lsp.buf.code_action, "Code Action" },
      d = { vim.diagnostic.open_float, "Diagnostics (Line)" },
      D = { vim.lsp.buf.declaration, "Declaration" },
      i = { vim.lsp.buf.implementation, "Implementation" },
      r = { vim.lsp.buf.references, "References" },
      n = { vim.lsp.buf.rename, "Rename" },
      f = { vim.lsp.buf.format, "Format" },
      h = { vim.lsp.buf.hover, "Hover" },
    },

    -- Terminal group
    ["<leader>t"] = {
      name = "+terminal",
      ["`"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
      f = { "<cmd>ToggleTerm direction=float<cr>", "Float Terminal" },
      v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Terminal" },
      t = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Terminal" },
    },

    -- Java/Spring Boot (IntelliJ-like)
    ["<leader>j"] = {
      name = "+java",
      o = { "Organize imports" },
      v = { "Extract variable" },
      c = { "Extract constant" },
      m = { "Extract method" },
      t = { "Test class" },
      n = { "Test nearest method" },
      g = { "Generate code (Alt+Insert)" },
      u = { "Update project config" },
      p = { "Open project manager" },
      b = { "Build project" },
      r = { "Run Spring Boot app" },
    },

    -- Session management
    ["<leader>s"] = {
      name = "+session",
      s = { "<cmd>Autosession save<cr>", "Save session" },
      r = { "<cmd>Autosession restore<cr>", "Restore session" },
      d = { "<cmd>Autosession delete<cr>", "Delete session" },
      l = { "List sessions" },
    },

    -- Diagnostics / Trouble
    ["<leader>x"] = {
      name = "+diagnostics",
      x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
      w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
      d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
      l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
      q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
    },

    -- Theme toggling
    ["<leader>th"] = {
      name = "+theme",
      n = { function() require("plugins.themes").next() end, "Next Theme" },
      p = { function() require("plugins.themes").previous() end, "Previous Theme" },
      c = { function() require("plugins.themes").cycle() end, "Cycle Theme" },
    },

    -- Write/quit
    ["<leader>w"] = {
      name = "+write/quit",
      s = { "<cmd>w<cr>", "Save" },
      q = { "<cmd>wq<cr>", "Save and Quit" },
    },

    -- Other simple mappings with buffer checks
    ["<leader>q"] = { function()
      if vim.fn.bufname('') ~= 'NvimTree' then vim.cmd('q') end
    end, "Quit" },
    ["<leader>Q"] = { function()
      if vim.fn.bufname('') ~= 'NvimTree' then vim.cmd('q!') end
    end, "Force Quit" },
    ["<leader>n"] = { function()
      require('nvim-tree.api').tree.toggle()
    end, "Toggle NvimTree" },
    ["<leader>e"] = { function()
      local api = require('nvim-tree.api')
      if vim.bo.filetype == 'NvimTree' then
        vim.cmd('wincmd p')
      else
        api.tree.focus()
      end
    end, "Toggle focus between NvimTree and editor" },
    ["<leader>h"] = { function()
      require('plugins.nvim-tree').toggle_dotfiles()
    end, "Toggle dotfiles in NvimTree" },

    -- Diagnostics navigation
    ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },

    -- LSP location navigation
    ["gd"] = { vim.lsp.buf.definition, "Go to Definition" },
    ["gD"] = { vim.lsp.buf.declaration, "Go to Declaration" },
    ["gi"] = { vim.lsp.buf.implementation, "Go to Implementation" },
    ["gR"] = { "<cmd>TroubleToggle lsp_references<cr>", "References (Trouble)" },
  })
end

return M
