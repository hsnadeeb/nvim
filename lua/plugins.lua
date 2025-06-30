-- Plugin setup with lazy.nvim
local function get_icon(kind, padding)
  local icon = ({ debug = "", diagnostics = "", git = "" })[kind] or ""
  return icon .. string.rep(" ", padding or 0)
end

require("lazy").setup({
  -- UI Enhancements
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "alpha", "dashboard" },
          globalstatus = true,
          refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = get_icon("git") },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              diff_color = { added = { fg = "#98c379" }, modified = { fg = "#e5c07b" }, removed = { fg = "#e06c75" } },
            },
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              diagnostics_color = {
                error = { fg = "#e06c75" },
                warn = { fg = "#e5c07b" },
                info = { fg = "#61afef" },
                hint = { fg = "#56b6c2" },
              },
            },
          },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = "[No Name]", newfile = "[New]" } },
            { "searchcount", maxcount = 999, timeout = 500 },
          },
          lualine_x = {
            { "encoding", fmt = string.upper },
            { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
            { "filetype", icon_only = true, separator = "" },
            { "filetype", icon = { align = "right" }, padding = { left = 0, right = 1 } },
          },
          lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 0 } }, { "location", padding = { left = 0, right = 1 } } },
          lualine_z = { function() return " " .. os.date("%R") end },
        },
        extensions = { "quickfix", "man", "fugitive", "trouble", "lazy" }, -- Removed "fzf" as it’s handled by telescope
      })
    end,
    init = function()
      vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
        pattern = { "alpha", "dashboard" },
        callback = function() vim.opt.showtabline = 0 vim.opt.laststatus = 0 end,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.bo.buftype ~= "nofile" and vim.bo.buftype ~= "prompt" then
            vim.opt.laststatus = 3
          end
        end,
      })
    end,
  },

  -- Indent Guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "┊", tab_char = "▏", highlight = { "Whitespace", "IblIndent" }, smart_indent_cap = true, priority = 1 },
      scope = { show_start = true, show_end = true, highlight = { "IblScope" }, priority = 2 },
      exclude = {
        filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify", "toggleterm", "lazyterm", "qf", "terminal" },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
      },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4048", nocombine = true })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#4b5262", nocombine = true })
      require("ibl").setup(opts)
      vim.keymap.set("n", "<leader>ui", function()
        local ibl = require("ibl")
        ibl.toggle()
        vim.notify("Indent guides " .. (ibl.is_enabled() and "enabled" or "disabled"))
      end, { desc = "Toggle indent guides" })
    end,
  },

  -- LSP UI
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
    config = function()
      if not pcall(require, "vim.lsp") then return end
      require("lspsaga").setup({
        ui = { border = "rounded", title = true, winblend = 0, expand = "", collapse = "", code_action = "💡", incoming = " ", outgoing = " ", hover = " " },
        lightbulb = { enable = true, enable_in_insert = false, sign = true, sign_priority = 40, virtual_text = false, update_time = 200 },
        symbol_in_winbar = { enable = true, separator = "  ", hide_keyword = true, show_file = true, folder_level = 2, respect_root = true, color_mode = true },
        diagnostic = {
          show_code_action = false,
          show_layout = "float",
          max_width = 0.8,
          max_height = 0.6,
          text_hl_follow = true,
          border_follow = true,
          wrap_long_lines = true,
          extend_relatedInformation = true,
          show_header = true,
          diagnostic_only_current = false,
          keys = { exec_action = "o", quit = "q", toggle_or_jump = "<CR>", quit_in_show = { "q", "<ESC>" } },
        },
      })
    end,
  },

  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      autopairs.setup({
        check_ts = true,
        ts_config = { lua = { "string" }, javascript = { "template_string" }, java = false },
        disable_filetype = { "TelescopePrompt", "spectre_panel", "dap-repl" },
        fast_wrap = { map = "<M-e>", chars = { "{", "[", "(", '"', "'" }, offset = 0, end_key = "$", keys = "qwertyuiopzxcvbnmasdfghjkl", check_comma = true, highlight = "Search", highlight_grey = "Comment" },
        enable_check_bracket_line = false,
        ignored_next_char = "[%w%.]",
        break_undo = true,
      })
      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      autopairs.add_rules({
        Rule(" ", " "):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        end):with_move(cond.none()):with_cr(cond.none()):with_del(function(opts)
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local context = opts.line:sub(col - 1, col + 2)
          return vim.tbl_contains({ "(  )", "[  ]", "{  }", "(  )\n", "\n  \n" }, context)
        end),
      })
      for _, bracket in ipairs(brackets) do
        autopairs.add_rules({
          Rule(bracket[1] .. " ", " " .. bracket[2]):with_pair(function() return false end):with_move(function(opts) return opts.char == bracket[2] end):with_cr(cond.none()):with_del(function(opts)
            return opts.line:sub(opts.col - #bracket[1], opts.col - 1) == bracket[1] .. " " and opts.line:sub(opts.col, opts.col + #bracket[2] + 1) == " " .. bracket[2]
          end),
        })
      end
      require("nvim-autopairs.completion.cmp").setup()
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    keys = { { "<leader>/", mode = { "n", "v" }, desc = "Toggle comment" } },
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = "^$",
        toggler = { line = "<leader>/", block = "<leader>/" },
        opleader = { line = "<leader>/", block = "<leader>/" },
        mappings = { basic = false, extra = false, extended = false },
      })
      local api = require("Comment.api")
      vim.keymap.set("n", "<leader>/", api.toggle.linewise.current, { desc = "Toggle comment" })
      vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { silent = true, desc = "Toggle comment" })
      require("Comment.ft").set("lua", { "-- %s", "--[[%s]]" }).set("vim", { "\"%s", "\"%s" }).set("c", { "// %s", "/*%s*/" })
    end,
  },

  -- Todo Comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("todo-comments").setup() end,
  },

  -- Session Management
  {
    "rmagatti/auto-session",
    event = "VimEnter",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "/", "~/Downloads" },
        auto_restore_enabled = false, -- Disable auto-restore to reduce startup time
      })
    end,
  },

  -- Project Management
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
      })
    end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text", "nvim-telescope/telescope-dap.nvim", "nvim-neotest/nvim-nio" },
    cmd = { "DapToggleBreakpoint", "DapContinue" },
    keys = {
      { "<F5>", "<cmd>lua require('dap').continue()<cr>", desc = "Debug: Start/Continue" },
      { "<F10>", "<cmd>lua require('dap').step_over()<cr>", desc = "Debug: Step Over" },
      { "<F11>", "<cmd>lua require('dap').step_into()<cr>", desc = "Debug: Step Into" },
      { "<F12>", "<cmd>lua require('dap').step_out()<cr>", desc = "Debug: Step Out" },
      { "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Debug: Toggle Breakpoint" },
      { "<leader>B", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Debug: Set Conditional Breakpoint" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
      require("nvim-dap-virtual-text").setup()
      require("telescope").load_extension("dap")
    end,
  },

  -- Themes
  { "sainnhe/everforest", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "craftzdog/solarized-osaka.nvim", lazy = true },
  { "decaycs/decay.nvim", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },

  -- Theme Manager
  {
    "folke/neoconf.nvim",
    event = "VeryLazy",
    config = function() require("plugins.themes").setup() end,
  },

  -- Which-Key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = { plugins = { spelling = { enabled = true } } },
    config = function()
      require("plugins.which-key").setup()
      vim.api.nvim_create_user_command("NextTheme", require("plugins.themes").next_theme, {})
    end,
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    keys = {
      { "<leader>n", "<cmd>lua require('plugins.nvim-tree').toggle()<cr>", desc = "Toggle NvimTree" },
      { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus NvimTree" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.nvim-tree").setup() end,
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = { "Telescope" },
    keys = {
      { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files({hidden=true,no_ignore=false,follow=true})<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep({hidden=true,no_ignore=false})<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "Find Buffers" },
      { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "Find Help" },
      { "<leader>pp", "<cmd>lua require('telescope').extensions.project.project({display_type='minimal',layout_config={width=0.9,height=0.8}})<cr>", desc = "Projects" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.telescope").setup() end,
  },

  -- Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "javascript", "typescript", "tsx", "java", "go", "html", "css", "json", "lua", "vim", "vimdoc", "query" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end,
  },

  -- Mason and LSP
  {
    "williamboman/mason.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-tool-installer").setup({
        ensure_installed = { "typescript-language-server", "html", "cssls", "eslint", "gopls", "jdtls", "prettier", "goimports", "java-debug-adapter", "delve" },
        auto_update = false, -- Disable auto-update on startup
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "html", "cssls", "eslint", "gopls", "jdtls" },
        automatic_installation = false, -- Disable automatic installation on startup
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "onsails/lspkind-nvim", "zbirenbaum/copilot-cmp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
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
            vim_item.menu = ({ copilot = "[Copilot]", nvim_lsp = "[LSP]", luasnip = "[Snippet]", buffer = "[Buffer]", path = "[Path]" })[entry.source.name]
            return vim_item
          end,
        },
      })
      require("copilot_cmp").setup()
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

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function() require("plugins.conform").setup() end,
  },

  -- Auto-Save
  {
    "907th/vim-auto-save",
    event = "BufReadPost",
    config = function()
      vim.g.auto_save = 0
      vim.g.auto_save_silent = 1
      vim.g.auto_save_events = { "InsertLeave", "TextChanged", "FocusLost" }
      vim.api.nvim_create_user_command("AutoSaveToggle", function()
        vim.g.auto_save = 1 - vim.g.auto_save
        vim.notify("Autosave: " .. (vim.g.auto_save == 1 and "Enabled" or "Disabled"), vim.log.levels.INFO, { title = "AutoSave" })
      end, {})
    end,
  },

  -- Code Structure
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    keys = { { "<leader>m", "<cmd>AerialToggle!<cr>", desc = "Toggle Code Structure" } },
    config = function()
      require("aerial").setup({
        backends = { "lsp", "treesitter", "markdown", "man" },
        layout = { default_direction = "right", width = 0.3, min_width = 30 },
        show_guides = true,
        guides = { mid_item = "├──", last_item = "└──", nested_top = "│   ", whitespace = "  " },
        keymaps = {
          ["<CR>"] = "actions.jump",
          ["<2-LeftMouse>"] = "actions.jump",
          ["<C-v>"] = "actions.jump_vsplit",
          ["<C-s>"] = "actions.jump_split",
          ["p"] = "actions.scroll",
          ["<C-j>"] = "actions.down_and_scroll",
          ["<C-k>"] = "actions.up_and_scroll",
          ["q"] = "actions.close",
          ["?"] = "actions.show_help",
        },
        filter_kind = { "Class", "Constructor", "Enum", "Function", "Interface", "Method", "Struct" },
      })
    end,
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("plugins.gitsigns").setup() end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = { { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" } },
    config = function() require("plugins.toggleterm").setup() end,
  },

  -- Buffer Tabs
  {
    "romgrk/barbar.nvim",
    event = "BufReadPost",
    dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("barbar").setup({
        animation = true,
        auto_hide = false,
        tabpages = true,
        clickable = true,
        icons = { filetype = { enabled = true }, button = "󰖭", modified = { button = "●" }, inactive = { button = "×" } },
      })
    end,
  },

  -- Diagnostics UI
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    keys = { { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" } },
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function() require("trouble") end,
  },
})