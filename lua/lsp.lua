-- Ensure LSP config is properly required
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local keybindings = require('keybindings')

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

-- Common capabilities for LSP clients
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Common on_attach function for LSP clients
local on_attach = function(client, bufnr)
  -- Disable formatting for specific LSPs (use null-ls or formatter.nvim instead)
  if client.name == 'tsserver' or client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  
  -- Call the keybindings setup
  keybindings.on_attach(client, bufnr)
  
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
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

-- Common settings for LSP servers
local function make_config()
  return {
    capabilities = capabilities,
    on_attach = on_attach,
    handlers = handlers,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

-- Setup LSP servers with common config
local servers = { 'pyright', 'rust_analyzer', 'gopls', 'lua_ls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup(make_config())
end

-- TypeScript/JavaScript setup with typescript-tools.nvim
-- Configuration is handled by the plugin itself
-- This is just a minimal setup to ensure LSP features work

-- Only setup ts_ls as a fallback if typescript-tools is not available
if not pcall(require, 'typescript-tools') then
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
    root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
    single_file_support = true,
    settings = {
      typescript = {
        format = { enable = false },
        inlayHints = { enable = false },
        suggestions = { enabled = false },
      },
      javascript = {
        format = { enable = false },
        inlayHints = { enable = false },
        suggestions = { enabled = false },
      },
    },
  })
end

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