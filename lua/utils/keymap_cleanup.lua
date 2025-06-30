local M = {}

function M.cleanup()
  -- Function to safely unmap keys using multiple methods
  local function safe_unmap(mode, key)
    -- Try to get the current mapping first
    local ok, result = pcall(vim.api.nvim_get_keymap, mode)
    if ok then
      for _, map in ipairs(result) do
        if map.lhs == key then
          -- Try the new API first
          pcall(vim.keymap.del, mode, key)
          -- Then try the old API
          pcall(vim.api.nvim_del_keymap, mode, key)
          -- Finally try the vim.cmd way
          local mode_prefix = mode == 'n' and 'n' or mode
          pcall(vim.cmd, string.format('%sunmap %s', mode_prefix, key))
        end
      end
    end
  end

  -- List of problematic keys to clean up
  local keys_to_clean = {
    {mode = 'n', key = 'gc'},
    {mode = 'v', key = 'gc'},
    {mode = 'n', key = 'gb'},
    {mode = 'v', key = 'gb'},
    {mode = 'n', key = ' e'},
    {mode = 'n', key = 'e'},
  }

  -- Clean up each key
  for _, item in ipairs(keys_to_clean) do
    safe_unmap(item.mode, item.key)
  end

  -- Set explicit no-op mappings to prevent warnings
  vim.keymap.set('n', ' e', function() end, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Disabled keymap'
  })

  vim.keymap.set('n', 'e', function() end, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Disabled keymap'
  })
end

return M
