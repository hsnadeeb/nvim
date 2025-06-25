local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local handlers = require('lsp.handlers')

local M = {}

function M.setup()
  lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = handlers.on_attach,
    cmd = {'gopls'},
    filetypes = {'go', 'gomod', 'gowork', 'gotmpl'},
    root_dir = lspconfig.util.root_pattern('go.work', 'go.mod', '.git'),
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
          unusedwrite = true,
          shadow = true,
          nilness = true,
          unusedvariable = true,
        },
        staticcheck = true,
        codelenses = {
          generate = true,
          gc_details = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
    init_options = {
      usePlaceholders = true,
    },
  })
end

return M
