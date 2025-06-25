local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local M = {}

function M.setup()
  lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = require('lsp.handlers').on_attach,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'basic',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
        },
      },
    },
    root_dir = lspconfig.util.root_pattern('.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt'),
  })
end

return M
