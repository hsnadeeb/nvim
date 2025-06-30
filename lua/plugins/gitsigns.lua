local M = {}

function M.setup()
  -- Defer setup to reduce startup time
  vim.defer_fn(function()
    local status_ok, gitsigns = pcall(require, "gitsigns")
    if not status_ok then
      vim.notify("gitsigns.nvim not found!", vim.log.levels.ERROR)
      return
    end

    -- Configure gitsigns with streamlined settings
    gitsigns.setup({
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
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
      current_line_blame = false,
      sign_priority = 6,
      update_debounce = 100,
      preview_config = { border = "rounded", style = "minimal", relative = "cursor", row = 0, col = 1 },
    })
  end, 50) -- Defer setup by 50ms
end

return M