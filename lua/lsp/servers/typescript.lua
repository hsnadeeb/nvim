local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local M = {}

function M.setup()
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
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
end

return M
