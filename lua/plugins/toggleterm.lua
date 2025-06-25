local M = {
  'akinsho/toggleterm.nvim',
  version = "*",
  cmd = 'ToggleTerm',
  keys = {
    -- Toggle terminal on/off
    { '<leader>tt', '<cmd>ToggleTerm<CR>', desc = 'Toggle Terminal' },
    -- Directional terminals
    { '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', desc = 'Float Terminal' },
    { '<leader>tz', '<cmd>ToggleTerm direction=horizontal<CR>', desc = 'Horizontal Terminal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', desc = 'Vertical Terminal' },
    -- Toggle between terminal and last buffer
    { '<leader>`', '<cmd>ToggleTerm<CR>', desc = 'Toggle Terminal' },
  },
  config = function()
    local toggleterm = require('toggleterm')
    
    -- Debug: Check if we're loading the config
    print('Loading toggleterm configuration...')
    
    -- Set global terminal keymaps first
    vim.cmd([[
      " Set terminal keymaps
      tnoremap <Esc> <C-\><C-n>
      tnoremap <C-v><Esc> <Esc>
      tnoremap <leader>` <C-\><C-n>:ToggleTerm<CR>
      
      " Window navigation in terminal mode
      tnoremap <C-h> <C-\><C-n><C-w>h
      tnoremap <C-j> <C-\><C-n><C-w>j
      tnoremap <C-k> <C-\><C-n><C-w>k
      tnoremap <C-l> <C-\><C-n><C-w>l
    ]])
    
    -- Set up terminal mappings
    local function setup_terminal_mappings()
      -- These mappings are set globally above, but we keep this function
      -- for any terminal-specific mappings that might be needed later
    end
    
    -- Initialize toggleterm with basic settings
    toggleterm.setup({
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
        return 20
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = 'curved',
        winblend = 10,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
      
      -- Set up terminal-specific settings when opened
      on_open = function(term)
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.cmd('startinsert')
        setup_terminal_mappings()
      end,
    })
    
    -- Set up mappings for existing terminals
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*',
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.cmd('startinsert')
        setup_terminal_mappings()
      end,
    })

    -- Custom terminal commands
    local Terminal = require('toggleterm.terminal').Terminal
    
    -- Example of a custom terminal command
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'float',
      float_opts = {
        border = 'double',
      },
      on_open = function(term)
        vim.cmd('startinsert!')
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
      end,
    })

    -- Function to toggle lazygit
    function _lazygit_toggle()
      lazygit:toggle()
    end

    -- Add custom keybindings for custom terminals
    vim.keymap.set('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', { desc = 'Lazygit' })
  end,
}

return M