local M = {}

-- Safe require function that handles errors gracefully
function M.safe_require(module)
  local ok, mod = pcall(require, module)
  if not ok then
    vim.notify("Could not load module: " .. module, vim.log.levels.WARN)
    return nil
  end
  return mod
end

-- Helper function for setting keymaps with default options
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then 
    options = vim.tbl_extend('force', options, opts) 
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Check if a file exists
function M.file_exists(file)
  local f = io.open(file, "r")
  if f then f:close() end
  return f ~= nil
end

-- Print a table for debugging
function M.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

return M