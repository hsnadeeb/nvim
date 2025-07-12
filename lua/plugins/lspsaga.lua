-- local vim = require("vim")

return {
    {
      repo = 'glepnir/lspsaga.nvim',
      event = 'LspAttach',
      dependencies = {
        { repo = 'nvim-tree/nvim-web-devicons',     lazy = true },
        { repo = 'nvim-treesitter/nvim-treesitter', lazy = true },
      },
      config = function()
        if not pcall(require, 'vim.lsp') then return end
        local function on_attach(client, bufnr)
          local clients = vim.lsp.get_clients({ buffer = bufnr })
          if #clients > 1 then return end
        end
        require('lspsaga').setup({
          ui = {
            border = 'rounded',
            title = true,
            winblend = 0,
            expand = '',
            collapse = '',
            code_action = '💡',
            incoming = ' ',
            outgoing = ' ',
            hover = ' ',
            kind = {},
            async = true,
            keep_focused = true,
          },
          lightbulb = {
            enable = true,
            enable_in_insert = false,
            sign = true,
            sign_priority = 40,
          },
          symbol_in_winbar = {
            enable = true,
            separator = '  ',
            hide_keyword = true,
            show_file = true,
            folder_level = 2,
            respect_root = true,
            color_mode = true,
            ignore_patterns = { '%.git', 'node_modules', '__pycache__', '%.o', '%.a', '%.out', '%.class', '%.so' },
          },
          diagnostic = {
            show_code_action = false,
            show_layout = 'float',
            show_normal_height = 0.6,
            jump_num_shortcut = true,
            max_width = 0.8,
            max_height = 0.6,
            max_show_width = 0.9,
            max_show_height = 0.6,
            text_hl_follow = true,
            border_follow = true,
            wrap_long_lines = true,
            extend_relatedInformation = true,
            show_header = true,
            diagnostic_only_current = false,
            keys = {
              exec_action = 'o',
              quit = 'q',
              toggle_or_jump = '<CR>',
              quit_in_show = { 'q', '<ESC>' },
            },
          },
        })
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, bufnr)
          end,
        })
      end,
    },
  }