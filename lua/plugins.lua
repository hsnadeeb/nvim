-- Plugin setup with lazy.nvim
require("lazy").setup({
  -- Theme Management
  {
    -- Theme: Decay (Default)
    "decaycs/decay.nvim",
    lazy = false, -- Load immediately
    priority = 1000, -- Load this first
    config = function()
      require("decay").setup({ style = "dark" })  
      vim.cmd("colorscheme decay")
    end,
  },
  -- Additional Themes (lazy-loaded)
  { "folke/tokyonight.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  
  -- which-key configuration
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require('which-key')
      
      -- Theme toggler configuration
      local themes = {
        "decay",
        "tokyonight",
        "kanagawa",
        "catppuccin",
        "everforest",
        "onedark"
      }
      local current_theme = 1
      
      local function set_theme(index)
        current_theme = index
        local theme = themes[current_theme]
        if theme == "decay" then
          require("decay").setup({ style = "dark" })
        end
        vim.cmd("colorscheme " .. theme)
        print("Theme: " .. theme)
      end
      
      local function next_theme()
        current_theme = (current_theme % #themes) + 1
        set_theme(current_theme)
      end
      
      -- Register theme commands
      vim.api.nvim_create_user_command('NextTheme', next_theme, {})
      
      -- Main key mappings
      local mappings = {
        ["<leader>"] = {
          f = { name = "+find" },
          g = { name = "+git" },
          d = { name = "+debug" },
          x = { name = "+trouble" },
          th = { 
            name = "+theme",
            n = { next_theme, "Next theme" },
          },
        },
      }
      
      -- Setup which-key with our mappings
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        win = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2 },
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        filter = function() return true end, -- Replaces ignore_missing
        show_help = true,
        show_keys = true,
      })

      -- Set up leader key mappings
      local mappings = {
        d = { name = "+debug" },
        f = { name = "+find" },
        g = { name = "+git" },
        x = { name = "+trouble" },
        th = { name = "+theme" },
      }

      -- Register the mappings with which-key
      wk.register(mappings, { prefix = "<leader>" })
      
      -- Register the theme toggle separately
      vim.keymap.set('n', '<leader>thn', function() next_theme() end, { desc = 'Next theme' })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      -- Disable netrw (recommended by nvim-tree)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Set up nvim-tree
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
            },
          },
        },
        actions = {
          open_file = {
            resize_window = true,
          },
        },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = { ["<C-j>"] = require("telescope.actions").move_selection_next },
            n = { ["q"] = require("telescope.actions").close },
          },
        },
      })
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
            accept = "<M-l>",
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
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          go = { "goimports" },
        },
        formatters = {
          prettier = {
            command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
          },
          goimports = {
            command = vim.fn.stdpath("data") .. "/mason/bin/goimports",
          },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
        },
      })
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
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        direction = "horizontal",
      })
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
      require("trouble")
    end,
  },
})
