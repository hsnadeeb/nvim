-- local vim = require("vim")
return {
    {
     repo = "folke/which-key.nvim",
     event = "VeryLazy",
     init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      config = function()
        local wk = require("which-key")
        local themes_module = require("theme_manager")
  
        wk.setup({
          plugins = {
            marks = true,
            registers = true,
            spelling = { enabled = true, suggestions = 20 },
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
          show_help = true,
          show_keys = true,
        })
  
        local function java_compile_and_run()
          vim.cmd('silent! write')
          local filename = vim.fn.expand('%:t:r')
          local filepath = vim.fn.expand('%:p')
          local dir = vim.fn.fnamemodify(filepath, ':h')
  
          -- Compile java file
          local compile_cmd = {'javac', filepath}
          local compile_ok, compile_result = pcall(vim.fn.system, compile_cmd)
          if not compile_ok or vim.v.shell_error ~= 0 then
            vim.notify("Compilation failed: " .. compile_result, vim.log.levels.ERROR)
            return
          end
  
          -- Open terminal split and run java class
          vim.cmd('botright split')
          vim.cmd('resize 15')
          local term_cmd = {'java', '-cp', dir, filename}
          vim.fn.termopen(term_cmd)
          vim.cmd('startinsert')
        end
  
        local leader_mappings = {
          a = {
            name = "Autosave",
            a = { "<cmd>lua _G.toggle_autosave()<cr>", "Toggle AutoSave" },
          },
          b = {
            name = "Buffer",
            d = { "<cmd>BufferClose<cr>", "Delete Buffer" },
            c = { "<cmd>BufferClose<cr>", "Close Current" },
            n = { "<cmd>BufferNext<cr>", "Next Buffer" },
            p = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
            D = { "<cmd>BufferClose!<cr>", "Force Delete" },
            P = { "<cmd>BufferPin<cr>", "Pin/Unpin" },
          },
          f = {
            name = "Find/Format",
            f = { "<cmd>Telescope find_files<cr>", "Find File" },
            g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
            h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
            r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
            S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
            d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
            i = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
            m = { function() require("conform").format() end, "Format Document" },
          },
          g = {
            name = "Git",
            c = { "<cmd>Telescope git_commits<cr>", "Commits" },
            bc = { "<cmd>Telescope git_bcommits<cr>", "Buffer Commits" },
            B = { "<cmd>Telescope git_branches<cr>", "Branches" },
            s = { "<cmd>Telescope git_status<cr>", "Status" },
            j = { function() require("gitsigns").next_hunk() end, "Next Hunk" },
            k = { function() require("gitsigns").prev_hunk() end, "Previous Hunk" },
            S = { function() require("gitsigns").stage_buffer() end, "Stage Buffer" },
            p = { function() require("gitsigns").preview_hunk() end, "Preview Hunk" },
            d = { function() require("gitsigns").diffthis() end, "Diff This" },
            l = { function() require("gitsigns").blame_line({ full = true }) end, "Blame Line" },
            u = { function() require("gitsigns").undo_stage_hunk() end, "Undo Stage Hunk" },
            r = { function() require("gitsigns").reset_hunk() end, "Reset Hunk" },
            R = { function() require("gitsigns").reset_buffer() end, "Reset Buffer" },
            U = { function() require("gitsigns").reset_buffer_index() end, "Reset Buffer Index" },
            D = { function() require("gitsigns").diffthis('~') end, "Git Diff (Staged)" },
            P = { function() require("gitsigns").preview_hunk_inline() end, "Preview Hunk Inline" },
            td = { function() require("gitsigns").toggle_deleted() end, "Toggle Deleted" },
            tl = { function() require("gitsigns").toggle_linehl() end, "Toggle Line Highlight" },
            tw = { function() require("gitsigns").toggle_word_diff() end, "Toggle Word Diff" },
            tb = { function() require("gitsigns").toggle_current_line_blame() end, "Toggle Blame" },
          },
          j = {
            name = "Java",
            r = { java_compile_and_run, "Compile and Run Java file" },
          },
          l = {
            name = "LSP",
            a = { vim.lsp.buf.code_action, "Code Action" },
            d = { vim.diagnostic.open_float, "Diagnostics (Line)" },
            D = { vim.lsp.buf.declaration, "Declaration" },
            i = { vim.lsp.buf.implementation, "Implementation" },
            r = { vim.lsp.buf.references, "References" },
            n = { vim.lsp.buf.rename, "Rename" },
            f = { vim.lsp.buf.format, "Format" },
            h = { vim.lsp.buf.hover, "Hover" },
            lwa = { vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
            lwr = { vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder" },
            lwl = { function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "List Workspace Folders" },
            s = { vim.lsp.buf.document_symbol, "Document Symbols" },
            S = { vim.lsp.buf.workspace_symbol, "Workspace Symbols" },
          },
          m = {
            name = "Markdown",
            p = { "<cmd>MarkdownPreview<cr>", "Toggle Preview" },
            s = { "<cmd>MarkdownPreviewStop<cr>", "Close Preview" },
          },
          n = {
            name = "NvimTree",
            n = { function() require('nvim-tree.api').tree.toggle() end, "Toggle NvimTree" },
            e = {
              function()
                local api = require('nvim-tree.api')
                if vim.bo.filetype == 'NvimTree' then
                  vim.cmd('wincmd p')
                else
                  api.tree.focus()
                end
              end, "Toggle focus between NvimTree and editor"
            },
            h = { function() require('nvim-tree.api').tree.toggle_dotfiles() end, "Toggle dotfiles in NvimTree" },
          },
          p = {
            name = "Project",
            -- Add project related mappings here if any
          },
          s = {
            name = "Search",
            -- Add search related mappings if you use any
          },
          t = {
            name = "Terminal",
            ["`"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
            f = { "<cmd>ToggleTerm direction=float<cr>", "Float Terminal" },
            v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Terminal" },
            t = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Terminal" },
          },
          w = {
            name = "Window/Write",
            s = { "<cmd>w<cr>", "Save File" },
            q = { "<cmd>w | BufferClose<cr>", "Save and Close Buffer" },
            h = { "<C-w>h", "Move to left window" },
            j = { "<C-w>j", "Move to window below" },
            k = { "<C-w>k", "Move to window above" },
            l = { "<C-w>l", "Move to right window" },
            ["="] = { "<C-w>=", "Balance windows" },
            ["|"] = { "<C-w>v", "Split window vertically" },
            ["-"] = { "<C-w>s", "Split window horizontally" },
            c = { "<C-w>c", "Close window" },
            o = { "<C-w>o", "Close other windows" },
          },
          x = {
            name = "Diagnostics",
            x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble Window" },
            w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
            d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
            l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
            q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
            e = {
              "<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.ERROR<cr>",
              "Show Only Errors",
            },
            W = {
              "<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.WARN<cr>",
              "Show Only Warnings",
            },
            i = {
              "<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.INFO<cr>",
              "Show Only Info",
            },
            h = {
              "<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.HINT<cr>",
              "Show Only Hints",
            },
          },
          th = {
            name = "Theme",
            n = { themes_module.next, "Next Theme" },
            p = { themes_module.previous, "Previous Theme" },
            c = { themes_module.cycle, "Cycle Theme" },
          },
        }
  
        -- Single mappings not under <leader>
        local mappings = vim.tbl_extend("force", leader_mappings, {
          -- Quit / Force Quit
          q = {
            function()
              if vim.fn.bufname("") ~= "NvimTree" then
                vim.cmd("q")
              end
            end, "Quit"
          },
          Q = {
            function()
              if vim.fn.bufname("") ~= "NvimTree" then
                vim.cmd("q!")
              end
            end, "Force Quit"
          },
          -- Window navigation with Ctrl
          ["<C-h>"] = { "<C-w>h", "Move to left window" },
          ["<C-j>"] = { "<C-w>j", "Move to window below" },
          ["<C-k>"] = { "<C-w>k", "Move to window above" },
          ["<C-l>"] = { "<C-w>l", "Move to right window" },
          -- Line navigation
          H = { "^", "Go to start of line" },
          L = { "$", "Go to end of line" },
          -- Cursor position jump
          ["<leader>["] = { "<C-o>", "Go to previous cursor position" },
          ["<leader>]" ] = { "<C-i>", "Go to next cursor position" },
          -- Quickfix navigation
          ["[q"] = { "<cmd>cnext<cr>", "Next quickfix item" },
          ["]q"] = { "<cmd>cprev<cr>", "Previous quickfix item" },
          -- Git hunk navigation
          ["[g"] = { "<cmd>Gitsigns prev_hunk<cr>", "Previous Git Hunk" },
          ["]g"] = { "<cmd>Gitsigns next_hunk<cr>", "Next Git Hunk" },
          -- Buffer navigation (Alt keys)
          ["<A-,>"] = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
          ["<A-.>"] = { "<cmd>BufferNext<cr>", "Next Buffer" },
          ["<A-<>"] = { "<cmd>BufferMovePrevious<cr>", "Move Buffer Left" },
          ["<A->>"] = { "<cmd>BufferMoveNext<cr>", "Move Buffer Right" },
          ["<A-c>"] = { "<cmd>BufferClose<cr>", "Close Buffer" },
          ["<A-p>"] = { "<cmd>BufferPin<cr>", "Pin/Unpin Buffer" },
          ["<A-1>"] = { "<cmd>BufferGoto 1<cr>", "Go to Buffer 1" },
          ["<A-2>"] = { "<cmd>BufferGoto 2<cr>", "Go to Buffer 2" },
          ["<A-3>"] = { "<cmd>BufferGoto 3<cr>", "Go to Buffer 3" },
          ["<A-4>"] = { "<cmd>BufferGoto 4<cr>", "Go to Buffer 4" },
          ["<A-5>"] = { "<cmd>BufferGoto 5<cr>", "Go to Buffer 5" },
          ["<A-6>"] = { "<cmd>BufferGoto 6<cr>", "Go to Buffer 6" },
          ["<A-7>"] = { "<cmd>BufferGoto 7<cr>", "Go to Buffer 7" },
          ["<A-8>"] = { "<cmd>BufferGoto 8<cr>", "Go to Buffer 8" },
          ["<A-9>"] = { "<cmd>BufferLast<cr>", "Go to Last Buffer" },
          -- Tab navigation
          ["<Tab>"] = { "<cmd>BufferNext<cr>", "Next Buffer" },
          ["<S-Tab>"] = { "<cmd>BufferPrevious<cr>", "Previous Buffer" },
          -- Diagnostic navigation
          ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
          ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
          -- LSP navigation
          gd = { vim.lsp.buf.definition, "Go to Definition" },
          gD = { "<cmd>TroubleToggle lsp_definitions<cr>", "LSP Definitions (Trouble)" },
          gi = { "<cmd>TroubleToggle lsp_implementations<cr>", "LSP Implementations (Trouble)" },
          gR = { "<cmd>TroubleToggle lsp_references<cr>", "LSP References (Trouble)" },
          gT = { "<cmd>TroubleToggle lsp_type_definitions<cr>", "LSP Type Definitions (Trouble)" },
        })
  
        -- Visual mode mappings
        local visual_mappings = {
          H = { "^", "Go to start of line" },
          L = { "$", "Go to end of line" },
        }
  
        -- Register all mappings
        wk.register(mappings)
        wk.register(visual_mappings, { mode = "v" })
  
        -- Buffer-local LSP keymaps on attach
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function()
            wk.register({
              gr = { vim.lsp.buf.references, "Show References" },
              K = { vim.lsp.buf.hover, "Show Documentation" },
              ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature Help" },
              gs = { vim.lsp.buf.document_symbol, "Document Symbols" },
              gS = { vim.lsp.buf.workspace_symbol, "Workspace Symbols" },
              gt = { vim.lsp.buf.type_definition, "Go to Type Definition" },
            })
          end,
          desc = "Set up LSP keymaps when attaching to a buffer",
        })
  
        -- Theme commands
        vim.api.nvim_create_user_command('NextTheme', themes_module.next, {})
        vim.api.nvim_create_user_command('PreviousTheme', themes_module.previous, {})
        vim.api.nvim_create_user_command('CycleTheme', themes_module.cycle, {})
      end,
    },
  }