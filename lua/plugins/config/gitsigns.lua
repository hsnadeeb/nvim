return function()
  local utils = require("config.utils")

  require("gitsigns").setup({
    signs = {
      add = { text = "+" }, change = { text = "~" }, delete = { text = "_" },
      topdelete = { text = "‾" }, changedelete = { text = "~_" }, untracked = { text = "┆" },
    },
    signcolumn = true, numhl = false, linehl = false, word_diff = false,
    watch_gitdir = { interval = 1000, follow_files = true },
    attach_to_untracked = true,
    current_line_blame = false,
    sign_priority = 6,
    update_debounce = 100,
    preview_config = { border = "rounded", style = "minimal", relative = "cursor", row = 0, col = 1 },
  })

  local gs = require("gitsigns")
  utils.map("n", "<leader>gj", gs.next_hunk, { desc = "Next Git Hunk" })
  utils.map("n", "<leader>gk", gs.prev_hunk, { desc = "Prev Git Hunk" })
  utils.map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
  utils.map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
  utils.map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
  utils.map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
  utils.map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
  utils.map("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })
  utils.map("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Git Diff (Staged)" })
  utils.map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
  utils.map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
end
