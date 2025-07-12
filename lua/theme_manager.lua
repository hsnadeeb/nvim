-- local vim = require("vim")

local M = {}

local theme_persistence = require('theme_persistence')
local themes = {
  { name = "everforest", cmd = "colorscheme everforest" },
  { name = "gruvbox", cmd = "colorscheme gruvbox" },
  { name = "solarized-osaka", cmd = "colorscheme solarized-osaka" },
  { name = "decay", cmd = "colorscheme decay" },
  { name = "material", cmd = "colorscheme material" },
}
local current_index = 1

-- Load saved theme
local saved_theme = theme_persistence.load_theme()
for i, theme in ipairs(themes) do
  if theme.name == saved_theme then
    current_index = i
    pcall(vim.cmd, theme.cmd)
    break
  end
end

-- Setup function
function M.setup()
  pcall(vim.cmd, themes[current_index].cmd)
end

-- Next theme
function M.next()
  current_index = current_index % #themes + 1
  pcall(vim.cmd, themes[current_index].cmd)
  theme_persistence.save_theme(themes[current_index].name)
  vim.notify("Theme: " .. themes[current_index].name, vim.log.levels.INFO)
end

-- Previous theme
function M.previous()
  current_index = current_index - 1
  if current_index < 1 then
    current_index = #themes
  end
  pcall(vim.cmd, themes[current_index].cmd)
  theme_persistence.save_theme(themes[current_index].name)
  vim.notify("Theme: " .. themes[current_index].name, vim.log.levels.INFO)
end

-- Cycle theme
function M.cycle()
  M.next()
end

return M