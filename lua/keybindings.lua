-- ============================================================================
-- Keymaps Configuration
-- ============================================================================
-- Centralized keybindings for Neovim
-- This file contains all keybindings for core functionality and plugins

-- Load utility functions
local utils = require('utils')
local map = utils.map

-- Function to clean up problematic keymaps
local function cleanup_keymaps()
  -- Function to safely unmap keys using multiple methods
  local function safe_unmap(mode, key)
    -- Try to get the current mapping first
    local ok, result = pcall(vim.api.nvim_get_keymap, mode)
    if ok then
      for _, map in ipairs(result) do
        if map.lhs == key then
          -- Try the new API first
          pcall(vim.keymap.del, mode, key)
          -- Then try the old API
          pcall(vim.api.nvim_del_keymap, mode, key)
          -- Finally try the vim.cmd way
          local mode_prefix = mode == 'n' and 'n' or mode
          pcall(vim.cmd, string.format('%sunmap %s', mode_prefix, key))
        end
      end
    end
  end

  -- List of problematic keys to clean up
  local keys_to_clean = {
    {mode = 'n', key = 'gc'},
    {mode = 'v', key = 'gc'},
    {mode = 'n', key = 'gb'},
    {mode = 'v', key = 'gb'},
    {mode = 'n', key = ' e'},
    {mode = 'n', key = 'e'},
  }

  -- Clean up each key
  for _, item in ipairs(keys_to_clean) do
    safe_unmap(item.mode, item.key)
  end

  -- Set explicit no-op mappings to prevent warnings
  vim.keymap.set('n', ' e', function() end, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Disabled keymap'
  })

  vim.keymap.set('n', 'e', function() end, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Disabled keymap'
  })
end

-- Run keymap cleanup when this file is loaded
cleanup_keymaps()

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
  
  -- Navigation
  ['H'] = { '^', 'Go to start of line' },
  ['L'] = { '$', 'Go to end of line' },
  
  -- Git keybindings (non-conflicting only)
  ['<leader>g'] = { name = '+Git',
    ['b'] = { name = '+Buffer',
      ['r'] = { '<Cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
      ['R'] = { '<Cmd>Gitsigns reset_buffer<CR>', 'Reset buffer' },
      ['s'] = { '<Cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
      ['S'] = { '<Cmd>Gitsigns stage_buffer<CR>', 'Stage buffer' },
      ['u'] = { '<Cmd>Gitsigns undo_stage_hunk<CR>', 'Unstage hunk' },
    },
  },
  
  -- No need to unset keymaps here, we'll handle it in the which-key configuration
  
  -- Java specific commands
  ['<leader>j'] = { name = '+Java',
    ['r'] = { 
      function()
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
      end, 
      'Compile and run Java file' 
    },
  },
  
  -- Quickfix list navigation (non-conflicting)
  [']q'] = { ':cnext<CR>', 'Next quickfix item' },
  ['[q'] = { ':cprev<CR>', 'Previous quickfix item' },
}

-- Register general keymaps (only non-conflicting ones)
register_keymaps('n', '', general_keymaps)

-- Visual mode keymaps
register_keymaps('v', '', {
  ['H'] = { '^', 'Go to start of line' },
  ['L'] = { '$', 'Go to end of line' },
})

-- Window navigation (using which-key for better discoverability)
local wk_ok, wk = pcall(require, 'which-key')
if wk_ok then
  wk.register({
    w = {
      name = '+window',
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

-- Basic window navigation (kept for convenience)
map('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move to window below' })
map('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move to window above' })
map('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to right window' })

-- Line navigation (simplified to avoid conflicts)
map('n', 'H', '^', { noremap = true, silent = true, desc = 'Go to start of line' })
map('n', 'L', '$', { noremap = true, silent = true, desc = 'Go to end of line' })
map('v', 'H', '^', { noremap = true, silent = true, desc = 'Go to start of line' })
map('v', 'L', '$', { noremap = true, silent = true, desc = 'Go to end of line' })

-- ============================================================================
-- Buffer Management (barbar.nvim)
-- ============================================================================
-- Buffer navigation with Alt keys (primary)
local buffer_keymaps = {
  ['<A-,>'] = { ':BufferPrevious<CR>', 'Previous buffer' },
  ['<A-.>'] = { ':BufferNext<CR>', 'Next buffer' },
  ['<A-<>'] = { ':BufferMovePrevious<CR>', 'Move buffer left' },
  ['<A->>'] = { ':BufferMoveNext<CR>', 'Move buffer right' },
  ['<A-c>'] = { ':BufferClose<CR>', 'Close buffer' },
  ['<A-p>'] = { ':BufferPin<CR>', 'Pin/Unpin buffer' },
  
  -- Quick buffer navigation with Alt+number
  ['<A-1>'] = { ':BufferGoto 1<CR>', 'Go to buffer 1' },
  ['<A-2>'] = { ':BufferGoto 2<CR>', 'Go to buffer 2' },
  ['<A-3>'] = { ':BufferGoto 3<CR>', 'Go to buffer 3' },
  ['<A-4>'] = { ':BufferGoto 4<CR>', 'Go to buffer 4' },
  ['<A-5>'] = { ':BufferGoto 5<CR>', 'Go to buffer 5' },
  ['<A-6>'] = { ':BufferGoto 6<CR>', 'Go to buffer 6' },
  ['<A-7>'] = { ':BufferGoto 7<CR>', 'Go to buffer 7' },
  ['<A-8>'] = { ':BufferGoto 8<CR>', 'Go to buffer 8' },
  ['<A-9>'] = { ':BufferLast<CR>', 'Go to last buffer' },
  
  -- Alternative buffer navigation (secondary)
  ['<Tab>'] = { ':BufferNext<CR>', 'Next buffer' },
  ['<S-Tab>'] = { ':BufferPrevious<CR>', 'Previous buffer' },
  
  -- Alternative close buffer
  ['<leader>bd'] = { ':BufferClose<CR>', 'Delete buffer' },
  
  -- Close current buffer (alternative to :q)
  ['<leader>q'] = { ':BufferClose<CR>', 'Close buffer' },
  
  -- Force close current buffer
  ['<leader>Q'] = { ':BufferClose!<CR>', 'Force close buffer' },
  
  -- Save and close buffer
  ['<leader>wq'] = { ':w | BufferClose<CR>', 'Save and close buffer' },
}

-- Register buffer keymaps
for key, mapping in pairs(buffer_keymaps) do
  map('n', key, mapping[1], { desc = mapping[2] })
end

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
-- Telescope keymaps are defined in lua/plugins/telescope.lua
-- This is intentional to keep all Telescope-related configuration in one place
-- and avoid conflicts between different parts of the configuration.

-- ============================================================================
-- LSP Keymaps
-- ============================================================================
local function lsp_keymaps(bufnr)
  local lsp_keymaps = {
    -- Navigation
    ['gD'] = {
      function()
        local ok, _ = pcall(vim.lsp.buf.declaration)
        if not ok then
          vim.notify('LSP: declaration not found', vim.log.levels.INFO)
        end
      end,
      'Go to declaration'
    },
    ['gd'] = {
      function()
        local ok, _ = pcall(vim.lsp.buf.definition)
        if not ok then
          vim.notify('LSP: definition not found', vim.log.levels.INFO)
        end
      end,
      'Go to definition'
    },
    ['gi'] = {
      function()
        local ok, _ = pcall(vim.lsp.buf.implementation)
        if not ok then
          vim.notify('LSP: implementation not found', vim.log.levels.INFO)
        end
      end,
      'Go to implementation'
    },
    ['gr'] = {
      function()
        local ok, _ = pcall(vim.lsp.buf.references)
        if not ok then
          vim.notify('LSP: no references found', vim.log.levels.INFO)
        end
      end,
      'Show references'
    },
    ['K'] = {
      function()
        local ok, _ = pcall(vim.lsp.buf.hover)
        if not ok then
          vim.notify('LSP: no documentation available', vim.log.levels.INFO)
        end
      end,
      'Show documentation'
    },
    ['<C-k>'] = {
      function()
        local ok, _ = pcall(vim.lsp.buf.signature_help)
        if not ok then
          vim.notify('LSP: no signature help available', vim.log.levels.INFO)
        end
      end,
      'Signature help'
    },
    
    -- Code actions and refactoring
    ['<leader>c'] = { name = '+Code',
      ['a'] = {
        function()
          local ok, _ = pcall(vim.lsp.buf.code_action)
          if not ok then
            vim.notify('LSP: no code actions available', vim.log.levels.INFO)
          end
        end,
        'Code actions'
      },
      ['r'] = {
        function()
          local ok, _ = pcall(vim.lsp.buf.rename)
          if not ok then
            vim.notify('LSP: rename not supported', vim.log.levels.INFO)
          end
        end,
        'Rename symbol'
      },
      ['f'] = {
        function()
          local ok, _ = pcall(vim.lsp.buf.format, { async = true })
          if not ok then
            vim.notify('LSP: formatting not supported', vim.log.levels.INFO)
          end
        end,
        'Format buffer'
      },
    },
    
    -- Documentation and diagnostics
    ['<leader>d'] = { name = '+Diagnostics',
      ['d'] = {
        function()
          local ok, _ = pcall(vim.diagnostic.open_float)
          if not ok then
            vim.notify('No diagnostics available', vim.log.levels.INFO)
          end
        end,
        'Show line diagnostics'
      },
      ['p'] = {
        function()
          local ok, _ = pcall(vim.diagnostic.goto_prev)
          if not ok then
            vim.notify('No previous diagnostic', vim.log.levels.INFO)
          end
        end,
        'Previous diagnostic',
      },
      ['n'] = {
        function()
          local ok, _ = pcall(vim.diagnostic.goto_next)
          if not ok then
            vim.notify('No next diagnostic', vim.log.levels.INFO)
          end
        end,
        'Next diagnostic',
      },
      ['l'] = { ':Telescope diagnostics<CR>', 'List all diagnostics' },
      ['q'] = { vim.diagnostic.setloclist, 'Add to location list' },
    },
    
    -- Workspace
    ['<leader>lw'] = { name = '+Workspace',
      ['a'] = {
        function()
          local ok, _ = pcall(vim.lsp.buf.add_workspace_folder)
          if not ok then
            vim.notify('LSP: failed to add workspace folder', vim.log.levels.INFO)
          end
        end,
        'Add folder'
      },
      ['r'] = {
        function()
          local ok, _ = pcall(vim.lsp.buf.remove_workspace_folder)
          if not ok then
            vim.notify('LSP: failed to remove workspace folder', vim.log.levels.INFO)
          end
        end,
        'Remove folder'
      },
      ['l'] = {
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        'List folders'
      },
    },
  }
  
  -- Register LSP keymaps for the current buffer
  for keys, mapping in pairs(lsp_keymaps) do
    local cmd = mapping[1]
    local desc = mapping.desc or mapping[2]
    local opts = {
      buffer = bufnr,
      desc = desc,
      noremap = true,
      silent = true,
      nowait = true
    }
    
    -- Handle nested keymaps (which-key groups)
    if mapping.name and type(cmd) ~= 'function' and type(cmd) ~= 'string' then
      if wk_ok then
        wk.register({
          [keys] = { name = mapping.name }
        }, { mode = 'n', prefix = '', buffer = bufnr })
      end
      
      -- Register child keymaps
      if type(cmd) == 'table' then
        for k, v in pairs(cmd) do
          if type(k) == 'string' and k ~= 'name' and k ~= 'desc' and k ~= 'opts' then
            local child_cmd = v[1]
            local child_desc = v.desc or v[2]
            local child_opts = vim.tbl_extend('force', opts, {
              desc = child_desc,
              buffer = bufnr
            })
            
            if type(child_cmd) == 'function' then
              vim.keymap.set('n', keys .. k, child_cmd, child_opts)
            elseif type(child_cmd) == 'string' then
              vim.keymap.set('n', keys .. k, child_cmd, vim.tbl_extend('force', child_opts, { expr = false }))
            end
          end
        end
      end
    else
      -- Regular keymap
      if type(cmd) == 'function' then
        vim.keymap.set('n', keys, cmd, opts)
      elseif type(cmd) == 'string' then
        vim.keymap.set('n', keys, cmd, vim.tbl_extend('force', opts, { expr = false }))
      end
    end
  end
  
  -- Register which-key groups if available
  if wk_ok then
    wk.register({
      ['<leader>c'] = { name = '+Code' },
      ['<leader>d'] = { name = '+Diagnostics' },
    }, { buffer = bufnr })
  end
end

-- Set up LSP keymaps when an LSP client attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    
    -- Only set up keymaps if this is the first LSP client for this buffer
    if not vim.tbl_contains(vim.lsp.get_clients({ buffer = bufnr }), client) then
      lsp_keymaps(bufnr, client)
    end
  end,
  desc = 'Set up LSP keymaps when attaching to a buffer'
})

-- ============================================================================
-- Git Keymaps (Moved to which-key.lua for centralized management)
-- ============================================================================
-- Note: Git keybindings are now managed in plugins/which-key.lua

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