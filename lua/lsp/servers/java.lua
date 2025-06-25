local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local handlers = require('lsp.handlers')

local M = {}

function M.setup()
  -- Find the path to the JDTLS installation
  local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
  
  -- Only setup if JDTLS is installed
  if vim.fn.isdirectory(jdtls_path) == 0 then
    vim.notify('JDTLS not found. Install it with :MasonInstall jdtls', vim.log.levels.WARN)
    return
  end

  lspconfig.jdtls.setup({
    capabilities = capabilities,
    on_attach = handlers.on_attach,
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
      '-configuration', jdtls_path .. '/config_mac',
      '-data', vim.fn.getcwd()
    },
    root_dir = lspconfig.util.root_pattern('.git', 'pom.xml', 'build.gradle', 'build.xml'),
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = 'JavaSE-17',
              path = '/usr/local/opt/openjdk@17',
              default = true
            }
          }
        },
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            'org.junit.Assert.*',
            'org.junit.Assume.*',
            'org.junit.jupiter.api.Assertions.*',
            'org.junit.jupiter.api.Assumptions.*',
            'org.junit.jupiter.api.DynamicContainer.*',
            'org.junit.jupiter.api.DynamicTest.*',
            'org.mockito.Mockito.*',
            'org.mockito.ArgumentMatchers.*',
            'org.mockito.Answers.*',
            'org.hamcrest.MatcherAssert.*',
            'org.hamcrest.Matchers.*',
          },
          importOrder = {
            'java',
            'javax',
            'com',
            'org',
            '#'
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
          },
          useBlocks = true,
        },
      },
    },
    init_options = {
      bundles = {},
    },
  })
end

return M
