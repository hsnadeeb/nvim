return function()
  local wk = require("which-key")

  wk.setup({
    preset = "modern",
    delay = 500,
    expand = 1,
    notify = true,
    win = { border = "rounded", padding = { 1, 2 }, title = true, title_pos = "center", zindex = 1000 },
    layout = { width = { min = 20, max = 50 }, spacing = 3, align = "left" },
    icons = { breadcrumb = "»", separator = "➜", group = "+", ellipsis = "…" },
  })

  wk.register({
    -- File ops
    ["<leader>f"] = { name = "+find" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>l"] = { name = "+lsp" },
    ["<leader>x"] = { name = "+diagnostics" },
    ["<leader>t"] = { name = "+terminal" },
    ["<leader>s"] = { name = "+session" },
    ["<leader>j"] = { name = "+java" },
    ["<leader>b"] = { name = "+buffer" },
    ["<leader>w"] = { name = "+write/quit" },
    ["<leader>d"] = { name = "+debug" },

    -- Theme
    ["<leader>T"] = { name = "+theme" },

    -- Grep/Search
    ["<leader>r"] = { name = "+search/replace" },

    -- Refactoring
    ["<leader>re"] = { name = "+refactor extract" },

    -- Quick keys
    ["<leader>n"] = { require('nvim-tree.api').tree.toggle, "Toggle NvimTree" },
    ["<leader>e"] = { function()
      local api = require('nvim-tree.api')
      if vim.bo.filetype == 'NvimTree' then vim.cmd('wincmd p') else api.tree.focus() end
    end, "Toggle focus NvimTree/editor" },

    -- Diagnostics
    ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },

    -- LSP navigation
    ["gd"] = { vim.lsp.buf.definition, "Go to Definition" },
    ["gD"] = { vim.lsp.buf.declaration, "Go to Declaration" },
    ["gi"] = { vim.lsp.buf.implementation, "Go to Implementation" },
    ["gR"] = { "<cmd>TroubleToggle lsp_references<cr>", "References (Trouble)" },
    ["gT"] = { "<cmd>TroubleToggle lsp_type_definitions<cr>", "Type Definitions (Trouble)" },
    ["gI"] = { "<cmd>TroubleToggle lsp_implementations<cr>", "Implementations (Trouble)" },
  })
end
