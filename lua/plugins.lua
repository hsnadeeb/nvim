-- ============================================================================
-- Plugin Manager & Individual Plugin Configs
-- ============================================================================

require("lazy").setup({
	-- UI
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("plugins.config.lualine"),
		event = "VeryLazy",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = require("plugins.config.indent_blankline"),
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("plugins.config.lspsaga"),
	},

	-- Completion & AI
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"onsails/lspkind-nvim",
		},
		config = require("plugins.config.cmp"),
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = require("plugins.config.copilot"),
	},
	{
		"zbirenbaum/copilot-cmp",
		config = require("plugins.config.copilot_cmp"),
	},

	-- Editing tools
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = require("plugins.config.autopairs"),
	},
	{ "numToStr/Comment.nvim", event = "VeryLazy", config = require("plugins.config.comment") },

	-- Fuzzy finder & search
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = require("plugins.config.telescope"),
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	-- Enhanced search & replace (like IntelliJ)
	{
		"windwp/nvim-spectre",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = require("plugins.config.spectre"),
	},

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("plugins.config.nvimtree"),
	},

	-- Syntax & parsing
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = false },

	-- LSP & Mason
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"neovim/nvim-lspconfig",
		},
		config = require("plugins.config.mason"),
	},

	-- Formatter
	{ "stevearc/conform.nvim", config = require("plugins.config.conform") },

	-- Refactoring
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = require("plugins.config.refactoring"),
	},

	-- Git
	{ "lewis6991/gitsigns.nvim", config = require("plugins.config.gitsigns") },

	-- Project & sessions
	{ "ahmedkhalf/project.nvim", config = require("plugins.config.project") },
	{ "rmagatti/auto-session", config = require("plugins.config.session") },

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text", "nvim-neotest/nvim-nio" },
		config = require("plugins.config.dap"),
	},

	-- Java support
	{ "mfussenegger/nvim-jdtls", ft = "java" },

	-- Terminal
	{ "akinsho/toggleterm.nvim", config = require("plugins.config.toggleterm") },

	-- Buffer tabs
	{
		"romgrk/barbar.nvim",
		dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
		config = require("plugins.config.barbar"),
	},

	-- Diagnostics
	{ "folke/trouble.nvim", config = require("plugins.config.trouble") },

	-- Code structure (like IntelliJ Structure view)
	{ "stevearc/aerial.nvim", cmd = "AerialToggle", config = require("plugins.config.aerial") },

	-- Dashboard
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("plugins.config.alpha"),
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = require("plugins.config.todo_comments"),
	},

	-- Auto-save
	{ "okuuva/auto-save.nvim", config = require("plugins.config.autosave") },

	-- Themes
	{ "sainnhe/everforest", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "navarasu/onedark.nvim", lazy = true },
	{ "folke/neoconf.nvim", opts = {}, lazy = false },
	{ "folke/lazydev.nvim", ft = "lua" },

	-- Theme manager (must load after colorschemes)
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
		priority = 999,
		config = function()
			require("plugins.config.themes").setup()
		end,
	},

	-- Which-key
	{ "folke/which-key.nvim", version = "^1.0.0", event = "VeryLazy", config = require("plugins.config.which_key") },
}, {
	rocks = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "tarPlugin", "zipPlugin", "netrwPlugin" },
		},
	},
})
