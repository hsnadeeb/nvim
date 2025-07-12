-- local vim = require("vim")

return {
  {
    repo = "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { repo = "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },
      { repo = "nvim-telescope/telescope-project.nvim" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
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

      local builtin = require("telescope.builtin")

      -- Keybindings
      vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({
          hidden = true,
          no_ignore = false,
          follow = true
        })
      end, { desc = 'Find Files' })

      vim.keymap.set('n', '<leader>fg', function()
        builtin.live_grep({
          hidden = true,
          no_ignore = false
        })
      end, { desc = 'Live Grep' })

      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help' })

      vim.keymap.set('n', '<leader>bd', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        if filetype == 'NvimTree' or filetype == 'TelescopePrompt' then
          vim.cmd('bdelete')
          return
        end
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        if #bufs > 1 then
          vim.cmd('bnext')
          vim.cmd('bdelete ' .. bufnr)
        else
          vim.cmd('bdelete')
        end
      end, { desc = 'Close Buffer' })

      -- Load extensions
      pcall(function()
        require("telescope").load_extension('fzf')
      end)

      if package.loaded['dap'] then
        pcall(function()
          require("telescope").load_extension('dap')
        end)
      end

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
    end,
  },
}