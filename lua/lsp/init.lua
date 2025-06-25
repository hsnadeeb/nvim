local M = {}

-- Import modules
local handlers = require('lsp.handlers')
local servers = {
  'tsserver',
  'html',
  'cssls',
  'eslint',
  'pyright',
  'jdtls',
  'gopls',
  -- Add other servers here
}

-- Server specific configurations
local server_configs = {
  tsserver = require('lsp.servers.typescript'),
  pyright = require('lsp.servers.python'),
  jdtls = require('lsp.servers.java'),
  gopls = require('lsp.servers.go'),
}

-- Setup LSP servers
function M.setup()
  -- Setup capabilities
  local capabilities = handlers.setup_capabilities()
  
  -- Common LSP settings
  local lspconfig = require('lspconfig')
  
  -- Setup each LSP server
  for _, server in ipairs(servers) do
    local config = {
      capabilities = capabilities,
      on_attach = handlers.on_attach,
      flags = {
        debounce_text_changes = 150,
      },
    }
    
    -- Server specific configurations
    if server_configs[server] then
      server_configs[server].setup()
    else
      -- Default setup for servers without specific config
      lspconfig[server].setup(config)
    end
  end
  
  -- Configure diagnostic signs and virtual text
  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  
  -- Configure diagnostic display
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●', -- Could be '●', '■', '▎', 'x'
    },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })
  
  -- Show line diagnostics automatically in hover window
  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
      if vim.lsp.buf.server_ready() then
        vim.diagnostic.open_float(nil, {
          focusable = false,
          close_events = { 'BufEnter', 'CursorMoved', 'InsertEnter', 'FocusLost' },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
        })
      end
    end,
  })
  
  -- LSP handlers configuration
  for type, handler in pairs(handlers.handlers) do
    vim.lsp.handlers[type] = handler
  end
  
  -- Notify when LSP server is ready
  vim.notify('LSP servers initialized')
end

return M
