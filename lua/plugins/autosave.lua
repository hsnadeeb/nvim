-- local vim = require("vim")

return {
    {
      repo = '907th/vim-auto-save',
      event = 'BufReadPost',
      init = function()
        vim.g.auto_save = 0  -- Start with auto-save disabled by default
        vim.g.auto_save_silent = 1
        vim.g.auto_save_events = { 'InsertLeave', 'TextChanged', 'FocusLost' }
        vim.g.auto_save = 0  -- Ensure auto-save is disabled by default
      end,
      config = function()
        -- Define the toggle function
        function _G.toggle_autosave()
          if vim.g.auto_save == 1 then
            vim.g.auto_save = 0
            vim.notify('Autosave: Disabled', vim.log.levels.INFO, { title = 'AutoSave' })
          else
            vim.g.auto_save = 1
            vim.notify('Autosave: Enabled', vim.log.levels.INFO, { title = 'AutoSave' })
          end
        end

        -- Create user command
        vim.api.nvim_create_user_command('AutoSaveToggle', 'lua _G.toggle_autosave()', {
          desc = 'Toggle auto-save functionality'
        })

        -- Add a keymap for toggling
        vim.keymap.set('n', '<leader>as', function()
          _G.toggle_autosave()
        end, {
          silent = true,
          noremap = true,
          desc = 'Toggle auto-save',
          nowait = true
        })

        -- Initial state notification
        vim.notify('Autosave: ' .. (vim.g.auto_save == 1 and 'Enabled' or 'Disabled'), 
                   vim.log.levels.INFO, 
                   { title = 'AutoSave' })
      end
    },
  }