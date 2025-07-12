local vim = require('vim')
return {
    repo = 'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    event = 'VeryLazy',
    keys = {
    --   { '<leader>mp', '<cmd>PeekToggle<CR>', desc = 'Toggle Markdown Preview' },
    --   { '<leader>ms', '<cmd>PeekClose<CR>', desc = 'Close Markdown Preview' },
      { '<leader>mp', "<cmd>PeekToggle<CR>", "Toggle Markdown Preview" },
      { '<leader>ms', "<cmd>PeekClose<CR>", "Close Markdown Preview" },
    },
    config = function()
      -- Configure peek.nvim
      require('peek').setup({
        auto_load         = true,          -- Automatically load the plugin
        close_on_bdelete  = true,          -- Close preview when buffer is deleted
        syntax            = true,          -- Enable syntax highlighting
        theme             = 'dark',        -- Theme for the preview window
        update_on_change  = true,          -- Update preview on buffer changes
        app               = 'webview',     -- Rendering backend
        filetype          = { 'markdown', 'html' },-- Filetypes to preview
        throttle_at       = 200000,        -- Start throttling when file exceeds this size (bytes)
        throttle_time     = 'auto',        -- Minimum time between renders (ms)
      })
  
      -- Create user commands
      vim.api.nvim_create_user_command('PeekOpen', function()
        require('peek').open()
      end, {})
  
      vim.api.nvim_create_user_command('PeekClose', function()
        require('peek').close()
      end, {})
  
      vim.api.nvim_create_user_command('PeekToggle', function()
        local peek = require('peek')
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end, {})
  
      -- Auto-close preview when leaving a markdown buffer
      vim.api.nvim_create_autocmd('BufWinLeave', {
        pattern = '*.md',
        callback = function()
          local peek = require('peek')
          if peek.is_open() then
            peek.close()
          end
        end,
      })
    end,
  }