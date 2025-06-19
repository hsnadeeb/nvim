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

  -- Load extensions if available
  pcall(telescope.load_extension, "fzf")

  -- Set up keybindings
  local builtin = require("telescope.builtin")

  -- Find operations
  map('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
  map('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
  map('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
  map('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
  map('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent Files' })
  map('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })

  -- Git operations
  map('n', '<leader>gc', builtin.git_commits, { desc = 'Git Commits' })
  map('n', '<leader>gbc', builtin.git_bcommits, { desc = 'Git Buffer Commits' })
  map('n', '<leader>gB', builtin.git_branches, { desc = 'Branches' })
  map('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })

  -- LSP operations
  map('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document Symbols' })
  map('n', '<leader>fS', builtin.lsp_workspace_symbols, { desc = 'Workspace Symbols' })
  map('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Definitions' })
  map('n', '<leader>fi', builtin.lsp_implementations, { desc = 'Implementations' })

  -- Mappings are now centrally managed in which-key.lua
end

return M
