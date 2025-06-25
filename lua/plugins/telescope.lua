local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

function M.setup()
  local status_ok, telescope = pcall(require, "telescope")
  if not status_ok then
    vim.notify("telescope.nvim not found!", vim.log.levels.ERROR)
    return
  end

  -- Setup keybindings
  local function setup_keymaps()
    local telescope_builtin = require('telescope.builtin')
    
    -- File operations
    vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Find buffer' })
    vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Find help' })
    vim.keymap.set('n', '<leader>fr', telescope_builtin.oldfiles, { desc = 'Recent files' })
    vim.keymap.set('n', '<leader>ft', '<cmd>Telescope<CR>', { desc = 'Telescope' })
    
    -- Git operations
    vim.keymap.set('n', '<leader>gg', telescope_builtin.git_commits, { desc = 'Git commits' })
    vim.keymap.set('n', '<leader>gc', telescope_builtin.git_bcommits, { desc = 'Git commits (buffer)' })
    vim.keymap.set('n', '<leader>gb', telescope_builtin.git_branches, { desc = 'Git branches' })
    vim.keymap.set('n', '<leader>gs', telescope_builtin.git_status, { desc = 'Git status' })
  end

  -- Configure telescope
  telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      file_ignore_patterns = { ".git/", "node_modules/" },
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
          ["<C-c>"] = require("telescope.actions").close,
          ["<Down>"] = require("telescope.actions").move_selection_next,
          ["<Up>"] = require("telescope.actions").move_selection_previous,
          ["<C-u>"] = false, -- Clear prompt
        },
        n = {
          ["q"] = require("telescope.actions").close,
          ["<Esc>"] = require("telescope.actions").close
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      live_grep = {
        additional_args = function()
          return { "--hidden" }
        end,
      },
    },
    extensions = {
      -- Add any telescope extensions here
    },
  })
  
  -- Load extensions
  for _, ext in ipairs({
    -- Add any telescope extensions here
  }) do
    telescope.load_extension(ext)
  end
  
  -- Setup keybindings after telescope is loaded
  setup_keymaps()
end

return M
