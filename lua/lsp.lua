-- Ensure LSP config is properly required
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

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

  -- Common on_attach function for LSP clients
local on_attach = function(client, bufnr)
  -- Disable formatting for specific LSPs (use null-ls or formatter.nvim instead)
  if client.name == 'tsserver' or client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Buffer local keymaps
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation keymaps
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)

  -- Highlight symbol under cursor
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
lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })

-- CSS
lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })

-- ESLint
lspconfig.eslint.setup({ capabilities = capabilities, on_attach = on_attach })

-- Go
lspconfig.gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
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