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

-- Common on_attach function for LSP clients with enhanced features
local on_attach = function(client, bufnr)
  -- Disable formatting for specific LSPs (use null-ls or formatter.nvim instead)
  if client.name == 'tsserver' or client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings for LSP functionality
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- Navigation
  map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
  map('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to declaration' })
  map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to implementation' })
  map('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'Show references' })
  map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Show documentation' })
  map('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Show signature help' })

  -- Workspace
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = 'Add workspace folder' })
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = 'Remove workspace folder' })
  map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    { buffer = bufnr, desc = 'List workspace folders' })

  -- Code actions and refactoring
  map('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol' })
  map('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
  map('v', '<leader>ca', ':<C-U>vsplit | lua vim.lsp.buf.range_code_action()<CR>',
    { buffer = bufnr, desc = 'Range code action' })

  -- Formatting
  map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end,
    { buffer = bufnr, desc = 'Format buffer' })

  -- Type definition
  map('n', 'gt', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Go to type definition' })

  -- Show line diagnostics in a floating window
  map('n', 'gl', vim.diagnostic.open_float, { buffer = bufnr, desc = 'Show line diagnostics' })

  -- Diagnostic navigation
  map('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = 'Previous diagnostic' })
  map('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = 'Next diagnostic' })

  -- Show diagnostics in a floating window
  map('n', '<leader>d', vim.diagnostic.setloclist, { buffer = bufnr, desc = 'Show diagnostics' })

  -- Signature help on trigger characters
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

