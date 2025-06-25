-- Main LSP configuration
-- This file initializes the LSP module with all its components

local M = {}

-- Initialize LSP with all configurations
function M.setup()
  -- Setup LSP servers and handlers
  require('lsp.init').setup()
  
  -- Notify user that LSP is ready
  vim.notify('LSP configuration loaded', vim.log.levels.INFO)
end

return M
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