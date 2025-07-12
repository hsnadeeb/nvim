-- local vim = require("vim")

return {
    {
      repo = "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      config = function()
        require("trouble").setup({
          position = "bottom",
          height = 12,
          width = 60,
          padding = true,
          indent_lines = true,
          auto_preview = true,
          auto_fold = false,
          auto_open = false,
          auto_close = false,
          auto_jump = { "lsp_definitions" },
          icons = true,
          mode = "workspace_diagnostics",
          fold_open = "",
          fold_closed = "",
          group = true,
          action_keys = {
            close = "q",
            cancel = "<esc>",
            refresh = "r",
            jump = { "<cr>", "<tab>" },
            open_split = { "<c-x>" },
            open_vsplit = { "<c-v>" },
            open_tab = { "<c-t>" },
            jump_close = { "o" },
            toggle_mode = "m",
            toggle_preview = "P",
            hover = "K",
            preview = "p",
            close_folds = { "zM", "zm" },
            open_folds = { "zR", "zr" },
            toggle_fold = { "zA", "za" },
            previous = "k",
            next = "j",
            help = "?"
          },
          use_diagnostic_signs = false,
          signs = {
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
          },
          mappings = {},
          filter = { mode = "all" },
          sort_keys = { "severity", "filename", "lnum", "col" },
          preview = {
            type = "float",
            relative = "cursor",
            border = "rounded",
            position = { 0, 0 },
            size = { width = 0.4, height = 0.6 },
            win_opts = {}
          },
          format = function(items)
            local results = {}
            for _, item in ipairs(items) do
              table.insert(results, string.format("%s:%s: %s",
                vim.fn.fnamemodify(item.filename, ":~:."),
                item.lnum,
                item.message:gsub("\n", " "):sub(1, 100)
              ))
            end
            return results
          end
        })
  
        -- Auto Commands
        local group = vim.api.nvim_create_augroup('TroubleConfig', { clear = true })
        vim.api.nvim_create_autocmd('DiagnosticChanged', {
          group = group,
          callback = function()
            local count = #vim.diagnostic.get(0)
            if count > 0 then
              vim.schedule(function()
                require('trouble').toggle('workspace_diagnostics')
              end)
            end
          end,
        })
  
        -- Custom Commands
        vim.api.nvim_create_user_command('TroubleErrors', function()
          require('trouble').toggle('workspace_diagnostics', {
            filter = {
              severity = vim.diagnostic.severity.ERROR
            }
          })
        end, { desc = 'Show only errors in Trouble' })
        
        vim.api.nvim_create_user_command('TroubleWarnings', function()
          require('trouble').toggle('workspace_diagnostics', {
            filter = {
              severity = vim.diagnostic.severity.WARN
            }
          })
        end, { desc = 'Show only warnings in Trouble' })
        
        vim.api.nvim_create_user_command('TroubleToggleErrors', function()
          require('trouble').toggle('workspace_diagnostics', {
            filter = {
              severity = vim.diagnostic.severity.ERROR
            }
          })
        end, {})
        
        vim.api.nvim_create_user_command('TroubleToggleWarnings', function()
          require('trouble').toggle('workspace_diagnostics', {
            filter = {
              severity = vim.diagnostic.severity.WARN
            }
          })
        end, {})
      end,
    },
  }