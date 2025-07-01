local M = {}

-- Cache for loaded themes and state management
local state = {
  initialized = false,
  current_theme_name = nil,
  current_theme_index = 1,
  theme_cache = {},
  signs_defined = false
}

-- Available themes (order matters for cycling)
M.themes = {
  "everforest",  -- Default theme first
  "gruvbox",
  "solarized-osaka", 
  "decay",
  "material"
}

-- Load theme persistence module once
local theme_persistence = require('theme_persistence')

-- Optimized theme configurations with lazy loading
local theme_configs = {
  gruvbox = function()
    vim.g.gruvbox_contrast_dark = "hard"
    vim.g.gruvbox_invert_selection = 0
    vim.g.gruvbox_italic = 1
    vim.g.gruvbox_bold = 1
    
    local ok, gruvbox = pcall(require, "gruvbox")
    if ok then
      gruvbox.setup({
        overrides = {
          Normal = { bg = "#1d2021" },
          Function = { fg = "#fabd2f", bold = true },
          String = { fg = "#b8bb26", italic = true },
        }
      })
    end
    vim.cmd.colorscheme("gruvbox")
  end,
  
  ["solarized-osaka"] = function()
    local ok, solarized = pcall(require, "solarized-osaka")
    if ok then
      solarized.setup({
        style = "storm",
        transparent = false,
        colors = {
          base00 = "#1c2526",
          yellow = "#ffcc00",
        }
      })
    end
    vim.cmd.colorscheme("solarized-osaka")
  end,
  
  everforest = function()
    -- Set globals efficiently
    local everforest_opts = {
      everforest_background = "hard",
      everforest_better_performance = 1,
      everforest_disable_italic_comment = 1,
      everforest_enable_italic = 1,
      everforest_ui_contrast = "high",
      everforest_diagnostic_text_highlight = 1,
      everforest_diagnostic_line_highlight = 1,
      everforest_diagnostic_virtual_text = "colored",
      everforest_current_word = "underline",
      everforest_show_eob = 1,
      everforest_transparent_background = 0,
      everforest_dim_inactive_windows = 0,
    }
    
    for key, value in pairs(everforest_opts) do
      vim.g[key] = value
    end
    
    vim.cmd.colorscheme("everforest")
  end,
  
  decay = function()
    local ok, decay = pcall(require, "decay")
    if ok then
      decay.setup({
        style = "decay",
        italics = {
          code = true,
          comments = true,
          folds = true,
        },
        nvim_tree = { contrast = true },
        cmp = { block_kind = true },
        lsp = {
          virtual_text = 'undercurl',
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
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
    end
    
    vim.cmd.colorscheme("decay")
    
    -- Batch highlight overrides
    vim.cmd([[
      hi! link NvimTreeFolderIcon NvimTreeFolderName
      hi! link NvimTreeIndentMarker Comment
      hi! link NvimTreeGitDirty DiffChange
      hi! link NvimTreeGitStaged DiffAdd
      hi! link NvimTreeGitRenamed DiffChange
      hi! link NvimTreeGitNew DiffAdd
      hi! link NvimTreeGitDeleted DiffDelete
    ]])
  end,
  
  material = function()
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
    end
    vim.cmd.colorscheme("material")
  end
}

-- Optimized theme index lookup
local theme_index_map = {}
for i, name in ipairs(M.themes) do
  theme_index_map[name] = i
end

-- Get theme index by name (O(1) lookup)
local function get_theme_index(theme_name)
  return theme_index_map[theme_name] or 1
end

-- Safe theme loading with better error handling
local function load_theme_safely(theme_name)
  if state.theme_cache[theme_name] then
    return theme_name -- Already loaded successfully
  end
  
  local config = theme_configs[theme_name]
  if not config then
    vim.notify("Unknown theme: " .. theme_name, vim.log.levels.WARN)
    return load_theme_safely("everforest")
  end
  
  local ok, err = pcall(config)
  if not ok then
    vim.notify("Failed to load theme " .. theme_name .. ": " .. tostring(err), vim.log.levels.ERROR)
    if theme_name ~= "everforest" then
      return load_theme_safely("everforest")
    end
    return nil
  end
  
  state.theme_cache[theme_name] = true
  return theme_name
end

-- Define diagnostic signs once
local function define_signs()
  if state.signs_defined then return end
  
  local signs = {
    { name = "NvimTreeDiagnosticErrorIcon", text = "" },
    { name = "NvimTreeDiagnosticWarnIcon", text = "" }, 
    { name = "NvimTreeDiagnosticInfoIcon", text = "" },
    { name = "NvimTreeDiagnosticHintIcon", text = "" },
  }
  
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name })
  end
  
  state.signs_defined = true
end

-- Optimized notification system
local function show_theme_notification(theme_name)
  local theme_titles = {
    gruvbox = "Gruvbox",
    ["solarized-osaka"] = "Solarized Osaka",
    everforest = "Everforest", 
    decay = "Decay",
    material = "Material"
  }
  
  local title = theme_titles[theme_name] or theme_name:gsub("^%l", string.upper)
  
  -- Use vim.schedule to avoid blocking
  vim.schedule(function()
    vim.notify(
      string.format("Theme: %s", title),
      vim.log.levels.INFO,
      { title = "Theme Switched", timeout = 1500, icon = "🎨" }
    )
  end)
end

-- Initialize theme system
function M.setup()
  if state.initialized then return end
  
  -- Set faster redraw times
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300
  
  -- Load saved theme or use default
  local saved_theme = vim.g.saved_theme or "everforest"
  local theme_index = get_theme_index(saved_theme)
  
  -- Load the theme
  local loaded_theme = load_theme_safely(M.themes[theme_index])
  if not loaded_theme then
    vim.notify("Critical: Could not load any theme!", vim.log.levels.ERROR)
    return
  end
  
  -- Update state
  state.current_theme_name = loaded_theme
  state.current_theme_index = get_theme_index(loaded_theme)
  M.current_theme = state.current_theme_index
  vim.g.colors_name = loaded_theme
  
  -- Define signs
  define_signs()
  
  -- Setup autocmd for persistence (only once)
  local group = vim.api.nvim_create_augroup("ThemePersistence", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    pattern = "ThemeChanged",
    callback = function()
      if state.current_theme_name then
        theme_persistence.save_theme(state.current_theme_name)
      end
    end,
    group = group
  })
  
  state.initialized = true
  
  -- Trigger initial event
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" })
  end)
end

-- Set specific theme by index
function M.set_theme(index)
  if not state.initialized then
    vim.notify("Theme system not initialized", vim.log.levels.ERROR)
    return
  end
  
  if index < 1 or index > #M.themes then
    vim.notify("Invalid theme index: " .. tostring(index), vim.log.levels.ERROR)
    return
  end
  
  -- Skip if already active
  if state.current_theme_index == index then
    return
  end
  
  local theme_name = M.themes[index]
  local loaded_theme = load_theme_safely(theme_name)
  
  if not loaded_theme then
    vim.notify("Failed to switch to theme: " .. theme_name, vim.log.levels.ERROR)
    return
  end
  
  -- Update state
  state.current_theme_name = loaded_theme
  state.current_theme_index = index
  M.current_theme = index
  vim.g.colors_name = loaded_theme
  
  -- Trigger events
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" })
    show_theme_notification(loaded_theme)
  end)
end

-- Cycle to next theme
function M.next_theme()
  local next_index = state.current_theme_index + 1
  if next_index > #M.themes then
    next_index = 1  -- Wrap around to first theme
  end
  M.set_theme(next_index)
end

-- Cycle to previous theme  
function M.previous_theme()
  local prev_index = state.current_theme_index - 1
  if prev_index < 1 then
    prev_index = #M.themes  -- Wrap around to last theme
  end
  M.set_theme(prev_index)
end

-- Get current theme info
function M.get_current_theme()
  return {
    name = state.current_theme_name or "unknown",
    index = state.current_theme_index or 1
  }
end

-- Set theme by name (convenience function)
function M.set_theme_by_name(theme_name)
  local index = get_theme_index(theme_name)
  M.set_theme(index)
end

return M