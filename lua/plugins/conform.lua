-- local vim = require("vim")

return {
  {
    repo = "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          go = { "goimports" },
        },
        formatters = {
          prettier = {
            command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
          },
          goimports = {
            command = vim.fn.stdpath("data") .. "/mason/bin/goimports",
          },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}