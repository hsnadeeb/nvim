-- ============================================================================
-- Alpha (Dashboard) Configuration
-- ============================================================================
return {
  {
    repo = "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  Browse Current Dir", ":Telescope find_files cwd=.<CR>"),
        dashboard.button("h", "  Home Directory", ":Telescope find_files cwd=~<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      dashboard.config.layout = {
        { type = 'padding', val = 10 },
        dashboard.section.header,
        { type = 'padding', val = 10 },
        dashboard.section.buttons,
        { type = 'padding', val = 10 },
      }

      alpha.setup(dashboard.opts)

      -- vim.api.nvim_create_autocmd("VimEnter", {
      --   callback = function()
      --   group = vim.api.nvim_create_augroup("AlphaDashboard", { clear = true }),
      --   pattern = "*",
      --     if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 and vim.o.filetype ~= 'gitcommit' then
      --       vim.cmd("silent! %bdelete!")
      --       require("alpha").start(require("alpha.themes.dashboard").opts)
      --     end
      --   end,
      -- })
    end,
  },
}




-- local M = {}

-- function M.setup()
--   local alpha = require("alpha")
--   local dashboard = require("alpha.themes.dashboard")

--   dashboard.section.header.val = {
--     "",    "░▒▓███████▓▒░ ░▒▓█▓▒░ ░▒▓█▓▒░ ░▒▓██████▓▒░░   ▒▓████████▓▒░ ▒▓█▓▒░ ",
--     " ░▒▓█▓▒░      ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░       ░▒▓█▓▒░  ▒▓█▓▒░ ",
--     " ░▒▓█▓▒░      ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░     ░▒▓██▓▒░   ▒▓█▓▒░ ",
--     "  ░▒▓██████▓▒ ░░▒▓████████▓▒░ ░▒▓████████▓▒░    ░▒▓██▓▒░    ▒▓█▓▒░ ",
--     "        ░▒▓█▓ ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓██▓▒░      ▒▓█▓▒░ ",
--     "        ░▒▓█▓ ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░                 ",
--     "░▒▓███████▓▒░ ░▒▓█▓▒░ ░▒▓█▓▒░ ▒▓█▓▒░ ░▒▓█▓▒░ ▓████████▓▒░   ▒▓█▓▒░ ",
--     "",
--   }


-- -- ███████╗██╗  ██╗ █████╗ ███████╗██╗
-- -- ██╔════╝██║  ██║██╔══██╗╚══███╔╝██║
-- -- ███████╗███████║███████║  ███╔╝ ██║
-- -- ╚════██║██╔══██║██╔══██║ ███╔╝  ╚═╝
-- -- ███████║██║  ██║██║  ██║███████╗██╗
-- -- ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝
                                   


--   dashboard.section.buttons.val = {
--     dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
--     dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
--     dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
--     dashboard.button("p", "  Browse Current Dir", ":Telescope find_files cwd=.<CR>"),
--     dashboard.button("h", "  Home Directory", ":Telescope find_files cwd=~<CR>"),
--     dashboard.button("q", "  Quit", ":qa<CR>"),
--   }

--   -- Set up alpha with the dashboard config
--   dashboard.config.layout = {
--     { type = 'padding', val = 10 },
--     dashboard.section.header,
--     { type = 'padding', val = 10 },
--     dashboard.section.buttons,
--     { type = 'padding', val = 10 },
--   }
  
--   -- Set up alpha with the dashboard config
--   alpha.setup(dashboard.opts)
  
--   -- Show dashboard when starting Neovim
--   vim.api.nvim_create_autocmd("VimEnter", {
--     pattern = "*",
--     callback = function()
--       -- Only show dashboard if no file was specified and we're not in a git commit message
--       if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 and vim.o.filetype ~= 'gitcommit' then
--         -- Close any open buffers
--         vim.cmd("silent! %bdelete!")
--         -- Show the alpha dashboard
--         require("alpha").start(require("alpha.themes.dashboard").opts)
--       end
--     end,
--   })
-- end

-- return M