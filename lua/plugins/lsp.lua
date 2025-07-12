-- local vim = require("vim")
return {
    {
    --   config = {"neovim/nvim-lspconfig"},
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "hrsh7th/nvim-cmp",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        local lspconfig = require('lspconfig')
        local util = require('lspconfig.util')
        local cmp_lsp = require('cmp_nvim_lsp')
  
        -- Define capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = cmp_lsp.default_capabilities(capabilities)
  
        -- Border configuration for floating windows
        local border = {
          { '╭', 'FloatBorder' },
          { '─', 'FloatBorder' },
          { '╮', 'FloatBorder' },
          { '│', 'FloatBorder' },
          { '╯', 'FloatBorder' },
          { '─', 'FloatBorder' },
          { '╰', 'FloatBorder' },
          { '│', 'FloatBorder' }
        }
  
        -- Override handlers for better UI
        local handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
        }
  
        -- Common on_attach function
        local on_attach = function(client, bufnr)
          if client.name == 'tsserver' or client.name == 'ts_ls' then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
            vim.api.nvim_create_autocmd('CursorHold', {
              callback = vim.lsp.buf.document_highlight,
              buffer = bufnr,
              group = 'lsp_document_highlight',
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
              callback = vim.lsp.buf.clear_references,
              buffer = bufnr,
              group = 'lsp_document_highlight',
            })
          end
        end
  
        -- TypeScript/JavaScript/React
        lspconfig.ts_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
          root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
          single_file_support = true,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                completeFunctionCalls = true,
                autoImports = true,
                importModuleSpecifier = 'shortest',
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
              },
              format = {
                enable = false,
              },
              updateImportsOnFileMove = {
                enable = true,
              },
              preferences = {
                importModuleSpecifierPreference = 'shortest',
                quotePreference = 'single',
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
              suggest = {
                completeFunctionCalls = true,
                autoImports = true,
                importModuleSpecifier = 'shortest',
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
              },
              format = {
                enable = false,
              },
              preferences = {
                importModuleSpecifierPreference = 'shortest',
                quotePreference = 'single',
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
          init_options = {
            hostInfo = 'neovim',
            preferences = {
              disableSuggestions = false,
              importModuleSpecifierPreference = 'shortest',
              includePackageJsonAutoImports = 'on',
            },
          },
        })
  
        -- HTML
        lspconfig.html.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
        })
  
        -- CSS
        lspconfig.cssls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
        })
  
        -- ESLint
        lspconfig.eslint.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
        })
  
        -- Go
        lspconfig.gopls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
            },
          },
        })
  
        -- Java (jdtls)
        lspconfig.jdtls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-17",
                    path = "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home",
                    default = true
                  },
                },
              },
            },
          },
        })
      end,
    },
  }