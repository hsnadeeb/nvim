-- ============================================================================
-- Keymaps Configuration
-- ============================================================================

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Make sure which-key is loaded
local which_key_loaded, wk = pcall(require, 'which-key')

-- ============================================================================
-- General Keymaps
-- ============================================================================

-- Theme toggling
map('n', '<leader>thn', function() require('plugins.themes').next_theme() end, { desc = 'Next theme' })
-- Force which-key to show on space key press
map('n', '<space>', ':WhichKey<CR>', { silent = true, noremap = true })

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

-- Buffer tab navigation with barbar.nvim
map('n', '<Tab>', ':BufferNext<CR>', { desc = 'Next buffer tab' })
map('n', '<S-Tab>', ':BufferPrevious<CR>', { desc = 'Previous buffer tab' })
-- Alternative buffer navigation (keeping these as well)
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

-- Quick save and quit
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
map('n', '<leader>Q', ':q!<CR>', { desc = 'Force quit' })
map('n', '<leader>wq', ':wq<CR>', { desc = 'Save and quit' })
map('n', '<leader>W', ':wq<CR>', { desc = 'Save and quit' })  -- Alternative mapping

-- Clear search highlights
map('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlights' })

-- ============================================================================
-- Plugin: NvimTree
-- ============================================================================
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
map('n', '<leader>E', ':NvimTreeFocus<CR>', { desc = 'Focus NvimTree' })
map('n', '<leader>ff', ':NvimTreeFindFile<CR>', { desc = 'Find current file in NvimTree' })

-- ============================================================================
-- Plugin: Telescope
-- ============================================================================
local telescope = require('telescope.builtin')
map('n', '<leader>ff', telescope.find_files, { desc = 'Find Files' })
map('n', '<leader>fg', telescope.live_grep, { desc = 'Live Grep' })
map('n', '<leader>fb', telescope.buffers, { desc = 'Find Buffers' })
map('n', '<leader>fh', telescope.help_tags, { desc = 'Help Tags' })
map('n', '<leader>fr', telescope.oldfiles, { desc = 'Recent Files' })
map('n', '<leader>fk', telescope.keymaps, { desc = 'Keymaps' })

-- ============================================================================
-- LSP Keymaps
-- ============================================================================
local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation
  map('n', 'gD', vim.lsp.buf.declaration, opts)
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gi', vim.lsp.buf.implementation, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  
  -- Code actions
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
  map('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format document', buffer = bufnr })
  
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
  
  -- Telescope LSP
  map('n', '<leader>fs', telescope.lsp_document_symbols, { desc = 'Document Symbols', buffer = bufnr })
  map('n', '<leader>fS', telescope.lsp_workspace_symbols, { desc = 'Workspace Symbols', buffer = bufnr })
  map('n', '<leader>fd', telescope.lsp_definitions, { desc = 'Definitions', buffer = bufnr })
  map('n', '<leader>fi', telescope.lsp_implementations, { desc = 'Implementations', buffer = bufnr })
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
local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')

if gitsigns_ok then
  -- Navigation
  map('n', '<leader>gj', gitsigns.next_hunk, { desc = 'Next Git Hunk' })
  map('n', '<leader>gk', gitsigns.prev_hunk, { desc = 'Previous Git Hunk' })
  
  -- Staging
  map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage Git Hunk' })
  map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
  map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
  
  -- Reset
  map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset Git Hunk' })
  map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
  map('n', '<leader>gU', gitsigns.reset_buffer_index, { desc = 'Reset Buffer Index' })
  
  -- Diff
  map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Git Diff' })
  map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = 'Git Diff (Staged)' })
  
  -- Blame
  map('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end, { desc = 'Git Blame Line' })
  map('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'Toggle Git Blame' })
  
  -- Preview
  map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview Git Hunk' })
  map('n', '<leader>gP', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
  
  -- Toggles
  map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = 'Toggle Git Deleted' })
  map('n', '<leader>gtl', gitsigns.toggle_linehl, { desc = 'Toggle Git Line Highlight' })
  map('n', '<leader>gtw', gitsigns.toggle_word_diff, { desc = 'Toggle Git Word Diff' })
  map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle Git Blame' })
end

-- ============================================================================
-- Terminal Keymaps
-- ============================================================================
-- Toggle terminal on/off (neovim's terminal)
map('n', '<leader>tt', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
-- Toggle between terminal and last buffer
map('n', '<leader>`', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
map('t', '<leader>`', '<C-\\><C-n>:ToggleTerm<CR>', { desc = 'Toggle Terminal' })

-- Terminal window navigation (when in terminal mode)
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Move to left window' })
map('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Move to lower window' })
map('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Move to upper window' })
map('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Move to right window' })

-- ============================================================================
-- Trouble.nvim (Diagnostics)
-- ============================================================================
local trouble_ok, trouble = pcall(require, 'trouble')
if trouble_ok then
  map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'Toggle Trouble' })
  map('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', { desc = 'Workspace Diagnostics' })
  map('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', { desc = 'Document Diagnostics' })
  map('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>', { desc = 'Location List' })
  map('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', { desc = 'Quickfix List' })
  map('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>', { desc = 'LSP References' })
end

-- Register additional which-key mappings if it's available
if which_key_loaded then
  wk.register({
    ["<leader>d"] = { name = "debug" },
    ["<leader>f"] = { name = "find" },
    ["<leader>g"] = { name = "git" },
    ["<leader>x"] = { name = "trouble" },
    ["<leader>th"] = { name = "theme" },
  })
  
  wk.register({
    ["<leader>thn"] = { function() require("plugins.themes").next_theme() end, desc = "Next theme" },
  })
end