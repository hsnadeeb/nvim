return function()
  require("auto-session").setup({
    log_level = "error",
    auto_restore = false,  -- Disabled: prevents crashes from corrupted sessions
    auto_save = false,     -- Disabled: use manual session management
    auto_create = false,   -- Disabled: use manual session management
    suppressed_dirs = { "~/", "/", "~/Downloads", "/tmp" },
    use_git_branch = false,
    bypass_save_filetypes = { "alpha", "dashboard", "NvimTree", "gitcommit", "gitrebase", "nofile" },
    pre_save_cmds = {
      function()
        pcall(vim.cmd, "NvimTreeClose")
        pcall(vim.cmd, "TroubleClose")
        pcall(vim.cmd, "cclose")
      end,
    },
    -- Prevent session restoration issues
    post_restore_cmds = {
      function()
        vim.notify("Session restored successfully", vim.log.levels.INFO)
      end,
    },
  })

  local utils = require("config.utils")
  utils.map("n", "<leader>ss", "<cmd>Autosession save<CR>", { desc = "Save session" })
  utils.map("n", "<leader>sr", "<cmd>Autosession restore<CR>", { desc = "Restore session" })
  utils.map("n", "<leader>sd", "<cmd>Autosession delete<CR>", { desc = "Delete session" })
end
