-- ftplugin/java.lua
-- This file is automatically loaded for Java files
-- It starts nvim-jdtls with our custom configuration

local ok, java_config = pcall(require, "plugins.java")
if ok then
	java_config.start()
else
	vim.notify("Failed to load Java configuration", vim.log.levels.WARN)
end
