-- local vim = require "vim"
return {
  repo = "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~_" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    })

    -- Keybindings (only those not defined in which-key.lua)
    local gitsigns = require("gitsigns")
    vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset Git Hunk' })
    vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
    vim.keymap.set('n', '<leader>gU', gitsigns.reset_buffer_index, { desc = 'Reset Buffer Index' })
    vim.keymap.set('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = 'Git Diff (Staged)' })
    vim.keymap.set('n', '<leader>gP', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
    vim.keymap.set('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = 'Toggle Git Deleted' })
    vim.keymap.set('n', '<leader>gtl', gitsigns.toggle_linehl, { desc = 'Toggle Git Line Highlight' })
    vim.keymap.set('n', '<leader>gtw', gitsigns.toggle_word_diff, { desc = 'Toggle Git Word Diff' })
    vim.keymap.set('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle Git Blame' })
  end,
}