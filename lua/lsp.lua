-- LSP configuration
-- nvim-lspconfig on Nvim 0.11 deprecates `require('lspconfig')`.
-- To keep things quiet (and future-proof), require server configs directly.
local ok_util, util = pcall(require, 'lspconfig.util')
if not ok_util then
  vim.notify('nvim-lspconfig not found (missing lspconfig.util)', vim.log.levels.ERROR)
  return
end

local function setup_server(name, opts)
  local ok, server = pcall(require, 'lspconfig.configs.' .. name)
  if ok and server and server.setup then
    server.setup(opts)
    return true
  end
  return false
end

-- Capabilities (integrate with nvim-cmp if present)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

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
local ts_opts = {
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
}

-- TypeScript/JavaScript/React
if not setup_server('ts_ls', ts_opts) then
  -- fallback for older setups
  setup_server('tsserver', ts_opts)
end

-- HTML
setup_server('html', { capabilities = capabilities, on_attach = on_attach })

-- CSS
setup_server('cssls', { capabilities = capabilities, on_attach = on_attach })

-- ESLint
setup_server('eslint', { capabilities = capabilities, on_attach = on_attach })

-- Go
setup_server('gopls', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

-- Java (jdtls) - Using nvim-jdtls for enhanced support
-- Note: jdtls is started via ftplugin/java.lua for better control
-- setup_server('jdtls', {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- })

-- JSON
setup_server('jsonls', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Lua (for Neovim config and plugins)
setup_server('lua_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})
