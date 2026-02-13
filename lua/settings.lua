-- ============================================================================
-- Performance Optimizations
-- ============================================================================
-- Disable built-in plugins we don't need
local disabled_built_ins = {
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'matchit',
  'matchparen',
  'logiPat',
  'rrhelper',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

-- Reduce update time for faster cursorhold events & better user experience
vim.opt.updatetime = 250  -- Faster completion (default 4000ms)
vim.opt.timeoutlen = 300  -- Time to wait for a mapped sequence to complete (in milliseconds)

-- ============================================================================
-- Editor Behavior
-- ============================================================================
-- Set leader keys (only set here, removed from other files)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line numbers and cursor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'  -- Only highlight line number for better performance

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Performance
vim.opt.lazyredraw = true       -- Don't redraw while executing macros (good performance config)
vim.opt.ttyfast = true          -- Faster redrawing
vim.opt.completeopt = 'menuone,noselect,noinsert'  -- Better completion experience

-- Undo and backup
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup'
vim.opt.directory = vim.fn.stdpath('state') .. '/swap'
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes:1'     -- Always show signcolumn to avoid layout shifting
vim.opt.showmode = false         -- Don't show mode since we have a statusline
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3           -- Global statusline
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8            -- Lines of context
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

-- Mouse support
vim.opt.mouse = 'a'

-- Clipboard
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard

-- File handling
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileformats = 'unix,dos,mac'

-- Better diff
vim.opt.diffopt:append('vertical')
vim.opt.diffopt:append('iwhite')
vim.opt.diffopt:append('hiddenoff')
vim.opt.diffopt:append('algorithm:patience')

-- Better wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore:append('*.o,*.obj,*.pyc,*.so,*.dll,*.zip,*.jpg,*.png,*.gif,*.pdf')

-- Better completion
vim.opt.shortmess:append('c')  -- Don't pass messages to ins-completion-menu
vim.opt.completeopt:append('menuone')
vim.opt.completeopt:append('noselect')

-- Better folding
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99  -- Start with all folds open

-- Session management
vim.opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Better grep
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

-- Disable some built-in plugins we don't need
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Better UI for messages and cmdline
vim.opt.cmdheight = 1
vim.opt.showmode = false  -- We have a statusline for this

-- Better split behavior
vim.opt.splitkeep = 'screen'

-- Better terminal behavior
vim.opt.termguicolors = true

-- Better search highlighting
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true, desc = 'Clear search highlights' })

-- Copy entire buffer to clipboard
vim.keymap.set('n', '<leader>yy', ':%y+<CR>', { silent = true, desc = 'Copy entire buffer' })

-- Better window title
vim.opt.title = true
vim.opt.titlestring = '%t - NVIM (%{expand("%:p:h")})'

-- Better file watching for projects with many files
vim.opt.backupcopy = 'yes'  -- Fix for some filesystem watchers

-- Better performance for large files
vim.opt.swapfile = false  -- Disable swap files for better performance with large files

-- Better performance for syntax highlighting
vim.opt.synmaxcol = 240  -- Don't try to highlight lines longer than 240 characters