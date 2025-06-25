local M = {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  event = 'BufRead',
  keys = {
    -- Buffer navigation
    { '<S-Tab>', '<cmd>BufferPrevious<CR>', desc = 'Previous buffer' },
    { '<Tab>', '<cmd>BufferNext<CR>', desc = 'Next buffer' },
    { '<A-,>', '<cmd>BufferPrevious<CR>', desc = 'Previous buffer' },
    { '<A-.>', '<cmd>BufferNext<CR>', desc = 'Next buffer' },
    { '<A-<>', '<cmd>BufferMovePrevious<CR>', desc = 'Move buffer left' },
    { '<A->>', '<cmd>BufferMoveNext<CR>', desc = 'Move buffer right' },
    { '<A-1>', '<cmd>BufferGoto 1<CR>', desc = 'Go to buffer 1' },
    { '<A-2>', '<cmd>BufferGoto 2<CR>', desc = 'Go to buffer 2' },
    { '<A-3>', '<cmd>BufferGoto 3<CR>', desc = 'Go to buffer 3' },
    { '<A-4>', '<cmd>BufferGoto 4<CR>', desc = 'Go to buffer 4' },
    { '<A-5>', '<cmd>BufferGoto 5<CR>', desc = 'Go to buffer 5' },
    { '<A-6>', '<cmd>BufferGoto 6<CR>', desc = 'Go to buffer 6' },
    { '<A-7>', '<cmd>BufferGoto 7<CR>', desc = 'Go to buffer 7' },
    { '<A-8>', '<cmd>BufferGoto 8<CR>', desc = 'Go to buffer 8' },
    { '<A-9>', '<cmd>BufferLast<CR>', desc = 'Go to last buffer' },
    
    -- Fallback keybindings
    { '<S-h>', '<cmd>BufferPrevious<CR>', desc = 'Previous buffer' },
    { '<S-l>', '<cmd>BufferNext<CR>', desc = 'Next buffer' },
    { '<leader>bd', '<cmd>BufferClose<CR>', desc = 'Delete buffer' },
    { '<leader>bc', '<cmd>BufferClose<CR>', desc = 'Close current buffer' },
    { '<C-w>c', '<cmd>BufferClose<CR>', desc = 'Close current buffer' },
  },
  opts = {
    -- Set options here
    animation = true,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    focus_on_close = 'left', -- or 'right' or 'previous'
    hide = { extensions = true, inactive = false },
    highlight_visible = true,
    icons = {
      buffer_index = true,
      buffer_number = false,
      button = '✕', -- Close button
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = ' ' },
        [vim.diagnostic.severity.WARN] = { enabled = true, icon = ' ' },
        [vim.diagnostic.severity.INFO] = { enabled = true, icon = ' ' },
        [vim.diagnostic.severity.HINT] = { enabled = true, icon = ' ' },
      },
      filetype = {
        custom_colors = true,
        enabled = true,
      },
      separator = { left = '▎', right = '' },
      modified = { button = '●' },
      pinned = { button = '車', filename = true },
      alternate = { filetype = { enabled = false } },
      current = { buffer_index = true },
      inactive = { button = '×' },
    },
    icon_custom_colors = false,
    icon_pinned = '📌',
    insert_at_end = false,
    insert_at_start = false,
    maximum_padding = 4,
    minimum_padding = 1,
    maximum_length = 30,
    semantic_letters = true,
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
    no_name_title = '[No Name]',
  },
  config = function(_, opts)
    -- Set up barbar with options
    require('barbar').setup(opts)

    -- Close buffer and switch to previous buffer
    vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>BufferClose<CR>', { noremap = true, silent = true })

    -- Close all buffers except current
    vim.api.nvim_set_keymap('n', '<leader>bo', '<cmd>BufferCloseAllButCurrent<CR>', 
      { noremap = true, silent = true, desc = 'Close other buffers' })

    -- Close all buffers to the right of current buffer
    vim.api.nvim_set_keymap('n', '<leader>br', '<cmd>BufferCloseBuffersRight<CR>', 
      { noremap = true, silent = true, desc = 'Close buffers to the right' })

    -- Close all buffers to the left of current buffer
    vim.api.nvim_set_keymap('n', '<leader>bl', '<cmd>BufferCloseBuffersLeft<CR>', 
      { noremap = true, silent = true, desc = 'Close buffers to the left' })

    -- Sort buffers by directory
    vim.api.nvim_set_keymap('n', '<leader>bsd', '<cmd>BufferOrderByDirectory<CR>', 
      { noremap = true, silent = true, desc = 'Sort by directory' })

    -- Sort buffers by language server
    vim.api.nvim_set_keymap('n', '<leader>bsl', '<cmd>BufferOrderByLanguage<CR>', 
      { noremap = true, silent = true, desc = 'Sort by language' })

    -- Sort buffers by window number
    vim.api.nvim_set_keymap('n', '<leader>bsw', '<cmd>BufferOrderByWindowNumber<CR>', 
      { noremap = true, silent = true, desc = 'Sort by window' })
  end
}

return M
