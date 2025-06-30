-- ============================================================================
-- Keymaps Configuration
-- ============================================================================
-- Centralized keybindings for Neovim
-- This file contains keybindings for core functionality and plugins not covered by which-key

-- Load utility functions
local utils = require('utils')
local map = utils.map

-- Load which-key for better keybinding management
local wk = utils.safe_require('which-key')

-- Helper function to register keymaps with which-key
local function register_keymaps(mode, prefix, keymaps, opts)
  if wk then
    wk.register(keymaps, vim.tbl_extend('force', { mode = mode, prefix = prefix }, opts or {}))
  end

  local function register_single_keymap(key, mapping, current_prefix)
    if mapping.name then
      if mapping[1] == nil then
        for k, v in pairs(mapping) do
          if type(k) == 'string' and k ~= 'name' and k ~= 'desc' and k ~= 'opts' then
            register_single_keymap(k, v, current_prefix .. key)
          end
        end
        return
      end
    end

    local cmd = mapping[1]
    if not cmd then return end

    local desc = mapping.desc or mapping[2] or ''
    local options = vim.tbl_extend('force', {
      desc = desc,
      noremap = true,
      silent = true
    }, mapping.opts or {})

    if type(cmd) == 'string' or type(cmd) == 'function' then
      map(mode, current_prefix .. key, cmd, options)
    end
  end

  for key, mapping in pairs(keymaps) do
    if type(key) == 'string' then
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

  -- Comment keybindings
  ['<leader>c'] = { name = '+Comment',
    ['c'] = { '<Plug>(comment_toggle_linewise_current)', 'Toggle line comment' },
    ['b'] = { '<Plug>(comment_toggle_blockwise_current)', 'Toggle block comment' },
    ['l'] = { '<Plug>(comment_toggle_linewise)', 'Toggle line comment (motion)' },
    ['B'] = { '<Plug>(comment_toggle_blockwise)', 'Toggle block comment (motion)' },
  },

  -- Java
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
}

-- Register general keymaps
register_keymaps('n', '', general_keymaps)
register_keymaps('v', '', {
  ['H'] = { '^', 'Go to start of line' },
  ['L'] = { '$', 'Go to end of line' },
  ['<leader>c'] = { name = '+Comment',
    ['c'] = { '<Plug>(comment_toggle_linewise_visual)', 'Toggle line comment' },
    ['b'] = { '<Plug>(comment_toggle_blockwise_visual)', 'Toggle block comment' },
  },
})

-- ============================================================================
-- Buffer Management (barbar.nvim)
-- ============================================================================
local buffer_keymaps = {
  ['<A-,>'] = { ':BufferPrevious<CR>', 'Previous buffer' },
  ['<A-.>'] = { ':BufferNext<CR>', 'Next buffer' },
  ['<A-<>'] = { ':BufferMovePrevious<CR>', 'Move buffer left' },
  ['<A->>'] = { ':BufferMoveNext<CR>', 'Move buffer right' },
  ['<A-c>'] = { ':BufferClose<CR>', 'Close buffer' },
  ['<A-p>'] = { ':BufferPin<CR>', 'Pin/Unpin buffer' },
  ['<A-1>'] = { ':BufferGoto 1<CR>', 'Go to buffer 1' },
  ['<A-2>'] = { ':BufferGoto 2<CR>', 'Go to buffer 2' },
  ['<A-3>'] = { ':BufferGoto 3<CR>', 'Go to buffer 3' },
  ['<A-4>'] = { ':BufferGoto 4<CR>', 'Go to buffer 4' },
  ['<A-5>'] = { ':BufferGoto 5<CR>', 'Go to buffer 5' },
  ['<A-6>'] = { ':BufferGoto 6<CR>', 'Go to buffer 6' },
  ['<A-7>'] = { ':BufferGoto 7<CR>', 'Go to buffer 7' },
  ['<A-8>'] = { ':BufferGoto 8<CR>', 'Go to buffer 8' },
  ['<A-9>'] = { ':BufferLast<CR>', 'Go to last buffer' },
  ['<Tab>'] = { ':BufferNext<CR>', 'Next buffer' },
  ['<S-Tab>'] = { ':BufferPrevious<CR>', 'Previous buffer' },
}

-- Register buffer keymaps
for key, mapping in pairs(buffer_keymaps) do
  map('n', key, mapping[1], { desc = mapping[2], noremap = true, silent = true })
end

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
  },
}

register_keymaps('n', '', dap_keymaps)