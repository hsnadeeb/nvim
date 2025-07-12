-- local vim = require("vim")

return {
  {
    repo = "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local api = require('nvim-tree.api')

      -- Function to toggle nvim-tree
      local function toggle()
        api.tree.toggle({
          find_file = false,
          focus = true,
          update_root = true,
        })
      end

      -- -- Function to find current file in nvim-tree
      -- local function find_file()
      --   api.tree.find_file({
      --     open = true,
      --     focus = true,
      --     update_root = true,
      --   })
      -- end

      -- Function to toggle focus between nvim-tree and editor
      local function toggle_focus()
        if not api.tree.is_visible() then
          api.tree.open()
          api.tree.focus()
          return
        end
        local current_win = vim.api.nvim_get_current_win()
        local tree_winid = require('nvim-tree.view').get_winnr()
        if current_win == tree_winid then
          vim.cmd('wincmd p')
        else
          api.tree.focus()
        end
      end

      -- Function to toggle dotfiles visibility in nvim-tree
      local function toggle_dotfiles()
        local config = require('nvim-tree').config
        local new_dotfiles = not (config.filters.dotfiles or false)
        require('nvim-tree').setup({
          filters = {
            dotfiles = new_dotfiles,
            custom = config.filters.custom or {},
            exclude = config.filters.exclude or {}
          }
        })
        local status = new_dotfiles and 'hidden' or 'visible'
        vim.notify('Dotfiles are now ' .. status, vim.log.levels.INFO, { title = 'NvimTree' })
        if api.tree.is_visible() then
          local node = api.tree.get_node_under_cursor()
          if node then
            api.tree.change_root_to_node(node)
          end
        end
      end

      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Configure nvim-tree
      require('nvim-tree').setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
          ignore_list = { 'help' },
        },
        view = {
          width = 35,
          side = "left",
          preserve_window_proportions = true,
          number = false,
          relativenumber = false,
          signcolumn = 'yes',
          float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
              relative = 'editor',
              border = 'rounded',
              width = 40,
              height = 30,
              row = 1,
              col = 1,
            },
          },
        },
        renderer = {
          add_trailing = false,
          group_empty = true,
          highlight_git = true,
          full_name = false,
          highlight_opened_files = 'all',
          highlight_modified = 'icon',
          root_folder_label = ':~:s?$?/..?',
          indent_width = 2,
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = '└',
              edge = '│',
              item = '│',
              bottom = '─',
              none = ' ',
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = 'before',
            modified_placement = 'after',
            padding = ' ',
            symlink_arrow = ' ➛ ',
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
            },
            glyphs = {
              default = '',
              symlink = '',
              bookmark = '󰆤',
              modified = '●',
              folder = {
                arrow_closed = '',
                arrow_open = '',
                default = '',
                open = '',
                empty = '',
                empty_open = '',
                symlink = '',
                symlink_open = '',
              },
              git = {
                unstaged = '✗',
                staged = '✓',
                unmerged = '',
                renamed = '➜',
                untracked = '★',
                deleted = '',
                ignored = '◌',
              },
            },
          },
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = true,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = { 'node_modules', 'target', 'build' },
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = true,
              chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
              exclude = {
                filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
                buftype = { 'nofile', 'terminal', 'help' },
              },
            },
          },
        },
        filters = {
          dotfiles = false,
          custom = { 'node_modules', '\\.cache', '^_build$', '^deps$' },
          exclude = {},
        },
        git = {
          enable = true,
          ignore = false,
          show_on_dirs = true,
          timeout = 400,
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          debounce_delay = 50,
          icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
          },
        },
        ui = {
          confirm = {
            default_yes = false,
          },
        },
        log = {
          enable = false,
          truncate = true,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
        },
      })

      -- Keymaps
      vim.keymap.set('n', '<leader>n', toggle, { desc = 'Toggle NvimTree' })
      vim.keymap.set('n', '<leader>e', toggle_focus, { desc = 'Toggle focus between NvimTree and editor' })
      vim.keymap.set('n', '<leader>h', toggle_dotfiles, { desc = 'Toggle dotfiles in NvimTree' })

      -- Auto-commands
      local nvim_tree_group = vim.api.nvim_create_augroup('NvimTreeIntegration', { clear = true })

      -- Auto-close if only NvimTree is open
      vim.api.nvim_create_autocmd('BufEnter', {
        group = nvim_tree_group,
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match('NvimTree_') then
            vim.cmd('quit')
          end
        end
      })

      -- Auto-open when opening a directory
      vim.api.nvim_create_autocmd('VimEnter', {
        group = nvim_tree_group,
        nested = true,
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1
          if not directory then return end
          vim.cmd.cd(data.file)
          api.tree.open()
        end
      })

      -- Auto-close on quit if only NvimTree is open
      vim.api.nvim_create_autocmd('QuitPre', {
        group = nvim_tree_group,
        callback = function()
          local tree_wins = {}
          local floating_wins = {}
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match('NvimTree_') then
              table.insert(tree_wins, w)
            end
            local config = vim.api.nvim_win_get_config(w)
            if config.relative ~= '' then
              table.insert(floating_wins, w)
            end
          end
          if #tree_wins == 1 and #wins == #floating_wins + #tree_wins then
            local modified = false
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_get_option(buf, 'modified') then
                modified = true
                break
              end
            end
            if not modified then
              vim.cmd('NvimTreeClose')
            end
          end
        end
      })

      -- Highlight on yank
      local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
      vim.api.nvim_create_autocmd('TextYankPost', {
        group = highlight_group,
        pattern = '*',
        callback = function()
          vim.highlight.on_yank()
        end,
      })

      -- Auto-resize windows when Vim is resized
      vim.api.nvim_create_autocmd('VimResized', {
        group = vim.api.nvim_create_augroup('NvimTreeResize', { clear = true }),
        callback = function()
          vim.cmd('wincmd =')
        end,
      })
    end,
  },
}