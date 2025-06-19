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
      require("trouble")
    end,
  },
})
