local M = {}

-- Configure telescope with minimal settings
function M.setup()
  local status_ok, telescope = pcall(require, "telescope")
  if not status_ok then
    vim.notify("Telescope not found!", vim.log.levels.ERROR)
    return
  end
  
  -- Basic configuration
  telescope.setup({
    defaults = {
      -- Disable telescope's treesitter preview integration (it relies on modules removed in newer nvim-treesitter).
      preview = { treesitter = false },
      prompt_prefix = "   ",
      selection_caret = "  ",
      path_display = { "truncate" },
      file_ignore_patterns = {
        "^%.git/",
        "^node_modules/",
        "^%.DS_Store$",
        "^target/"
      },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<C-c>"] = "close"
        },
        n = {
          ["q"] = "close"
        }
      }
    }
  })
  
  -- Set up keybindings
  local builtin = require("telescope.builtin")
  
  -- Simple file finder
  vim.keymap.set('n', '<leader>ff', function()
    builtin.find_files({
      hidden = true,
      no_ignore = false,
      follow = true
    })
  end, { desc = 'Find Files' })
  
  -- Live grep
  vim.keymap.set('n', '<leader>fg', function()
    builtin.live_grep({
      hidden = true,
      no_ignore = false
    })
  end, { desc = 'Live Grep' })
  
  -- Other useful pickers
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help' })
  
  -- Better buffer closing
  vim.keymap.set('n', '<leader>bd', function()
    local buf_utils = require('telescope.utils.buffer')
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    
    -- If it's a special buffer, just close it
    if filetype == 'NvimTree' or filetype == 'TelescopePrompt' then
      vim.cmd('bdelete')
      return
    end
    
    -- For regular buffers, close and show the next buffer
    local bufs = vim.fn.getbufinfo({buflisted = 1})
    if #bufs > 1 then
      vim.cmd('bnext')
      vim.cmd('bdelete ' .. bufnr)
    else
      vim.cmd('bdelete')
    end
  end, { desc = 'Close Buffer' })
  
  -- Load fzf extension if available
  pcall(function()
    telescope.load_extension('fzf')
  end)
  
  -- NOTE: telescope-dap disabled for stability (see plugins.lua).
  
  -- Project extension
  vim.keymap.set('n', '<leader>pp', function()
    require('telescope').extensions.project.project({
      display_type = 'minimal',
      layout_config = {
        width = 0.9,
        height = 0.8,
      },
    })
  end, { desc = 'Projects' })
  
  -- Register which-key descriptions
  local wk_ok, wk = pcall(require, 'which-key')
  if wk_ok then
    wk.register({
      f = { name = 'Find' },
      g = { name = 'Git' },
      p = { name = 'Project' },
    }, { prefix = '<leader>' })
  end
end

return M
 