-- Session management configuration
-- This file handles session persistence and management

local M = {}

-- Default session options
local default_opts = {
  log_level = 'info',
  auto_session_enable_last_session = true,
  auto_session_root_dir = vim.fn.stdpath('data') .. '/sessions/',
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = {
    '~/',
    '~/.config',
    '~/.local',
    '~/.cache',
    '/',
  },
  auto_session_use_git_branch = false, -- One session per project
  bypass_session_save_file_types = { 'alpha' },
  cwd_change_handling = {
    restore_upcoming_session = true,
    pre_cwd_ch_hook = nil,
    post_cwd_ch_hook = nil,
  },
  -- Performance optimizations
  auto_session_persist_tabs = true,
  auto_session_create_enabled = true,
  auto_session_enable_periodic_write = true,
  auto_session_last_session_time = 'posix',
  auto_session_all_cmds = true,
  -- UI
  session_lens = {
    load_on_setup = true,
    theme_conf = { border = true },
    previewer = true,
  },
}

-- Initialize session management
function M.setup(opts)
  local status_ok, auto_session = pcall(require, 'auto-session')
  if not status_ok then
    vim.notify('auto-session.nvim not found!', vim.log.levels.ERROR)
    return
  end

  -- Merge user options with defaults
  local options = vim.tbl_deep_extend('force', default_opts, opts or {})
  
  -- Setup auto-session
  auto_session.setup(options)
  
  -- Setup session-lens for better session management UI
  local status_ok_lens, lens = pcall(require, 'session-lens')
  if status_ok_lens then
    lens.setup({
      path_display = { 'shorten' },
      theme = 'dropdown',
      previewer = true,
      prompt_title = 'Sessions',
    })
    
    -- Keymaps for session-lens
    vim.keymap.set('n', '<leader>fs', require('session-lens').search_session, {
      noremap = true,
      silent = true,
      desc = 'Find sessions',
    })
  end
  
  -- Create necessary directories
  vim.fn.mkdir(options.auto_session_root_dir, 'p')
  
  -- Auto-save session on VimLeave
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      if vim.fn.argc() == 0 and vim.fn.getcwd() ~= vim.fn.expand('~') then
        vim.cmd('Autosession save')
      end
    end,
  })
  
  -- Keymaps for session management
  vim.keymap.set('n', '<leader>ss', '<cmd>Autosession save<CR>', {
    desc = 'Save current session',
  })
  
  vim.keymap.set('n', '<leader>sl', function()
    require('auto-session.session-lens').search_session()
  end, {
    desc = 'List sessions',
  })
  
  vim.keymap.set('n', '<leader>sd', function()
    require('auto-session.session-lens').delete_session()
  end, {
    desc = 'Delete session',
  })
  
  vim.keymap.set('n', '<leader>sr', function()
    require('auto-session.session-lens').rename_session()
  end, {
    desc = 'Rename session',
  })
  
  -- Auto-commands for better session handling
  local group = vim.api.nvim_create_augroup('SessionManagement', { clear = true })
  
  -- Auto-save on exit if in a project
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function()
      if vim.fn.argc() == 0 and vim.fn.getcwd() ~= vim.fn.expand('~') then
        vim.cmd('Autosession save')
      end
    end,
  })
  
  -- Don't auto-save for specific file types
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
    callback = function()
      vim.b.auto_session_enabled = false
    end,
  })
  
  -- Restore cursor position when opening a file
  vim.api.nvim_create_autocmd('BufReadPost', {
    group = group,
    callback = function()
      if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line('$') then
        vim.cmd('normal! g`"')
      end
    end,
  })
  
  -- Notify when session is saved
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'auto_session_loaded',
    callback = function()
      vim.notify('Session loaded: ' .. vim.fn.getcwd())
    end,
  })
  
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'auto_session_saved',
    callback = function()
      vim.notify('Session saved: ' .. vim.fn.getcwd())
    end,
  })
end

return M
