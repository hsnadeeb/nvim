local M = {}

function M.setup()
  -- Disable netrw (recommended by nvim-tree)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Import nvim-tree API
  local api = require('nvim-tree.api')

  -- Configure nvim-tree with minimal settings
  require('nvim-tree').setup({
    view = {
      width = 30,
      side = "left",
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      highlight_opened_files = 'all',
      icons = {
        webdev_colors = true,
        git_placement = "before",
        show = {
          file = true,
          folder = true,
          git = true,
        },
      },
    },
    actions = {
      open_file = {
        quit_on_open = true,
        window_picker = {
          enable = true,
        },
      },
    },
    filters = {
      dotfiles = false,
      custom = { '^\\.git$', '^node_modules$', '^\\.cache$' },
    },
    git = {
      enable = true,
      ignore = false,
      show_on_dirs = true,
      timeout = 400,
    },
    on_attach = function(bufnr)
      -- Default mappings
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Basic keymaps
      vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', '<C-e>', api.node.open.vertical, opts('Open: Vertical Split'))
      vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
      vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
      vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
      vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
      vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
      vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
      vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
      vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
      vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
      vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
      vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
      vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
      vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
      vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
    end,
  })

  -- Global keybindings
  vim.keymap.set('n', '<leader>e', api.tree.toggle, { desc = 'Toggle NvimTree' })
  vim.keymap.set('n', '<leader>E', api.tree.focus, { desc = 'Focus NvimTree' })
  vim.keymap.set('n', '<leader>ff', api.tree.find_file, { desc = 'Find current file in NvimTree' })
end

return M