local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

-- Function to toggle nvim-tree
function M.toggle()
  require('nvim-tree.api').tree.toggle({
    find_file = false,
    focus = true,
    update_root = true,
  })
end

-- Function to find current file in nvim-tree
function M.find_file()
  require('nvim-tree.api').tree.find_file({
    open = true,
    focus = true,
    update_root = true,
  })
end

-- Function to toggle focus between nvim-tree and editor
function M.toggle_focus()
  local api = require('nvim-tree.api')
  
  -- If nvim-tree is not open, open it and focus
  if not require('nvim-tree.view').is_visible() then
    api.tree.open()
    api.tree.focus()
    return
  end
  
  -- If nvim-tree is open, check if it's focused
  local current_win = vim.api.nvim_get_current_win()
  local tree_winid = require('nvim-tree.view').get_winnr()
  
  if current_win == tree_winid then
    -- Currently in nvim-tree, move to the last used editor window
    vim.cmd('wincmd p')
  else
    -- Currently in editor, focus nvim-tree
    api.tree.focus()
  end
end

-- Function to toggle dotfiles visibility in nvim-tree
function M.toggle_dotfiles()
  local api = require('nvim-tree.api')
  
  -- Get current configuration
  local config = require('nvim-tree').config
  
  -- Toggle dotfiles
  local new_dotfiles = not (config.filters.dotfiles or false)
  
  -- Update the configuration
  require('nvim-tree').setup({
    filters = {
      dotfiles = new_dotfiles,
      custom = config.filters.custom or {},
      exclude = config.filters.exclude or {}
    }
  })
  
  -- Show notification
  local status = new_dotfiles and 'hidden' or 'visible'
  vim.notify('Dotfiles are now ' .. status, vim.log.levels.INFO, { title = 'NvimTree' })
  
  -- Refresh the current node if tree is visible
  if api.tree.is_visible() then
    local node = api.tree.get_node_under_cursor()
    if node then
      api.tree.change_root_to_node(node)
    end
  end
end

function M.setup()
  local status_ok, nvim_tree = pcall(require, "nvim-tree")
  if not status_ok then
    vim.notify("nvim-tree.lua not found!", vim.log.levels.ERROR)
    return
  end

  -- Disable netrw (recommended by nvim-tree)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Configure nvim-tree with enhanced settings
  nvim_tree.setup({
    -- Performance optimizations
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
      ignore_list = { 'help' },
    },
    
    -- View configuration
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
    
    -- Renderer configuration
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
    
    -- Actions configuration
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
    
    -- Filters
    filters = {
      dotfiles = false,  -- we keep this false to show dotfiles by default
      custom = { 'node_modules', '\\.cache', '^_build$', '^deps$' },
      exclude = {},
    },
    
    -- Git integration
    git = {
      enable = true,
      ignore = false,
      show_on_dirs = true,
      timeout = 400,
    },
    
    -- Diagnostics
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
    
    -- UI options
    ui = {
      confirm = {
        default_yes = false,
      },
    },
    
    -- Logging (disabled for performance)
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
  
  -- Auto-close if it's the last buffer
  vim.api.nvim_create_autocmd('BufEnter', {
    nested = true,
    callback = function()
      if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
        vim.cmd('quit')
      end
    end
  })
  
  -- Auto-open on directory
  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    callback = function(data)
      -- Buffer is a directory
      local directory = vim.fn.isdirectory(data.file) == 1
      
      -- Don't auto-open if NvimTree is already open
      if not directory then return end
      
      -- Change to the directory
      vim.cmd.cd(data.file)
      
      -- Open the tree
      require('nvim-tree.api').tree.open()
    end,
  })
  
  -- Close nvim-tree when opening a file
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('NvimTreeClose', { clear = true }),
    pattern = 'NvimTree_*',
    callback = function()
      local layout = vim.api.nvim_call_function('winlayout', {})
      if layout[1] == 'leaf' and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), 'filetype') == 'NvimTree' and #layout == 2 then
        vim.cmd('quit')
      end
    end
  })
  
  -- Auto-close on exit if only NvimTree is open
  vim.api.nvim_create_autocmd('QuitPre', {
    callback = function()
      local tree_wins = {}
      local floating_wins = {}
      local wins = vim.api.nvim_list_wins()
      
      for _, w in ipairs(wins) do
        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
        if bufname:match('NvimTree_') ~= nil then
          table.insert(tree_wins, w)
        end
        
        local config = vim.api.nvim_win_get_config(w)
        if config.relative ~= '' then
          table.insert(floating_wins, w)
        end
      end
      
      if #tree_wins == 1 and #wins == #floating_wins + #tree_wins then
        -- Don't auto-close if there are modified buffers
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
  
  -- Keymaps for NvimTree
  map('n', '<leader>n', M.toggle, { desc = 'Toggle NvimTree' })
  map('n', '<leader>e', M.toggle_focus, { desc = 'Toggle focus between NvimTree and editor' })
  map('n', '<leader>h', M.toggle_dotfiles, { desc = 'Toggle dotfiles in NvimTree' })
  
  -- Auto-commands for better integration
  local nvim_tree_group = vim.api.nvim_create_augroup('NvimTreeIntegration', { clear = true })
  
  -- Auto-close when quitting if only NvimTree is open
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
  
  -- Auto-open when opening a directory
  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    group = nvim_tree_group,
    nested = true,
    callback = function(data)
      -- Only open if argument is a directory
      local directory = vim.fn.isdirectory(data.file) == 1
      
      if not directory then
        return
      end
      
      -- Change to the directory
      vim.cmd.cd(data.file)
      
      -- Open the tree
      require('nvim-tree.api').tree.open()
    end
  })
  
  -- Auto-close if only NvimTree is open
  vim.api.nvim_create_autocmd('BufEnter', {
    group = nvim_tree_group,
    nested = true,
    callback = function()
      local api = require('nvim-tree.api')
      -- Only close tree if it's the last window
      if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match('NvimTree_') then
        vim.cmd('quit')
      end
    end
  })
  
  -- Highlight on yank
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })
  
  -- Auto-resize windows when Vim is resized
  vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup('NvimTreeResize', { clear = true }),
    callback = function()
      vim.cmd('wincmd =')
    end,
  })
end

return M