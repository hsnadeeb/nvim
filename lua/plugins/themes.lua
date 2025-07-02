local M = {}

-- Theme configurations with lazy loading
local themes = {
  {
    name = 'everforest',
    setup = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_better_performance = 1
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_line_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = 'colored'
      vim.cmd.colorscheme('everforest')
    end
  },
  {
    name = 'gruvbox',
    setup = function()
      vim.g.gruvbox_contrast_dark = 'hard'
      vim.g.gruvbox_invert_selection = 0
      vim.g.gruvbox_italic = 1
      vim.g.gruvbox_bold = 1
      vim.cmd.colorscheme('gruvbox')
    end
  },
  {
    name = 'solarized-osaka',
    setup = function()
      local ok, solarized = pcall(require, 'solarized-osaka')
      if ok then
        solarized.setup({
          style = 'storm',
          transparent = false,
          colors = { base00 = '#1c2526' }
        })
        vim.cmd.colorscheme('solarized-osaka')
      end
    end
  },
  {
    name = 'decay',
    setup = function()
      local ok, decay = pcall(require, 'decay')
      if ok then
        decay.setup({
          style = 'decay',
          nvim_tree = { contrast = true },
          cmp = { block_kind = true },
          lsp = {
            virtual_text = 'undercurl',
            underlines = {
              errors = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
              hints = { 'undercurl' },
            },
          },
          palette = {
            background = "#0f1112",
            comment = "#6c7086",
            black = "#1a1c23",
            red = "#f87070",
            green = "#79dcaa",
            yellow = "#ffe59e",
            blue = "#7ab0df",
            magenta = "#c397d8",
            cyan = "#70c0ba",
            white = "#c5c5c5",
          }
        })
        vim.cmd.colorscheme('decay')
        
        -- Apply custom highlights
        vim.cmd([[
          hi! link NvimTreeFolderIcon NvimTreeFolderName
          hi! link NvimTreeIndentMarker Comment
          hi! link NvimTreeGitDirty DiffChange
          hi! link NvimTreeGitStaged DiffAdd
          hi! link NvimTreeGitRenamed DiffChange
          hi! link NvimTreeGitNew DiffAdd
          hi! link NvimTreeGitDeleted DiffDelete
        ]])
      end
    end
  },
  {
    name = 'material',
    setup = function()
      vim.g.material_style = "oceanic"
      local ok, material = pcall(require, "material")
      if ok then
        material.setup({
          contrast = { sidebars = true, floating_windows = true },
          styles = { comments = { italic = true }, keywords = { bold = true } },
          custom_colors = {
            bg = "#0c1a20",
            yellow = "#ffd700",
          }
        })
        vim.cmd.colorscheme("material")
      end
    end
  }
}

-- Theme management state
local state = {
  current = nil,
  initialized = false,
  theme_cache = {}
}

-- Theme persistence
local persistence = require('theme_persistence')

-- Theme titles for notifications
local theme_titles = {
  gruvbox = "Gruvbox",
  ["solarized-osaka"] = "Solarized Osaka",
  everforest = "Everforest",
  decay = "Decay",
  material = "Material"
}

-- Get theme by name
local function get_theme(name)
  for _, theme in ipairs(themes) do
    if theme.name == name then
      return theme
    end
  end
  return themes[1] -- Return default theme if not found
end

-- Show theme notification
local function show_theme_notification(theme_name)
  local title = theme_titles[theme_name] or theme_name:gsub("^%l", string.upper)
  vim.schedule(function()
    vim.notify(
      string.format("Theme: %s", title),
      vim.log.levels.INFO,
      { title = "Theme Switched", timeout = 1500, icon = "🎨" }
    )
  end)
end

-- Apply theme with error handling
local function apply_theme(theme_name)
  if not theme_name then return end
  
  local theme = get_theme(theme_name)
  if not theme then
    vim.notify('Theme not found: ' .. theme_name, vim.log.levels.ERROR)
    return
  end
  
  -- Clear existing highlight groups to prevent blending
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') == 1 then
    vim.cmd('syntax reset')
  end
  
  -- Apply the theme
  local ok, err = pcall(theme.setup)
  if not ok then
    vim.notify('Error applying theme ' .. theme.name .. ': ' .. tostring(err), vim.log.levels.ERROR)
    if theme_name ~= 'everforest' then
      return apply_theme('everforest') -- Fallback to default theme
    end
    return
  end
  
  -- Update state and persistence
  state.current = theme.name
  state.theme_cache[theme.name] = true
  persistence.save_theme(theme.name)
  vim.g.colors_name = theme.name
  
  -- Show notification
  show_theme_notification(theme.name)
  
  -- Trigger theme change event
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" })
  end)
  
  return theme.name
end

-- Get theme index by name
local function get_theme_index(theme_name)
  for i, theme in ipairs(themes) do
    if theme.name == theme_name then
      return i
    end
  end
  return 1 -- Default to first theme if not found
end

-- Get next theme
function M.next()
  local current = state.current or persistence.load_theme()
  local current_idx = get_theme_index(current)
  local next_idx = (current_idx % #themes) + 1
  return apply_theme(themes[next_idx].name)
end

-- Get previous theme
function M.previous()
  local current = state.current or persistence.load_theme()
  local current_idx = get_theme_index(current)
  local prev_idx = (current_idx - 2) % #themes + 1
  return apply_theme(themes[prev_idx].name)
end

-- Cycle through themes (alias for next)
function M.cycle()
  return M.next()
end

-- Set specific theme
function M.set(theme_name)
  return apply_theme(theme_name)
end

-- Get current theme name
function M.current()
  return state.current or persistence.load_theme()
end

-- Get list of available theme names
function M.list()
  return vim.tbl_map(function(t) return t.name end, themes)
end

-- Initialize theme system
function M.setup()
  if state.initialized then return end
  
  -- Set faster redraw times
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300
  
  -- Apply saved theme or default
  local theme_name = persistence.load_theme() or themes[1].name
  apply_theme(theme_name)
  
  state.initialized = true
  vim.notify('Theme system initialized: ' .. theme_name, vim.log.levels.INFO)
  
  return theme_name
end

-- Set theme by name (convenience function)
function M.set_theme_by_name(theme_name)
  if type(theme_name) ~= 'string' then
    vim.notify('Theme name must be a string', vim.log.levels.ERROR)
    return false
  end
  
  local theme = get_theme(theme_name)
  if not theme then
    vim.notify(string.format('Theme not found: %s', theme_name), vim.log.levels.ERROR)
    return false
  end
  
  return apply_theme(theme.name)
end

return M