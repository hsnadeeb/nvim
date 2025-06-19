-- LSP configurations
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Common on_attach function for LSP clients
local on_attach = function(client, bufnr)
  -- Disable formatting for TypeScript LSP (use null-ls or formatter.nvim instead)
  if client.name == 'tsserver' or client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
  -- Show line diagnostics automatically in hover window
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { 'BufEnter', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(bufnr, opts)
    end
  })
end

-- TypeScript/JavaScript/React
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
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
        enable = false, -- Use null-ls or formatter.nvim for formatting
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
        enable = false, -- Use null-ls or formatter.nvim for formatting
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
lspconfig.html.setup({ capabilities = capabilities })

-- CSS
lspconfig.cssls.setup({ capabilities = capabilities })

-- ESLint
lspconfig.eslint.setup({ capabilities = capabilities })

-- Go
lspconfig.gopls.setup({
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

-- Java (jdtls for Spring Boot)
lspconfig.jdtls.setup({
  capabilities = capabilities,
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = "/opt/homebrew/opt/openjdk@17", -- Updated for macOS
          },
        },
      },
    },
  },
})