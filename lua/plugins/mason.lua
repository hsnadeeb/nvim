return {
    {
      repo = "williamboman/mason.nvim",
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("mason").setup({
          ui = { border = "rounded" },
        })
        require("mason-tool-installer").setup({
          ensure_installed = {
            "typescript-language-server", "html", "cssls", "eslint", "gopls", "jdtls",
            "prettier", "goimports",
            "java-debug-adapter", "delve",
          },
          auto_update = true,
          run_on_start = true,
        })
        require("mason-lspconfig").setup({
          ensure_installed = { "ts_ls", "html", "cssls", "eslint", "gopls", "jdtls" },
          automatic_installation = true,
        })
      end,
    },
  }