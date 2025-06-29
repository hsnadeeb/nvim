local M = {}

-- Path to store the theme cache
local cache_file = vim.fn.stdpath('config') .. '/.theme_cache'

-- Function to save the current theme
function M.save_theme(theme_name)
  local file = io.open(cache_file, 'w')
  if file then
    file:write(theme_name)
    file:close()
    return true
  end
  return false
end

-- Function to load the saved theme
function M.load_theme()
  local file = io.open(cache_file, 'r')
  if file then
    local theme = file:read('*line')
    file:close()
    if theme and theme ~= '' then
      return theme
    end
  end
  return 'everforest'  -- Default theme
end

return M
