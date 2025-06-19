local M = {}

-- Available themes
M.themes = {
  "decay",
  "tokyonight",
  "kanagawa",
  "catppuccin",
  "everforest",
  "onedark"
}

-- Current theme index (5 is everforest)
M.current_theme = 5

-- Set a specific theme by index
function M.set_theme(index)
  M.current_theme = index
  local theme = M.themes[M.current_theme]
  
  -- Try to properly load each theme with their setup if needed
  if theme == "decay" then
    require("decay").setup({ style = "dark" })
  elseif theme == "tokyonight" then
    require("tokyonight").setup({ style = "storm" })
  elseif theme == "catppuccin" then
    require("catppuccin").setup({ flavour = "mocha" })
  elseif theme == "everforest" then
    vim.g.everforest_background = "medium"
    vim.g.everforest_better_performance = 1
  elseif theme == "onedark" then
    require("onedark").setup({ style = "dark" })
  end
  
  -- Set the colorscheme
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
  if status_ok then
    print("Theme switched to: " .. theme)
  else
    print("Failed to switch to theme: " .. theme)
    -- Fallback to everforest if the selected theme fails
    if theme ~= "everforest" then
      vim.cmd("colorscheme everforest")
      print("Fallback to everforest theme")
    end
  end
end

-- Cycle to the next theme
function M.next_theme()
  M.current_theme = (M.current_theme % #M.themes) + 1
  M.set_theme(M.current_theme)
end

return M