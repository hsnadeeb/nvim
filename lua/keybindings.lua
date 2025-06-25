-- ============================================================================
-- Keymaps Configuration
-- ============================================================================
-- Centralized keybindings for Neovim core functionality
-- Plugin-specific keybindings have been moved to their respective plugin files

-- Load utility functions
local utils = require('utils')
local map = utils.map

-- Load which-key for better keybinding management
local wk = utils.safe_require('which-key')

-- Helper function to register keymaps with which-key
local function register_keymaps(mode, prefix, keymaps, opts)
  -- Register with which-key if available
  if wk then
    wk.register(keymaps, vim.tbl_extend('force', { mode = mode, prefix = prefix }, opts or {}))
  end
  
  -- Function to process and register a single keymap
  local function register_single_keymap(key, mapping, current_prefix)
    -- If this is a nested keymap (has a 'name' key), process its children
    if mapping.name then
      if mapping[1] == nil then  -- Only process if not a direct mapping
        for k, v in pairs(mapping) do
          if type(k) == 'string' and k ~= 'name' and k ~= 'desc' and k ~= 'opts' then
            register_single_keymap(k, v, current_prefix .. key)
          end
        end
        return
      end
    end
    
    -- This is a leaf node (actual keybinding)
    local cmd = mapping[1]
    if not cmd then return end  -- Skip if no command is provided
    
    local desc = mapping.desc or mapping[2] or ''
    local options = vim.tbl_extend('force', { 
      desc = desc,
      noremap = true,
      silent = true 
    }, mapping.opts or {})
    
    -- Only register if we have a valid command
    if type(cmd) == 'string' or type(cmd) == 'function' then
      map(mode, current_prefix .. key, cmd, options)
    end
  end
  
  -- Process all keymaps
  for key, mapping in pairs(keymaps) do
    if type(key) == 'string' then  -- Only process string keys (skip numeric indices)
      register_single_keymap(key, mapping, prefix or '')
    end
  end
end

-- ============================================================================
-- Leader Key Configuration
-- ============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- ============================================================================
-- General Keymaps
-- ============================================================================

-- Window Navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to window below' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to window above' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Window Resizing
map('n', '<C-Up>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Down>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Line Navigation
map('n', 'H', '^', { desc = 'Go to start of line' })
map('n', 'L', '$', { desc = 'Go to end of line' })
map('n', '<Home>', '^', { desc = 'Go to start of line' })
map('n', '<End>', '$', { desc = 'Go to end of line' })
map('v', 'H', '^', { desc = 'Go to start of line' })
map('v', 'L', '$', { desc = 'Go to end of line' })
map('v', '<Home>', '^', { desc = 'Go to start of line' })
map('v', '<End>', '$', { desc = 'Go to end of line' })

-- Search
map('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Toggle comments with <leader>/
map('n', '<leader>/', function()
  require('Comment.api').toggle.linewise.current()
end, { desc = 'Toggle comment line' })

-- Visual mode mapping for commenting selected lines
map('v', '<leader>/', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = 'Toggle comment selection' })

-- File Operations
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>ws', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>wq', ':wq<CR>', { desc = 'Save and quit' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
map('n', '<leader>Q', ':q!<CR>', { desc = 'Force quit' })

-- Navigation History
map('n', '<leader>[', '<C-o>', { desc = 'Go to previous cursor position' })
map('n', '<leader>]', '<C-i>', { desc = 'Go to next cursor position' })

-- Quickfix List
map('n', ']q', ':cnext<CR>', { desc = 'Next quickfix item' })
map('n', '[q', ':cprev<CR>', { desc = 'Previous quickfix item' })

-- ============================================================================
-- Plugin Keymaps (Moved to respective plugin files)
-- ============================================================================
-- LSP keybindings are managed in lsp.lua
-- Git keybindings are managed in plugins/gitsigns.lua
-- Comment keybindings are managed in plugins/comment.lua
-- ToggleTerm keybindings are managed in plugins/toggleterm.lua
-- Buffer switching
map('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer' })

-- Buffer keybindings are managed in plugins/barbar.lua
-- Trouble.nvim keybindings are managed in plugins/trouble.lua
-- DAP keybindings are managed in plugins/dap.lua

-- ============================================================================
-- Which-key Menu Configuration
-- ============================================================================
if wk then
  -- Define the prefix groups first
  local leader_keymaps = {
    f = { name = '+Find' },
    g = { name = '+Git' },
    l = { name = '+LSP' },
    d = { name = '+Debug' },
    x = { name = '+Trouble' },
    t = { name = '+Theme' },
    q = { name = '+Quickfix' },
    w = { name = '+Window' },
    b = { name = '+Buffer' },
  }

  -- Register the leader keymaps
  wk.register({
    ['<leader>'] = leader_keymaps,
  })

  -- Explicitly define the conflicting keymaps
  wk.register({
    -- Resolve 'gc' conflict (likely from comment.nvim)
    gc = { name = 'Comment' },
    
    -- Resolve ' w' conflict
    [' w'] = { ':w<CR>', 'Save file' },
    
    -- Resolve ' gb' conflict (likely from gitsigns)
    [' gb'] = { '<Cmd>lua require"gitsigns".blame_line{full=true}<CR>', 'Git blame line' },
  }, { mode = 'n' })
  
  -- Set terminal keymaps
  local function set_terminal_keymaps()
    -- Set terminal keymaps using vim.cmd for reliability
    vim.cmd([[
      " Set terminal keymaps
      tnoremap <Esc> <C-\><C-n>
      tnoremap <C-v><Esc> <Esc>
      
      " Toggle terminal with leader+\ (backslash)
      tnoremap <leader>\ <C-\><C-n>:ToggleTerm<CR>
      
      " Window navigation in terminal mode
      tnoremap <C-h> <C-\><C-n><C-w>h
      tnoremap <C-j> <C-\><C-n><C-w>j
      tnoremap <C-k> <C-\><C-n><C-w>k
      tnoremap <C-l> <C-\><C-n><C-w>l
    ]])
    
    -- Add normal mode mapping for leader+\ to toggle terminal
    vim.keymap.set('n', '<leader>\\', ':ToggleTerm<CR>', { noremap = true, silent = true, desc = 'Toggle terminal' })
  end
  
  -- Set terminal keymaps on startup
  set_terminal_keymaps()
  
  -- Also set them when TermOpen event is triggered
  vim.api.nvim_create_autocmd('TermOpen', {
    pattern = 'term://*',
    callback = set_terminal_keymaps
  })
end