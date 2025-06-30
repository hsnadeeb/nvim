-- Plugin setup with lazy.nvim
local function get_icon(kind, padding)
  local icon_pack = vim.g.icons_enabled and "icons-" or ""
  local icon = ""

  if kind == "debug" then
    icon = ""
  elseif kind == "diagnostics" then
    icon = ""
  elseif kind == "git" then
    icon = ""
  end

  return icon .. string.rep(" ", padding or 0)
end

require("lazy").setup({
  -- UI Enhancements
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy', -- Load after UI is ready
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true }
    },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto',
          component_separators = { left = '│', right = '│' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = { 'alpha', 'dashboard' },
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            { 'branch', icon = get_icon('git') },
            { 'diff',
              symbols = { added = ' ', modified = ' ', removed = ' ' },
              diff_color = {
                added = { fg = '#98c379' },
                modified = { fg = '#e5c07b' },
                removed = { fg = '#e06c75' },
              }
            },
            { 'diagnostics',
              symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
              diagnostics_color = {
                error = { fg = '#e06c75' },
                warn = { fg = '#e5c07b' },
                info = { fg = '#61afef' },
                hint = { fg = '#56b6c2' },
              }
            }
          },
          lualine_c = {
            { 'filename',
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
              symbols = {
                modified = ' ', -- Text to show when the buffer is modified
                readonly = ' ', -- Text to show when the buffer is non-modifiable or readonly
                unnamed = '[No Name]', -- Text to show for unnamed buffers
                newfile = '[New]', -- Text to show for newly created file before first write
              }
            },
            { 'searchcount', maxcount = 999, timeout = 500 }
          },
          lualine_x = {
            { 'encoding',   fmt = string.upper },
            { 'fileformat', symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' } },
            { 'filetype',   icon_only = true,                                   separator = '' },
            { 'filetype',   icon = { align = 'right' },                         padding = { left = 0, right = 1 } }
          },
          lualine_y = {
            { 'progress', separator = ' ',                  padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } }
          },
          lualine_z = {
            function()
              return ' ' .. os.date('%R') -- Display current time
            end,
          }
        },
        extensions = { 'quickfix', 'man', 'fugitive', 'trouble', 'lazy', 'fzf' },
      }
    end,
    init = function()
      -- Disable lualine for specific filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'alpha', 'dashboard' },
        callback = function()
          vim.opt.showtabline = 0
          vim.opt.laststatus = 0
        end,
      })

      -- Re-enable lualine for regular buffers
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          local buftype = vim.bo.buftype
          if buftype ~= 'nofile' and buftype ~= 'prompt' then
            vim.opt.laststatus = 3
          end
        end,
      })
    end,
  },

  -- Better Visuals (lazy-loaded on BufRead)
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
        tab_char = '▏',
        highlight = { 'Whitespace', 'IblIndent' },
        smart_indent_cap = true,
        priority = 1,
      },
      scope = {
        show_start = true,
        show_end = true,
        show_exact_scope = false,
        highlight = { 'IblScope' },
        priority = 2,
      },
      exclude = {
        filetypes = {
          'help', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason',
          'notify', 'toggleterm', 'lazyterm', 'qf', 'terminal'
        },
        buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
      },
    },
    config = function(_, opts)
      -- Set highlight groups
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3b4048', nocombine = true }) -- Slightly visible indent guides
      vim.api.nvim_set_hl(0, 'IblScope', { fg = '#4b5262', nocombine = true })  -- Scope highlight

      -- Setup with options
      require('ibl').setup(opts)

      -- Toggle with <leader>ui
      vim.keymap.set('n', '<leader>ui', function()
        local ibl = require('ibl')
        ibl.toggle()
        vim.notify('Indent guides ' .. (ibl.is_enabled() and 'enabled' or 'disabled'))
      end, { desc = 'Toggle indent guides' })

      -- Refresh on color scheme change
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3b4048', nocombine = true })
          vim.api.nvim_set_hl(0, 'IblScope', { fg = '#4b5262', nocombine = true })
          require('ibl').update()
        end,
      })
    end,
  },

  -- Enhanced LSP UI (lazy-loaded on LspAttach)
  {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons',     lazy = true },
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    config = function()
      -- Only load if LSP is available
      if not pcall(require, 'vim.lsp') then return end

      local function on_attach(client, bufnr)
        -- Only set up keymaps if this is the first LSP client for this buffer
        local clients = vim.lsp.get_clients({ buffer = bufnr })
        if #clients > 1 then return end

        -- Keymaps are now handled in keybindings.lua
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
          -- Performance optimizations
          async = true,
          keep_focused = true,
        },
        lightbulb = {
          enable = true,
          enable_in_insert = false, -- Don't show in insert mode for better performance
          sign = true,
          sign_priority = 40,
          virtual_text = false, -- Disable virtual text for better performance
          update_time = 200,    -- Debounce time in ms
        },
        symbol_in_winbar = {
          enable = true,
          separator = '  ',
          hide_keyword = true,
          show_file = true,
          folder_level = 2,
          respect_root = true,
          color_mode = true,
          -- Performance optimization
          ignore_patterns = { '%.git', 'node_modules', '__pycache__', '%.o', '%.a', '%.out', '%.class', '%.so' },
        },
        -- Performance optimizations
        diagnostic = {
          show_code_action = false, -- Disable by default, use keybind
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

      -- Set up autocommand for LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          on_attach(client, bufnr)
        end,
      })
    end,
  },

  -- Auto pairs (lazy-loaded on InsertEnter)
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')
      local autopairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')

      autopairs.setup({
        check_ts = true,                      -- Use treesitter
        ts_config = {
          lua = { 'string' },                 -- Don't add pairs in lua strings
          javascript = { 'template_string' }, -- Don't add pairs in template strings
          java = false,                       -- Don't use treesitter for java
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'dap-repl' },
        fast_wrap = {
          map = '<M-e>', -- Alt+e to jump to next pair
          chars = { '{', '[', '(', '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
          offset = 0, -- Offset from pattern match
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey = 'Comment'
        },
        enable_check_bracket_line = false, -- Don't check current line for pairs
        ignored_next_char = '[%w%.]',      -- Don't pair if next char is alphanumeric or dot
        break_undo = true,                 -- Break undo sequence at space
      })

      -- Add spaces between parentheses
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      autopairs.add_rules {
        Rule(' ', ' ')
            :with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                '()', '[]', '{}'
              }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                '(  )', '[  ]', '{  }',
                '(  )', '\n  \n',
              }, context)
            end)
      }

      -- Add each pair of brackets
      for _, bracket in ipairs(brackets) do
        autopairs.add_rules {
          Rule(bracket[1] .. ' ', ' ' .. bracket[2])
              :with_pair(function() return false end)
              :with_move(function(opts) return opts.char == bracket[2] end)
              :with_cr(cond.none())
              :with_del(function(opts)
                return opts.line:sub(opts.col - #bracket[1], opts.col - 1) == bracket[1] .. ' '
                    and opts.line:sub(opts.col, opts.col + #bracket[2] + 1) == ' ' .. bracket[2]
              end)
        }
      end

      -- Integration with nvim-cmp
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- Comments (lazy-loaded on VeryLazy)
  {
    'numToStr/Comment.nvim',
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

      -- Simple configuration with only <leader>/
      comment.setup({
        padding = true,  -- Add space between comment and line
        sticky = true,   -- Keep cursor position when commenting
        ignore = '^$',   -- Ignore empty lines
        toggler = {
          line = '<leader>/',  -- Toggle current line (normal/visual mode)
          block = '<leader>/', -- Toggle current block (visual mode)
        },
        opleader = {
          line = '<leader>/',  -- Toggle line (visual mode)
          block = '<leader>/', -- Toggle block (visual mode)
        },
        mappings = {
          basic = false,    -- Disable basic mappings (gcc, gbc, etc.)
          extra = false,    -- Disable extra mappings (gco, gcO, etc.)
          extended = false, -- Disable extended mappings (g>b, g<b, etc.)
        },
      })

      -- Set up the leader / mapping after the plugin is loaded
      local api = require('Comment.api')
      vim.keymap.set('n', '<leader>/', api.toggle.linewise.current, { desc = 'Toggle comment' })
      vim.keymap.set('v', '<leader>/', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        { silent = true, desc = 'Toggle comment' })

      -- Custom comment strings for specific filetypes
      local comment_ft = require('Comment.ft')
      comment_ft.set('lua', { '-- %s', '--[[%s]]' })
      comment_ft.set('vim', { '"%s', '"%s' })
      comment_ft.set('c', { '// %s', '/*%s*/' })
    end,
  },

  -- Todo comments
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup()
    end
  },

  -- Session management
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = { '~/', '/', '~/Downloads' },
      }
    end
  },

  -- Project management
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        detection_methods = { 'pattern' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'pom.xml' },
      }
    end
  },

  -- Auto-save
  {
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup {
        enabled = true,
        execution_message = {
          message = function() return "" end, -- Disable save message
        },
        trigger_events = { 'InsertLeave', 'TextChanged' },
        debounce_delay = 1000, -- Save after 1 second of inactivity
      }
    end,
  },

  -- Debugging
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-neotest/nvim-nio', -- Required by nvim-dap-ui
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Basic debugging keymaps
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        { desc = 'Debug: Set Conditional Breakpoint' })

      -- DAP UI setup
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Virtual text for debugging
      require('nvim-dap-virtual-text').setup()

      -- Telescope DAP integration
      require('telescope').load_extension('dap')
    end
  },
  -- Theme Management - Load all themes but don't configure them yet
  { "sainnhe/everforest",             lazy = true },
  { "ellisonleao/gruvbox.nvim",       lazy = true },
  { "craftzdog/solarized-osaka.nvim", lazy = true }, 
  { "decaycs/decay.nvim",             lazy = true },
  { "EdenEast/nightfox.nvim",         lazy = true },
  { "marko-cerovac/material.nvim",    lazy = true },

  -- Theme manager configuration
  -- This will be initialized via the VeryLazy event
  {
    "folke/neoconf.nvim",
    config = function()
      require("plugins.themes").setup()
    end,
    lazy = false,
    priority = 1000, -- Load first
  },

  -- which-key configuration
  {
    "folke/which-key.nvim",
    version = "^1.0.0",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = {
        spelling = { enabled = true },
      },
    },
    config = function(_, opts)
      require("plugins.which-key").setup()

      -- Register theme commands
      local themes_module = require("plugins.themes")
      vim.api.nvim_create_user_command('NextTheme', themes_module.next_theme, {})
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("plugins.nvim-tree").setup()
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.telescope").setup()
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript", "typescript", "tsx", "java", "go",
          "html", "css", "json", "lua", "vim", "vimdoc", "query"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- Mason and LSP
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "typescript-language-server", "html", "cssls", "eslint", "gopls", "jdtls",
          -- Formatters
          "prettier", "goimports",
          -- Debug adapters
          "java-debug-adapter", "delve",
        },
        auto_update = true,
        run_on_start = true,
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "html", "cssls", "eslint", "gopls", "jdtls" },
        automatic_installation = true,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item = require("lspkind").cmp_format({ mode = "symbol", maxwidth = 50 })(entry, vim_item)
            vim_item.menu = ({
              copilot = "[Copilot]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
            accept_line = "<C-l>",
            accept_word = "<C-Right>",
            next = "<M-j>",
            prev = "<M-k>",
            dismiss = "<C-]>"
          },
        },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },



  -- Formatter
  {
    "stevearc/conform.nvim",
    config = function()
      require("plugins.conform").setup()
    end,
  },

  -- Code structure view (like IntelliJ's Structure view)
  {
    'stevearc/aerial.nvim',
    cmd = 'AerialToggle',
    keys = {
      { '<leader>m', '<cmd>AerialToggle!<CR>', desc = 'Toggle Code Structure' },
    },
    config = function()
      require('aerial').setup({
        -- Priority list of preferred backends for aerial.
        -- This can be a filetype map (see :help aerial-options)
        backends = { 'lsp', 'treesitter', 'markdown', 'man' },
        layout = {
          -- Position of the tree window
          default_direction = 'right',
          -- Width of the aerial window (applies when direction is left or right)
          width = 0.3,
          -- Minimum width of the aerial window
          min_width = 30,
        },
        -- Show box drawing characters for the tree hierarchy
        show_guides = true,
        -- Show a preview of the code in the upper right corner
        show_guides = true,
        -- Customize the characters used when show_guides = true
        guides = {
          -- When the child item has a sibling below it
          mid_item = '├──',
          -- When the child item is the last in the list
          last_item = '└──',
          -- When there are nested child guides to the right
          nested_top = '│   ',
          -- Raw indentation
          whitespace = '  ',
        },
        -- Keymaps in aerial window. Can be any value that `vim.keymap.set` accepts.
        keymaps = {
          ['<CR>'] = 'actions.jump',
          ['<2-LeftMouse>'] = 'actions.jump',
          ['<C-v>'] = 'actions.jump_vsplit',
          ['<C-s>'] = 'actions.jump_split',
          ['p'] = 'actions.scroll',
          ['<C-j>'] = 'actions.down_and_scroll',
          ['<C-k>'] = 'actions.up_and_scroll',
          ['q'] = 'actions.close',
          ['?'] = 'actions.show_help',
        },
        -- Filter which file types to show in the structure view
        filter_kind = {
          'Class',
          'Constructor',
          'Enum',
          'Function',
          'Interface',
          'Method',
          'Struct',
        },
        -- Icons to use for different symbol kinds
        icons = {
          Array = ' ',
          Boolean = ' ',
          Class = ' ',
          Color = ' ',
          Constant = ' ',
          Constructor = ' ',
          Enum = ' ',
          EnumMember = ' ',
          Event = ' ',
          Field = ' ',
          File = ' ',
          Function = ' ',
          Interface = ' ',
          Key = ' ',
          Method = ' ',
          Module = ' ',
          Namespace = ' ',
          Null = ' ',
          Number = ' ',
          Object = ' ',
          Operator = ' ',
          Package = ' ',
          Property = ' ',
          String = ' ',
          Struct = ' ',
          TypeParameter = ' ',
          Variable = ' ',
        },
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.gitsigns").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("plugins.toggleterm").setup()
    end,
  },

  -- Buffer tabs
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('barbar').setup({
        animation = true,
        auto_hide = false,
        tabpages = true,
        clickable = true,
        icons = {
          filetype = { enabled = true },
          button = '󰖭',
          modified = { button = '●' },
          inactive = { button = '×' },
        },
      })
    end,
  },

  -- Better diagnostics UI
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("trouble") -- Just load the module, setup is handled in lua/trouble.lua
    end,
  },
})
