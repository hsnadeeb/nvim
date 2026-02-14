-- LSP Configuration (lazy-loaded after plugins)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local ok, _ = pcall(require, "lspconfig")
    if not ok then return end
    
    local util = require("lspconfig.util")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

    local border = {
      { "╭", "FloatBorder" }, { "─", "FloatBorder" }, { "╮", "FloatBorder" },
      { "│", "FloatBorder" }, { "╯", "FloatBorder" }, { "─", "FloatBorder" },
      { "╰", "FloatBorder" }, { "│", "FloatBorder" },
    }

    local handlers = {
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
    }

    local on_attach = function(client, bufnr)
      if client.name == "ts_ls" or client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
      end
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
    end

    local function setup_server(name, opts)
      local ok, server = pcall(require, "lspconfig.configs." .. name)
      if ok and server and server.setup then
        server.setup(opts)
        return true
      end
      return false
    end

    local ts_opts = {
      capabilities = capabilities, on_attach = on_attach,
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
    }
    setup_server("ts_ls", ts_opts)
    setup_server("html", { capabilities = capabilities, on_attach = on_attach })
    setup_server("cssls", { capabilities = capabilities, on_attach = on_attach })
    setup_server("eslint", { capabilities = capabilities, on_attach = on_attach })
    setup_server("gopls", { capabilities = capabilities, on_attach = on_attach, settings = { gopls = { analyses = { unusedparams = true } } } })
    setup_server("jsonls", { capabilities = capabilities, on_attach = on_attach })
    setup_server("lua_ls", { capabilities = capabilities, on_attach = on_attach, settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
  end,
})
