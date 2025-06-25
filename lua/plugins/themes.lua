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

-- Initialize the default theme
function M.setup()
  M.set_theme(M.current_theme)
end

-- Define nvim-tree diagnostic signs
local function setup_nvim_tree_signs()
  local signs = {
    { name = "NvimTreeDiagnosticErrorIcon", text = "" },
    { name = "NvimTreeDiagnosticWarnIcon", text = "" },
    { name = "NvimTreeDiagnosticInfoIcon", text = "" },
    { name = "NvimTreeDiagnosticHintIcon", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name })
  end
end

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
    -- Re-setup signs after colorscheme change
    setup_nvim_tree_signs()
    print("Theme switched to: " .. theme)
  else
    print("Failed to switch to theme: " .. theme)
    -- Fallback to everforest if the selected theme fails
    if theme ~= "everforest" then
      vim.cmd("colorscheme everforest")
      setup_nvim_tree_signs()
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
