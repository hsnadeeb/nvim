-- Use project-aware JDTLS for Java buffers.
pcall(function()
  require("config.java").start_or_attach()
end)

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
