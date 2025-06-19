local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

function M.setup()
  local status_ok, nvim_tree = pcall(require, "nvim-tree")
  if not status_ok then
    vim.notify("nvim-tree.lua not found!", vim.log.levels.ERROR)
    return
  end

  -- Disable netrw (recommended by nvim-tree)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Configure nvim-tree
  nvim_tree.setup({
    view = {
      width = 30,
      side = "left",
    },
    renderer = {
      group_empty = true,
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
        },
      },
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    filters = {
      dotfiles = false,
      custom = { "^.git$" },
    },
    git = {
      enable = true,
      ignore = false,
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
  })

  -- Set up keybindings
  map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
  map('n', '<leader>E', ':NvimTreeFocus<CR>', { desc = 'Focus NvimTree' })
  map('n', '<leader>ff', ':NvimTreeFindFile<CR>', { desc = 'Find current file in NvimTree' })
end

return M