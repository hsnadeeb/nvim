-- ============================================================================
-- Keymaps Configuration
-- ============================================================================
-- Centralized keybindings for Neovim
-- This file contains all keybindings for core functionality and plugins

-- Load utility functions
local utils = require('utils')
local map = utils.map

-- Load which-key safely
local wk = utils.safe_require('which-key')

-- ============================================================================
-- Leader Keys
-- ============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- ============================================================================
-- Core Utility Functions
-- ============================================================================

-- Helper function to create keymaps with consistent options
local function create_keymap(mode, key, cmd, desc, opts)
  opts = opts or {}
  local default_opts = {
    desc = desc,
    noremap = true,
    silent = true
  }
  map(mode, key, cmd, vim.tbl_extend('force', default_opts, opts))
end

-- Helper function to register which-key groups (minimal - most are in which-key.lua)
local function register_which_key_groups()
  if not wk then return end
  
  -- Only register groups not covered by which-key.lua
  wk.register({
    ['<leader>j'] = { name = '+Java' },
  })
end

-- ============================================================================
-- General Navigation & Editing
-- ============================================================================

-- Window navigation
create_keymap('n', '<C-h>', '<C-w>h', 'Move to left window')
create_keymap('n', '<C-j>', '<C-w>j', 'Move to window below')
create_keymap('n', '<C-k>', '<C-w>k', 'Move to window above')
create_keymap('n', '<C-l>', '<C-w>l', 'Move to right window')

-- Line navigation
create_keymap('n', 'H', '^', 'Go to start of line')
create_keymap('n', 'L', '$', 'Go to end of line')
create_keymap('v', 'H', '^', 'Go to start of line')
create_keymap('v', 'L', '$', 'Go to end of line')

-- IntelliJ-style navigation
create_keymap('n', '<leader>[', '<C-o>', 'Go to previous cursor position')
create_keymap('n', '<leader>]', '<C-i>', 'Go to next cursor position')

-- Quickfix navigation
create_keymap('n', ']q', ':cnext<CR>', 'Next quickfix item')
create_keymap('n', '[q', ':cprev<CR>', 'Previous quickfix item')

-- Clear search highlights (alternative to which-key version)
create_keymap('n', '<Esc>', ':nohlsearch<CR>', 'Clear search highlights')

-- ============================================================================
-- Buffer Management (barbar.nvim)
-- ============================================================================

-- Primary buffer navigation with Alt keys
create_keymap('n', '<A-,>', ':BufferPrevious<CR>', 'Previous buffer')
create_keymap('n', '<A-.>', ':BufferNext<CR>', 'Next buffer')
create_keymap('n', '<A-<>', ':BufferMovePrevious<CR>', 'Move buffer left')
create_keymap('n', '<A->>>', ':BufferMoveNext<CR>', 'Move buffer right')
create_keymap('n', '<A-c>', ':BufferClose<CR>', 'Close buffer')
create_keymap('n', '<A-p>', ':BufferPin<CR>', 'Pin/Unpin buffer')

-- Quick buffer access with Alt+number
for i = 1, 8 do
  create_keymap('n', '<A-' .. i .. '>', ':BufferGoto ' .. i .. '<CR>', 'Go to buffer ' .. i)
end
create_keymap('n', '<A-9>', ':BufferLast<CR>', 'Go to last buffer')

-- Alternative buffer navigation
create_keymap('n', '<Tab>', ':BufferNext<CR>', 'Next buffer')
create_keymap('n', '<S-Tab>', ':BufferPrevious<CR>', 'Previous buffer')

-- Buffer management with leader
create_keymap('n', '<leader>bd', ':BufferClose<CR>', 'Delete buffer')
create_keymap('n', '<leader>bD', ':BufferClose!<CR>', 'Force delete buffer')

-- File operations (non-conflicting with which-key)
create_keymap('n', '<leader>ws', ':w<CR>', 'Save file')

-- Alternative quit operations (BufferClose instead of :q to work with barbar)
create_keymap('n', '<leader>wq', ':w | BufferClose<CR>', 'Save and close buffer')

-- ============================================================================
-- Window Management
-- ============================================================================

if wk then
  wk.register({
    w = {
      name = '+Window',
      h = { '<C-w>h', 'Move to left window' },
      j = { '<C-w>j', 'Move to window below' },
      k = { '<C-w>k', 'Move to window above' },
      l = { '<C-w>l', 'Move to right window' },
      ['='] = { '<C-w>=', 'Balance windows' },
      ['|'] = { '<C-w>v', 'Split window vertically' },
      ['-'] = { '<C-w>s', 'Split window horizontally' },
      c = { '<C-w>c', 'Close window' },
      o = { '<C-w>o', 'Close other windows' },
    },
  }, { prefix = '<leader>' })
end

-- ============================================================================
-- Git Integration (Additional Gitsigns keymaps)
-- ============================================================================
-- Note: Main git keymaps are defined in which-key.lua
-- These are additional non-conflicting git keymaps

create_keymap('n', '<leader>gr', '<Cmd>Gitsigns reset_hunk<CR>', 'Reset hunk')
create_keymap('n', '<leader>gR', '<Cmd>Gitsigns reset_buffer<CR>', 'Reset buffer')
create_keymap('n', '<leader>gu', '<Cmd>Gitsigns undo_stage_hunk<CR>', 'Unstage hunk')

-- Git hunk navigation (bracket mappings)
create_keymap('n', ']g', '<Cmd>Gitsigns next_hunk<CR>', 'Next git hunk')
create_keymap('n', '[g', '<Cmd>Gitsigns prev_hunk<CR>', 'Previous git hunk')

-- ============================================================================
-- Java Development
-- ============================================================================

create_keymap('n', '<leader>jr', function()
  vim.cmd('silent! write')
  local filename = vim.fn.expand('%:t:r')
  local filepath = vim.fn.expand('%:p')
  local dir = vim.fn.fnamemodify(filepath, ':h')
  
  local compile_cmd = string.format('silent !cd %s && javac %s', 
    vim.fn.shellescape(dir),
    vim.fn.shellescape(vim.fn.expand('%:t')))
  
  local run_cmd = string.format('terminal cd %s && java %s',
    vim.fn.shellescape(dir),
    filename)
  
  vim.cmd(compile_cmd)
  vim.cmd('botright split')
  vim.cmd(run_cmd)
  vim.cmd('startinsert')
end, 'Compile and run Java file')

-- ============================================================================
-- LSP Configuration
-- ============================================================================

-- Function to set up LSP keymaps for a buffer
local function setup_lsp_keymaps(bufnr)
  local function buf_map(key, cmd, desc)
    create_keymap('n', key, cmd, desc, { buffer = bufnr })
  end
  
  local function safe_lsp_call(func, error_msg)
    return function()
      local ok, _ = pcall(func)
      if not ok then
        vim.notify('LSP: ' .. error_msg, vim.log.levels.INFO)
      end
    end
  end

  -- Navigation (non-conflicting with which-key)
  -- Note: Basic LSP keymaps like gd, gD, gi, gR are defined in which-key.lua
  buf_map('gr', safe_lsp_call(vim.lsp.buf.references, 'no references found'), 'Show references')
  buf_map('K', safe_lsp_call(vim.lsp.buf.hover, 'no documentation available'), 'Show documentation')
  buf_map('<C-k>', safe_lsp_call(vim.lsp.buf.signature_help, 'no signature help available'), 'Signature help')

  -- Additional LSP keymaps not covered by which-key
  buf_map('gs', safe_lsp_call(vim.lsp.buf.document_symbol, 'no document symbols found'), 'Document symbols')
  buf_map('gS', safe_lsp_call(vim.lsp.buf.workspace_symbol, 'no workspace symbols found'), 'Workspace symbols')
  
  -- Type definition (alternative to gT used by Trouble)
  buf_map('gt', safe_lsp_call(vim.lsp.buf.type_definition, 'type definition not found'), 'Go to type definition')

  -- ============================================================================
  -- IntelliJ-like keybindings (Cmd+B equivalents)
  -- ============================================================================
  -- <leader>bb - Go to definition (like Cmd+B in IntelliJ)
  buf_map('<leader>bb', safe_lsp_call(vim.lsp.buf.definition, 'definition not found'), 'Go to definition (Cmd+B)')
  -- <leader>bi - Go to implementation (like Cmd+Alt+B in IntelliJ)
  buf_map('<leader>bi', safe_lsp_call(vim.lsp.buf.implementation, 'implementation not found'), 'Go to implementation')
  -- <leader>bt - Go to type definition (like Cmd+Shift+B in IntelliJ)
  buf_map('<leader>bt', safe_lsp_call(vim.lsp.buf.type_definition, 'type definition not found'), 'Go to type definition')
  -- <leader>br - Find usages/references (like Alt+F7 in IntelliJ)
  buf_map('<leader>br', safe_lsp_call(vim.lsp.buf.references, 'no references found'), 'Find usages/references')
  -- <leader>bs - Go to super/parent method
  buf_map('<leader>bs', function()
    vim.lsp.buf.definition() -- Will show parent class definition
  end, 'Go to super method')
end

-- Set up LSP keymaps when an LSP client attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    setup_lsp_keymaps(args.buf)
  end,
  desc = 'Set up LSP keymaps when attaching to a buffer'
})

-- ============================================================================
-- Trouble.nvim (Additional keymaps)
-- ============================================================================
-- Note: Main Trouble keymaps are defined in which-key.lua under <leader>x
-- These are additional LSP integration keymaps

create_keymap('n', 'gT', '<cmd>TroubleToggle lsp_type_definitions<CR>', 'LSP Type Definitions')
create_keymap('n', 'gI', '<cmd>TroubleToggle lsp_implementations<CR>', 'LSP Implementations')

-- ============================================================================
-- DAP (Debug Adapter Protocol)
-- ============================================================================

create_keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', 'Toggle breakpoint')
create_keymap('n', '<leader>dB', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', 'Conditional breakpoint')
create_keymap('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>', 'Continue')
create_keymap('n', '<leader>di', '<cmd>lua require"dap".step_into()<CR>', 'Step into')
create_keymap('n', '<leader>do', '<cmd>lua require"dap".step_over()<CR>', 'Step over')
create_keymap('n', '<leader>dO', '<cmd>lua require"dap".step_out()<CR>', 'Step out')
create_keymap('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<CR>', 'Toggle REPL')
create_keymap('n', '<leader>dl', '<cmd>lua require"dap".run_last()<CR>', 'Run last')
create_keymap('n', '<leader>du', '<cmd>lua require"dapui".toggle()<CR>', 'Toggle DAP UI')
create_keymap('n', '<leader>dx', '<cmd>lua require"dap".terminate()<CR>', 'Terminate debug session')

-- ============================================================================
-- Initialize Which-Key Groups
-- ============================================================================

-- Register all which-key groups at the end
register_which_key_groups()

-- Clean up conflicting default mappings that we don't use
-- Some plugins (e.g. old comment plugins) may claim "gc". We rely on <leader>/ instead,
-- so remove any existing normal-mode mapping for gc to keep which-key health clean.
pcall(vim.keymap.del, 'n', 'gc')

-- ============================================================================
-- Notes
-- ============================================================================
-- Telescope keymaps are defined in lua/plugins/telescope.lua
-- This is intentional to keep plugin-specific configuration centralized
