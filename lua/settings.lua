-- Performance Optimizations

local disabled_built_ins = {
  'gzip', 'zip', 'zipPlugin', 'tar', 'tarPlugin',
  'getscript', 'getscriptPlugin', 'vimball', 'vimballPlugin',
  '2html_plugin', 'matchit', 'matchparen', 'logiPat', 'rrhelper',
  'netrw', 'netrwPlugin', 'netrwSettings', 'netrwFileHandlers',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Editor Behavior
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.lazyredraw = true
vim.opt.ttyfast = true
vim.opt.completeopt = 'menuone,noselect,noinsert'

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup'
vim.opt.directory = vim.fn.stdpath('state') .. '/swap'
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes:1'
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileformats = 'unix,dos,mac'

vim.opt.diffopt:append('vertical,iwhite,hiddenoff,algorithm:patience')
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore:append('*.o,*.obj,*.pyc,*.so,*.dll,*.zip,*.jpg,*.png,*.gif,*.pdf')
vim.opt.shortmess:append('c')
vim.opt.completeopt:append('menuone,noselect')
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

vim.opt.splitkeep = 'screen'
vim.opt.title = true
vim.opt.titlestring = '%t - NVIM (%{expand("%:p:h")})'
vim.opt.backupcopy = 'yes'
vim.opt.swapfile = false
vim.opt.synmaxcol = 240