return function()
  require("trouble").setup({
    position = "bottom", height = 12, width = 60, padding = true, indent_lines = true,
    auto_preview = true, auto_fold = false, auto_open = false, auto_close = false,
    auto_jump = { "lsp_definitions" },
    icons = true, mode = "workspace_diagnostics", fold_open = "", fold_closed = "", group = true,
    action_keys = {
      close = "q", cancel = "<esc>", refresh = "r", jump = { "<cr>", "<tab>" },
      open_split = { "<c-x>" }, open_vsplit = { "<c-v>" }, open_tab = { "<c-t>" },
      jump_close = { "o" }, toggle_mode = "m", toggle_preview = "P", hover = "K",
      preview = "p", close_folds = { "zM", "zm" }, open_folds = { "zR", "zr" },
      toggle_fold = { "zA", "za" }, previous = "k", next = "j", help = "?",
    },
    use_diagnostic_signs = false,
  })

  local utils = require("config.utils")
  local map = utils.map
  map("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle Trouble" })
  map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Workspace Diagnostics" })
  map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Document Diagnostics" })
  map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Quickfix List" })
end
