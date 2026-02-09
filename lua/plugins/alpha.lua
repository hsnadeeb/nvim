-- ============================================================================
-- Alpha (Dashboard) Configuration
-- ============================================================================

local M = {}

function M.setup()
  local alpha = require("alpha")
  local dashboard = require("alpha.themes.dashboard")

  dashboard.section.header.val = {
    "",
    "░▒▓███████▓▒░ ░▒▓█▓▒░ ░▒▓█▓▒░ ░▒▓██████▓▒░░   ▒▓████████▓▒░ ▒▓█▓▒░ ",
    " ░▒▓█▓▒░      ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░       ░▒▓█▓▒░  ▒▓█▓▒░ ",
    " ░▒▓█▓▒░      ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░     ░▒▓██▓▒░   ▒▓█▓▒░ ",
    "  ░▒▓██████▓▒ ░░▒▓████████▓▒░ ░▒▓████████▓▒░    ░▒▓██▓▒░    ▒▓█▓▒░ ",
    "        ░▒▓█▓ ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓██▓▒░      ▒▓█▓▒░ ",
    "        ░▒▓█▓ ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░                 ",
    "░▒▓███████▓▒░ ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░ ▓████████▓▒░   ▒▓█▓▒░ ",
    "",
  }


-- ███████╗██╗  ██╗ █████╗ ███████╗██╗
-- ██╔════╝██║  ██║██╔══██╗╚══███╔╝██║
-- ███████╗███████║███████║  ███╔╝ ██║
-- ╚════██║██╔══██║██╔══██║ ███╔╝  ╚═╝
-- ███████║██║  ██║██║  ██║███████╗██╗
-- ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝
                                   


  dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("p", "  Browse Current Dir", ":Telescope find_files cwd=.<CR>"),
    dashboard.button("h", "  Home Directory", ":Telescope find_files cwd=~<CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
  }

  -- Set up alpha with the dashboard config
  dashboard.config.layout = {
    { type = 'padding', val = 10 },
    dashboard.section.header,
    { type = 'padding', val = 10 },
    dashboard.section.buttons,
    { type = 'padding', val = 10 },
  }
  
  -- Set up alpha with the dashboard config
  alpha.setup(dashboard.opts)
  
  -- Show dashboard when starting Neovim (but NOT if session was restored)
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      -- Don't show dashboard if:
      -- 1. Files were passed as arguments
      -- 2. We're in a git commit message
      -- 3. A session was restored (check if there are multiple buffers)
      -- 4. Current buffer has content
      local should_skip = vim.fn.argc() > 0
        or vim.o.filetype == 'gitcommit'
        or vim.o.filetype == 'gitrebase'
      
      -- Check if auto-session restored buffers
      local buf_count = #vim.fn.getbufinfo({ buflisted = 1 })
      if buf_count > 1 then
        should_skip = true
      end
      
      -- Check if current buffer has content
      if vim.fn.line2byte('$') ~= -1 then
        should_skip = true
      end
      
      if not should_skip then
        -- Show the alpha dashboard (DON'T delete buffers!)
        require("alpha").start(false) -- false = don't override current buffer
      end
    end,
  })
end

return M