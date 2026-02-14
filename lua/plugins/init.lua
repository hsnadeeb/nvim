return {
  -- Theme plugins
  { "sainnhe/everforest", lazy = false, priority = 1000 },
  { "morhetz/gruvbox", lazy = false, priority = 1000 },
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
  { "navarasu/onedark.nvim", lazy = false, priority = 1000 },

  -- UI plugins
  { "nvim-lualine/lualine.nvim", event = "VeryLazy", config = require("plugins.config.lualine") },
  { "romgrk/barbar.nvim", event = "VeryLazy", config = require("plugins.config.barbar") },
  { "nvim-tree/nvim-tree.lua", cmd = { "NvimTreeToggle", "NvimTreeFocus" }, config = require("plugins.config.nvimtree") },
  { "goolord/alpha-nvim", event = "VimEnter", config = require("plugins.config.alpha") },
  { "lukas-reineke/indent-blankline.nvim", event = { "BufReadPost", "BufNewFile" }, config = require("plugins.config.indent_blankline") },

  -- Navigation
  { "nvim-telescope/telescope.nvim", cmd = "Telescope", config = require("plugins.config.telescope") },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- LSP and completion
  { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" } },
  { "williamboman/mason.nvim", cmd = "Mason", config = require("plugins.config.mason") },
  { "williamboman/mason-lspconfig.nvim" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { "nvimdev/lspsaga.nvim", event = "LspAttach", config = require("plugins.config.lspsaga") },
  { "hrsh7th/nvim-cmp", event = "InsertEnter", config = require("plugins.config.cmp") },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip", event = "InsertEnter" },
  { "saadparwaiz1/cmp_luasnip" },
  { "onsails/lspkind.nvim" },

  -- Code editing
  { "windwp/nvim-autopairs", event = "InsertEnter", config = require("plugins.config.autopairs") },
  { "numToStr/Comment.nvim", event = { "BufReadPost", "BufNewFile" }, config = require("plugins.config.comment") },
  { "ThePrimeagen/refactoring.nvim", config = require("plugins.config.refactoring") },

  -- Formatting
  { "stevearc/conform.nvim", event = { "BufWritePre" }, cmd = { "ConformInfo" }, config = require("plugins.config.conform") },

  -- Git
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, config = require("plugins.config.gitsigns") },

  -- AI/Copilot
  { "zbirenbaum/copilot.lua", cmd = "Copilot", event = "InsertEnter", config = require("plugins.config.copilot") },
  { "zbirenbaum/copilot-cmp", config = require("plugins.config.copilot_cmp") },

  -- Session management
  { "rmagatti/auto-session", config = require("plugins.config.session") },
  { "rmagatti/session-lens" },

  -- Search and replace
  { "nvim-pack/nvim-spectre", config = require("plugins.config.spectre") },

  -- Project management
  { "ahmedkhalf/project.nvim", config = require("plugins.config.project") },

  -- Terminal
  { "akinsho/toggleterm.nvim", version = "*", config = require("plugins.config.toggleterm") },

  -- Diagnostics
  { "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, config = require("plugins.config.trouble") },

  -- Todo comments
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim", config = require("plugins.config.todo_comments") },

  -- Code outline
  { "stevearc/aerial.nvim", config = require("plugins.config.aerial") },

  -- Debugging
  { "mfussenegger/nvim-dap", config = require("plugins.config.dap") },

  -- Autosave
  { "pocco81/auto-save.nvim", config = require("plugins.config.autosave") },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Which key
  { "folke/which-key.nvim", event = "VeryLazy", config = require("plugins.config.which_key") },
}
