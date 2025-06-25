local M = {}

-- Load utility functions
local utils = require("utils")

function M.setup()
  local status_ok, gitsigns = pcall(require, "gitsigns")
  if not status_ok then
    vim.notify("gitsigns.nvim not found!", vim.log.levels.ERROR)
    return
  end

  -- Configure gitsigns
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

  -- Setup keybindings
  local function setup_keymaps()
    -- Navigation (using which-key groups for consistency)
    local keymaps = {
      -- Normal mode mappings
      ['n'] = {
        [']c'] = { 'v:lua.require"gitsigns.actions".next_hunk()', 'Next hunk', expr = true },
        ['[c'] = { 'v:lua.require"gitsigns.actions".prev_hunk()', 'Previous hunk', expr = true },
        
        -- Git operations with leader prefix
        ['<leader>g'] = {
          name = '+Git',
          ['s'] = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
          ['u'] = { '<cmd>Gitsigns undo_stage_hunk<CR>', 'Undo stage hunk' },
          ['r'] = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
          ['S'] = { '<cmd>Gitsigns stage_buffer<CR>', 'Stage buffer' },
          ['R'] = { '<cmd>Gitsigns reset_buffer<CR>', 'Reset buffer' },
          ['p'] = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
          ['b'] = { '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', 'Blame line' },
          ['d'] = { '<cmd>Gitsigns diffthis<CR>', 'Diff this' },
          ['D'] = { '<cmd>lua require"gitsigns".diffthis("~")<CR>', 'Diff this ~' },
        },
      },
      -- Visual mode mappings
      ['v'] = {
        ['<leader>gs'] = { ':Gitsigns stage_hunk<CR>', 'Stage hunk' },
        ['<leader>gr'] = { ':Gitsigns reset_hunk<CR>', 'Reset hunk' },
      },
    }


    -- Apply the keymaps
    local wk = require('which-key')
    if wk then
      -- Register normal mode keymaps
      wk.register(keymaps['n'])
      -- Register visual mode keymaps
      wk.register(keymaps['v'], { mode = 'v' })
    else
      -- Fallback to manual keymap setting if which-key is not available
      for mode, mappings in pairs(keymaps) do
        for key, cmd in pairs(mappings) do
          if type(cmd) == 'table' and cmd[1] then
            local opts = { desc = cmd[2] }
            if cmd.expr then opts.expr = true end
            vim.keymap.set(mode, key, cmd[1], opts)
          end
        end
      end
    end
  end

  setup_keymaps()
end

return M