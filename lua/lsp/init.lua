-- ============================================================================
-- LSP Configuration (Compatible with Neovim 0.11+)
-- ============================================================================

local M = {}

local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }
  local map = vim.keymap.set

  -- Navigation
  map('n', 'gD', vim.lsp.buf.declaration, opts)
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gi', vim.lsp.buf.implementation, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
  map('n', 'gt', vim.lsp.buf.type_definition, opts)

  -- Documentation
  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, opts)

  -- Code actions
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

  -- Diagnostics
  map('n', '[d', vim.diagnostic.goto_prev, opts)
  map('n', ']d', vim.diagnostic.goto_next, opts)
  map('n', '<leader>d', vim.diagnostic.open_float, opts)
  map('n', '<leader>q', vim.diagnostic.setloclist, opts)

  -- Document highlighting
  if client.server_capabilities.documentHighlightProvider then
    local highlight_group = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      group = highlight_group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      buffer = bufnr,
      group = highlight_group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Inlay hints (Neovim 0.10+)
  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local function setup_diagnostics()
  -- Diagnostic signs (Neovim 0.10+ format)
  local signs = {
    [vim.diagnostic.severity.ERROR] = '',
    [vim.diagnostic.severity.WARN] = '',
    [vim.diagnostic.severity.HINT] = '',
    [vim.diagnostic.severity.INFO] = '',
  }

  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      spacing = 4,
      source = 'if_many',
    },
    float = {
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
    signs = {
      text = signs,
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

function M.setup()
  setup_diagnostics()

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Update capabilities with nvim-cmp if available
  local ok_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  -- Common server options
  local default_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  -- Server configurations
  local servers = {
    ts_ls = {
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    },
    html = {},
    cssls = {},
    eslint = {
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
    },
    gopls = {
      filetypes = { 'go', 'gomod' },
    },
    jsonls = {},
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    },
  }

  -- Use vim.lsp.config for Neovim 0.11+ (modern way)
  -- Fall back to lspconfig for older versions
  local has_native_config = vim.fn.has('nvim-0.11') == 1
  
  if has_native_config then
    -- Neovim 0.11+ native LSP configuration
    for server, config in pairs(servers) do
      local opts = vim.tbl_deep_extend('force', default_opts, config)
      vim.lsp.config[server] = opts
      vim.lsp.enable(server)
    end
  else
    -- Legacy lspconfig for older versions
    local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
    if ok_lspconfig then
      for server, config in pairs(servers) do
        local opts = vim.tbl_deep_extend('force', default_opts, config)
        lspconfig[server].setup(opts)
      end
    end
  end

  -- Setup mason-lspconfig for automatic server management
  local ok_mason, mason_lspconfig = pcall(require, 'mason-lspconfig')
  if ok_mason then
    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
    })
  end
end

M.setup()

return M
