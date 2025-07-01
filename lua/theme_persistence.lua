local M = {}

-- Cache file path
local cache_file = vim.fn.stdpath('config') .. '/.theme_cache'

-- In-memory cache to avoid repeated file I/O
local cached_theme = nil
local cache_dirty = false

-- Async file operations to prevent blocking
local function write_file_async(filepath, content, callback)
  vim.schedule(function()
    local file = io.open(filepath, 'w')
    local success = false
    
    if file then
      local bytes_written = file:write(content)
      file:close()
      success = bytes_written ~= nil
    end
    
    if callback then
      callback(success)
    end
  end)
end

-- Save theme with debouncing to prevent excessive writes
local save_timer = nil
function M.save_theme(theme_name)
  if not theme_name or theme_name == '' then
    return false
  end
  
  -- Update memory cache immediately
  cached_theme = theme_name
  cache_dirty = true
  
  -- Debounce file writes
  if save_timer then
    save_timer:stop()
  end
  
  save_timer = vim.defer_fn(function()
    if cache_dirty then
      write_file_async(cache_file, theme_name, function(success)
        if success then
          cache_dirty = false
        else
          vim.notify("Failed to save theme preference", vim.log.levels.WARN)
        end
      end)
    end
  end, 500) -- 500ms debounce
  
  return true
end

-- Load theme with caching
function M.load_theme()
  -- Return cached theme if available
  if cached_theme then
    return cached_theme
  end
  
  -- Try to read from file
  local file = io.open(cache_file, 'r')
  if file then
    local theme = file:read('*line')
    file:close()
    
    if theme and theme ~= '' then
      cached_theme = theme
      return theme
    end
  end
  
  -- Default theme
  local default_theme = 'everforest'
  cached_theme = default_theme
  return default_theme
end

-- Clear cache (useful for testing)
function M.clear_cache()
  cached_theme = nil
  cache_dirty = false
  if save_timer then
    save_timer:stop()
    save_timer = nil
  end
end

-- Get cache status (useful for debugging)
function M.get_cache_status()
  return {
    cached_theme = cached_theme,
    cache_dirty = cache_dirty,
    cache_file = cache_file
  }
end

return M