local M = {}

-- Enhanced capabilities with nvim-cmp
function M.setup_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  return capabilities
end

-- Common on_attach function for LSP clients
function M.on_attach(client, bufnr)
  -- Disable formatting for specific LSPs (use null-ls or formatter.nvim instead)
  if client.name == 'tsserver' or client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
  -- Set up keybindings and other LSP features
  require('lsp.keybindings').setup(client, bufnr)
end

-- Border style for floating windows
M.border = {
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' }
}

-- Default handlers with UI enhancements
M.handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = M.border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = M.border }),
}

return M
