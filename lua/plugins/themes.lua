local M = {}

-- Cache for loaded themes to prevent redundant loading
local _M = {}
local theme_cache = {}

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

-- Theme configurations
local theme_configs = {
  decay = function()
    require("decay").setup({ style = "dark" })
  end,
  tokyonight = function()
    require("tokyonight").setup({ style = "storm" })
  end,
  catppuccin = function()
    require("catppuccin").setup({ flavour = "mocha" })
  end,
  everforest = function()
    vim.g.everforest_background = "medium"
    vim.g.everforest_better_performance = 1
    vim.g.everforest_disable_italic_comment = 1
  end,
  onedark = function()
    require("onedark").setup({ style = "dark" })
  end
}

-- Initialize the default theme
function M.setup()
  if not _M.initialized then
    _M.initialized = true
    M.set_theme(M.current_theme)
  end
end

-- Define nvim-tree diagnostic signs (only once)
if not _M.signs_defined then
  local signs = {
    { name = "NvimTreeDiagnosticErrorIcon", text = "" },
    { name = "NvimTreeDiagnosticWarnIcon", text = "" },
    { name = "NvimTreeDiagnosticInfoIcon", text = "" },
    { name = "NvimTreeDiagnosticHintIcon", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name })
  end
  _M.signs_defined = true
end

-- Set a specific theme by index
function M.set_theme(index)
  -- Only proceed if the theme is different or not yet loaded
  if _M.current_theme_index == index and theme_cache[index] then
    return
  end

  M.current_theme = index
  local theme = M.themes[M.current_theme]
  
  if not theme then
    vim.notify("Invalid theme index: " .. tostring(index), vim.log.levels.ERROR)
    return
  end

  -- Configure the theme if not already configured
  if not theme_cache[theme] then
    local config = theme_configs[theme]
    if config then
      local ok, err = pcall(config)
      if not ok then
        vim.notify("Error configuring theme " .. theme .. ": " .. tostring(err), vim.log.levels.ERROR)
      end
    end
    theme_cache[theme] = true
  end

  -- Set the colorscheme
  local status_ok, err = pcall(vim.cmd, "colorscheme " .. theme)
  if status_ok then
    _M.current_theme_index = index
    _M.current_theme_name = theme
    vim.g.colors_name = theme  -- Set the global colors_name variable
  else
    vim.notify("Failed to load theme " .. theme .. ": " .. tostring(err), vim.log.levels.ERROR)
    -- Fallback to everforest if the selected theme fails
    if theme ~= "everforest" then
      vim.cmd("colorscheme everforest")
      _M.current_theme_name = "everforest"
      vim.g.colors_name = "everforest"
    end
  end
end

-- Cycle to the next theme
function M.next_theme()
  local next_theme = (M.current_theme % #M.themes) + 1
  M.set_theme(next_theme)
end

-- Add a function to get current theme info
function M.get_current_theme()
  return {
    name = M.themes[M.current_theme] or "unknown",
    index = M.current_theme
  }
end

return M
