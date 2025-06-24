-- ============================================================================
-- Keymaps Configuration
-- ============================================================================
-- Centralized keybindings for Neovim
-- This file contains all keybindings for core functionality and plugins

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
-- General Keymaps
-- ============================================================================

-- Leader key configuration
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- General keymaps
local general_keymaps = {
  -- Window navigation
  ['<C-h>'] = { '<C-w>h', 'Move to left window' },
  ['<C-j>'] = { '<C-w>j', 'Move to window below' },
  ['<C-k>'] = { '<C-w>k', 'Move to window above' },
  ['<C-l>'] = { '<C-w>l', 'Move to right window' },
  
  -- IntelliJ-style navigation
  ['<leader>['] = { '<C-o>', 'Go to previous cursor position' },
  ['<leader>]'] = { '<C-i>', 'Go to next cursor position' },
  
  -- Resize windows
  ['<C-Up>'] = { ':resize -2<CR>', 'Decrease window height' },
  ['<C-Down>'] = { ':resize +2<CR>', 'Increase window height' },
  ['<C-Left>'] = { ':vertical resize -2<CR>', 'Decrease window width' },
  ['<C-Right>'] = { ':vertical resize +2<CR>', 'Increase window width' },
  
  -- Navigation
  ['H'] = { '^', 'Go to start of line' },
  ['L'] = { '$', 'Go to end of line' },
  ['<Home>'] = { '^', 'Go to start of line' },
  ['<End>'] = { '$', 'Go to end of line' },
  ['<leader>h'] = { ':nohlsearch<CR>', 'Clear search highlights' },
  
  -- File operations
  ['<leader>w'] = { ':w<CR>', 'Save file' },
  ['<leader>wq'] = { ':wq<CR>', 'Save and quit' },
  ['<leader>q'] = { ':q<CR>', 'Quit' },
  ['<leader>Q'] = { ':q!<CR>', 'Force quit' },
  
  -- Comment keybindings (using <leader>c prefix to avoid conflicts)
  ['<leader>c'] = { name = '+Comment',
    ['c'] = { '<Plug>(comment_toggle_linewise_current)', 'Toggle line comment' },
    ['b'] = { '<Plug>(comment_toggle_blockwise_current)', 'Toggle block comment' },
    ['l'] = { '<Plug>(comment_toggle_linewise)', 'Toggle line comment (motion)' },
    ['B'] = { '<Plug>(comment_toggle_blockwise)', 'Toggle block comment (motion)' },
  },
  
  -- Git keybindings
  ['<leader>g'] = { name = '+Git',
    ['b'] = { name = '+Buffer',
      ['l'] = { '<Cmd>Gitsigns blame_line<CR>', 'Blame line' },
      ['p'] = { '<Cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
      ['r'] = { '<Cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
      ['R'] = { '<Cmd>Gitsigns reset_buffer<CR>', 'Reset buffer' },
      ['s'] = { '<Cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
      ['S'] = { '<Cmd>Gitsigns stage_buffer<CR>', 'Stage buffer' },
      ['u'] = { '<Cmd>Gitsigns undo_stage_hunk<CR>', 'Unstage hunk' },
    },
  },
  
  -- Theme toggling
  ['<leader>t'] = { name = '+Terminal/Theme',
    ['t'] = { name = '+Theme',
      ['n'] = { function() require('plugins.themes').next_theme() end, 'Next theme' },
      ['p'] = { function() require('plugins.themes').prev_theme() end, 'Previous theme' },
    },
    ['f'] = { ':ToggleTerm direction=float<CR>', 'Floating terminal' },
    ['h'] = { ':ToggleTerm direction=horizontal<CR>', 'Horizontal terminal' },
    ['v'] = { ':ToggleTerm direction=vertical<CR>', 'Vertical terminal' },
    ['\\'] = { ':ToggleTerm<CR>', 'Toggle terminal' },
  },
  
  -- Buffers
  ['<leader>b'] = { name = '+Buffer',
    ['n'] = { ':bnext<CR>', 'Next buffer' },
    ['p'] = { ':bprevious<CR>', 'Previous buffer' },
    ['d'] = { ':bdelete<CR>', 'Delete buffer' },
  },
  
  -- Quickfix list
  [']q'] = { ':cnext<CR>', 'Next quickfix item' },
  ['[q'] = { ':cprev<CR>', 'Previous quickfix item' },
  ['<leader>q'] = { name = '+Quickfix',
    ['o'] = { ':copen<CR>', 'Open quickfix list' },
    ['c'] = { ':cclose<CR>', 'Close quickfix list' },
  },
}

-- Register general keymaps
register_keymaps('n', '', general_keymaps)
register_keymaps('v', '', {
  ['H'] = { '^', 'Go to start of line' },
  ['L'] = { '$', 'Go to end of line' },
  -- Visual mode comment keybindings
  ['<leader>c'] = { name = '+Comment',
    ['c'] = { '<Plug>(comment_toggle_linewise_visual)', 'Toggle line comment' },
    ['b'] = { '<Plug>(comment_toggle_blockwise_visual)', 'Toggle block comment' },
  },
})

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
local telescope_keymaps = {
  ['<leader>f'] = { name = '+Find',
    ['f'] = { '<cmd>Telescope find_files<CR>', 'Find files' },
    ['g'] = { '<cmd>Telescope live_grep<CR>', 'Live grep' },
    ['b'] = { '<cmd>Telescope buffers<CR>', 'Find buffer' },
    ['h'] = { '<cmd>Telescope help_tags<CR>', 'Find help' },
    ['r'] = { '<cmd>Telescope oldfiles<CR>', 'Recent files' },
    ['t'] = { '<cmd>Telescope<CR>', 'Telescope' },
  },
  ['<leader>g'] = { name = '+Git',
    ['g'] = { '<cmd>Telescope git_commits<CR>', 'Git commits' },
    ['c'] = { '<cmd>Telescope git_bcommits<CR>', 'Git commits (buffer)' },
    ['b'] = { '<cmd>Telescope git_branches<CR>', 'Git branches' },
    ['s'] = { '<cmd>Telescope git_status<CR>', 'Git status' },
  },
}

register_keymaps('n', '', telescope_keymaps)

-- ============================================================================
-- LSP Keymaps
-- ============================================================================
local function lsp_keymaps(bufnr)
  local lsp_keymaps = {
    -- Navigation
    ['gD'] = { function() vim.lsp.buf.declaration() end, 'Go to declaration' },
    ['gd'] = { function() vim.lsp.buf.definition() end, 'Go to definition' },
    ['gi'] = { function() vim.lsp.buf.implementation() end, 'Go to implementation' },
    ['gr'] = { function() vim.lsp.buf.references() end, 'Show references' },
    ['K'] = { function() vim.lsp.buf.hover() end, 'Show documentation' },
    ['<C-k>'] = { function() vim.lsp.buf.signature_help() end, 'Signature help' },
    
    -- Code actions
    ['<leader>la'] = { function() vim.lsp.buf.code_action() end, 'Code action' },
    ['<leader>lr'] = { function() vim.lsp.buf.rename() end, 'Rename symbol' },
    ['<leader>lf'] = { function() vim.lsp.buf.format({ async = true }) end, 'Format document' },
    
    -- Workspace
    ['<leader>lw'] = { name = '+Workspace',
      ['a'] = { function() vim.lsp.buf.add_workspace_folder() end, 'Add folder' },
      ['r'] = { function() vim.lsp.buf.remove_workspace_folder() end, 'Remove folder' },
      ['l'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List folders' },
    },
    
    -- Diagnostics
    ['<leader>ld'] = { function() vim.diagnostic.open_float() end, 'Show line diagnostics' },
    [']d'] = { function() vim.diagnostic.goto_next() end, 'Next diagnostic' },
    ['[d'] = { function() vim.diagnostic.goto_prev() end, 'Previous diagnostic' },
  }
  
  -- Register LSP keymaps for the current buffer
  for key, mapping in pairs(lsp_keymaps) do
    -- Skip which-key menu items (they have a 'name' field)
    if mapping.name == nil then
      local cmd = mapping[1]
      local desc = mapping[2] or mapping.desc
      local mode = mapping.mode or 'n'
      local opts = vim.tbl_extend('force', {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = desc
      }, mapping.opts or {})
      
      -- Only set the keymap if we have a valid command
      if type(cmd) == 'function' or (type(cmd) == 'table' and cmd[1] ~= nil) then
        vim.keymap.set(mode, key, cmd, opts)
      end
    end
  end
  
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end

-- Set up LSP keymaps when a language server attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    lsp_keymaps(ev.buf)
  end,
})

-- ============================================================================
-- Git Keymaps
-- ============================================================================
local gitsigns_keymaps = {
  ['<leader>g'] = { name = '+Git',
    ['s'] = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
    ['u'] = { '<cmd>Gitsigns undo_stage_hunk<CR>', 'Undo stage hunk' },
    ['r'] = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
    ['S'] = { '<cmd>Gitsigns stage_buffer<CR>', 'Stage buffer' },
    ['R'] = { '<cmd>Gitsigns reset_buffer<CR>', 'Reset buffer' },
    ['p'] = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
    ['b'] = { '<cmd>Gitsigns blame_line<CR>', 'Blame line' },
    ['d'] = { '<cmd>Gitsigns diffthis<CR>', 'Diff this' },
    [']c'] = { '<cmd>Gitsigns next_hunk<CR>', 'Next hunk' },
    ['[c'] = { '<cmd>Gitsigns prev_hunk<CR>', 'Previous hunk' },
  },
}

register_keymaps('n', '', gitsigns_keymaps)

-- ============================================================================
-- Trouble.nvim (Diagnostics)
-- ============================================================================
local trouble_keymaps = {
  ['<leader>x'] = { name = '+Trouble',
    ['x'] = { '<cmd>TroubleToggle<CR>', 'Toggle' },
    ['w'] = { '<cmd>TroubleToggle workspace_diagnostics<CR>', 'Workspace diagnostics' },
    ['d'] = { '<cmd>TroubleToggle document_diagnostics<CR>', 'Document diagnostics' },
    ['q'] = { '<cmd>TroubleToggle quickfix<CR>', 'Quickfix list' },
    ['l'] = { '<cmd>TroubleToggle loclist<CR>', 'Location list' },
    ['e'] = { '<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.ERROR<CR>', 'Show only errors' },
    ['W'] = { '<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.WARN<CR>', 'Show only warnings' },
  },
  -- LSP integration
  ['gR'] = { '<cmd>TroubleToggle lsp_references<CR>', 'LSP References' },
  ['gD'] = { '<cmd>TroubleToggle lsp_definitions<CR>', 'LSP Definitions' },
  ['gT'] = { '<cmd>TroubleToggle lsp_type_definitions<CR>', 'LSP Type Definitions' },
  ['gI'] = { '<cmd>TroubleToggle lsp_implementations<CR>', 'LSP Implementations' },
}

register_keymaps('n', '', trouble_keymaps)

-- ============================================================================
-- DAP (Debug Adapter Protocol)
-- ============================================================================
local dap_keymaps = {
  ['<leader>d'] = { name = '+Debug',
    ['b'] = { '<cmd>lua require"dap".toggle_breakpoint()<CR>', 'Toggle breakpoint' },
    ['B'] = { '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', 'Conditional breakpoint' },
    ['c'] = { '<cmd>lua require"dap".continue()<CR>', 'Continue' },
    ['i'] = { '<cmd>lua require"dap".step_into()<CR>', 'Step into' },
    ['o'] = { '<cmd>lua require"dap".step_over()<CR>', 'Step over' },
    ['O'] = { '<cmd>lua require"dap".step_out()<CR>', 'Step out' },
    ['r'] = { '<cmd>lua require"dap".repl.toggle()<CR>', 'Toggle REPL' },
    ['l'] = { '<cmd>lua require"dap".run_last()<CR>', 'Run last' },
    ['u'] = { '<cmd>lua require"dapui".toggle()<CR>', 'Toggle UI' },
    ['x'] = { '<cmd>lua require"dap".terminate()<CR>', 'Terminate' },
  }
}

register_keymaps('n', '', dap_keymaps)

-- ============================================================================
-- Which-key Configuration
-- ============================================================================
if wk then
  -- Register which-key menu structure
  wk.register({
    ['<leader>'] = {
      f = { name = '+Find' },
      g = { name = '+Git' },
      l = { name = '+LSP' },
      d = { name = '+Debug' },
      x = { name = '+Trouble' },
      t = { name = '+Terminal' },
    },
  })
end