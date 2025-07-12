-- local vim = require("vim")

return {
    {
      repo = 'numToStr/Comment.nvim',
      event = 'VeryLazy',
      keys = {
        { '<leader>/', mode = { 'n', 'v' }, desc = 'Toggle comment' },
      },
      config = function()
        local status_ok, comment = pcall(require, 'Comment')
        if not status_ok then
          vim.notify('Comment.nvim not found!', vim.log.levels.ERROR)
          return
        end
        comment.setup({
          padding = true,
          sticky = true,
          ignore = '^$',
          toggler = {
            line = '<leader>/',
            block = '<leader>/',
          },
          opleader = {
            line = '<leader>/',
            block = '<leader>/',
          },
          -- Disable all default keymaps
          mappings = {
            basic = false,
            extra = false,
            extended = false,
          },
          -- Explicitly disable any default keymaps that might conflict
          pre_hook = function(ctx)
            -- This ensures no default keymaps are set up
            local utils = require('Comment.utils')
            if not (ctx.cmotion or ctx.ctype == utils.ctype.linewise or ctx.ctype == utils.ctype.block) then
              return
            end
          end,
        })
        local api = require('Comment.api')
        vim.keymap.set('n', '<leader>/', api.toggle.linewise.current, { desc = 'Toggle comment' })
        vim.keymap.set('v', '<leader>/', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
          { silent = true, desc = 'Toggle comment' })
        local comment_ft = require('Comment.ft')
        comment_ft.set('lua', { '-- %s', '--[[%s]]' })
        comment_ft.set('vim', { '"%s', '"%s' })
        comment_ft.set('c', { '// %s', '/*%s*/' })
      end,
    },
  }