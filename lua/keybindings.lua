-- ============================================================================
-- Keymaps Configuration
-- ============================================================================

-- Load utility functions
local utils = require('utils')
local map = utils.map

-- Load which-key if available
local wk = utils.safe_require('which-key')

-- ============================================================================
-- General Keymaps
-- ============================================================================

-- Theme toggling - managed by which-key
-- Using consistent paths and descriptions with which-key
map('n', '<leader>thn', function() require('plugins.themes').next_theme() end, { desc = 'Next Theme' })

-- Better window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows with arrows
map('n', '<C-Up>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Down>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Start and end of line navigation
map('n', 'H', '^', { desc = 'Go to start of line' })
map('n', 'L', '$', { desc = 'Go to end of line' })
map('v', 'H', '^', { desc = 'Go to start of line' })
map('v', 'L', '$', { desc = 'Go to end of line' })
-- Alternative with Home/End keys
map('n', '<Home>', '^', { desc = 'Go to start of line' })
map('n', '<End>', '$', { desc = 'Go to end of line' })
map('v', '<Home>', '^', { desc = 'Go to start of line' })
map('v', '<End>', '$', { desc = 'Go to end of line' })

-- Buffer tab navigation with barbar.nvim
map('n', '<Tab>', ':BufferNext<CR>', { desc = 'Next buffer tab' })
map('n', '<S-Tab>', ':BufferPrevious<CR>', { desc = 'Previous buffer tab' })
-- Buffer navigation with Alt keys 
map('n', '<A-,>', ':BufferPrevious<CR>', { desc = 'Previous buffer tab' })
map('n', '<A-.>', ':BufferNext<CR>', { desc = 'Next buffer tab' })
map('n', '<A-<>', ':BufferMovePrevious<CR>', { desc = 'Move buffer tab left' })
map('n', '<A->>', ':BufferMoveNext<CR>', { desc = 'Move buffer tab right' })
map('n', '<A-c>', ':BufferClose<CR>', { desc = 'Close current buffer tab' })
map('n', '<A-p>', ':BufferPin<CR>', { desc = 'Pin/unpin current buffer' })
map('n', '<A-1>', ':BufferGoto 1<CR>', { desc = 'Go to buffer 1' })
map('n', '<A-2>', ':BufferGoto 2<CR>', { desc = 'Go to buffer 2' })
map('n', '<A-3>', ':BufferGoto 3<CR>', { desc = 'Go to buffer 3' })
map('n', '<A-4>', ':BufferGoto 4<CR>', { desc = 'Go to buffer 4' })
map('n', '<A-5>', ':BufferGoto 5<CR>', { desc = 'Go to buffer 5' })
map('n', '<A-6>', ':BufferGoto 6<CR>', { desc = 'Go to buffer 6' })
map('n', '<A-7>', ':BufferGoto 7<CR>', { desc = 'Go to buffer 7' })
map('n', '<A-8>', ':BufferGoto 8<CR>', { desc = 'Go to buffer 8' })
map('n', '<A-9>', ':BufferLast<CR>', { desc = 'Go to last buffer' })

-- Keep these as fallbacks
map('n', '<S-h>', ':BufferPrevious<CR>', { desc = 'Previous buffer tab' })
map('n', '<S-l>', ':BufferNext<CR>', { desc = 'Next buffer tab' })
map('n', '<leader>bd', ':BufferClose<CR>', { desc = 'Delete buffer' })
map('n', '<leader>bc', ':BufferClose<CR>', { desc = 'Close current buffer' })
map('n', '<C-w>c', ':BufferClose<CR>', { desc = 'Close current buffer' })

-- Quick save and quit
map('n', '<leader>ws', ':w<CR>', { desc = 'Save' }) -- Updated description to match which-key
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
map('n', '<leader>Q', ':q!<CR>', { desc = 'Force Quit' })
map('n', '<leader>wq', ':wq<CR>', { desc = 'Save and Quit' })

-- Clear search highlights
map('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlights' })

-- ============================================================================
-- Plugin: Telescope
-- ============================================================================
-- Telescope keybindings are now managed in plugins/telescope.lua

-- ============================================================================
-- LSP Keymaps
-- ============================================================================
local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation
  map('n', 'gD', vim.lsp.buf.declaration, opts)
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gi', vim.lsp.buf.implementation, opts)
  map('n', 'gr', vim.lsp.buf.references, opts) -- Keep this consistent with which-key
  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  
  -- Code actions
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
  map('n', '<leader>fm', vim.lsp.buf.format, { desc = 'Format document', buffer = bufnr })
  
  -- Workspace
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  
  -- Diagnostics
  map('n', 'gl', vim.diagnostic.open_float, opts)
  map('n', '[d', vim.diagnostic.goto_prev, opts)
  map('n', ']d', vim.diagnostic.goto_next, opts)
  
  -- Telescope LSP keybindings are now managed in plugins/telescope.lua
end

-- Set up LSP keymaps when a language server attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    lsp_keymaps(ev.buf)
    
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
})

-- ============================================================================
-- Git Keymaps
-- ============================================================================
-- Git keymaps are now managed in plugins/gitsigns.lua

-- ============================================================================
-- Terminal Keymaps
-- ============================================================================
-- Terminal keymaps are now managed in plugins/toggleterm.lua

-- ============================================================================
-- Trouble.nvim (Diagnostics)
-- ============================================================================
-- Trouble keybindings are now managed in trouble.lua

-- Which-key mappings are now handled in plugins/which-key.lua