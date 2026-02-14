local M = {}

local state = { current = nil, initialized = false }

vim.opt.termguicolors = true
vim.opt.background = "dark"

local themes = {
  {
    name = "everforest",
    setup = function()
      -- Set everforest options before loading
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_line_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_ui_contrast = "high"
      
      -- Try to ensure everforest is loaded
      local everforest_path = vim.fn.stdpath('data') .. '/lazy/everforest'
      if vim.fn.isdirectory(everforest_path) == 1 then
        vim.opt.rtp:prepend(everforest_path)
      end
      
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    name = "gruvbox",
    setup = function()
      local ok, gruvbox = pcall(require, "gruvbox")
      if not ok then
        vim.notify("gruvbox not available", vim.log.levels.WARN)
        return
      end
      gruvbox.setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true,
        contrast = "hard",
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    name = "nightfox",
    setup = function()
      local ok, nightfox = pcall(require, "nightfox")
      if not ok then return end
      nightfox.setup({ options = { transparent = false, terminal_colors = true } })
      vim.cmd.colorscheme("carbonfox")
    end,
  },
  {
    name = "onedark",
    setup = function()
      local ok, onedark = pcall(require, "onedark")
      if not ok then return end
      onedark.setup({ style = "cool", transparent = false, term_colors = true, ending_tildes = false, code_style = { comments = "italic", keywords = "bold" } })
      onedark.load()
    end,
  },
}

local persistence = require("theme_persistence")

local function get_theme(name)
  for _, theme in ipairs(themes) do
    if theme.name == name then return theme end
  end
  return themes[1]
end

local function show_theme_notification(theme_name)
  vim.schedule(function()
    vim.notify("Theme: " .. theme_name, vim.log.levels.INFO, { title = "Theme Switched", timeout = 1500 })
  end)
end

local function apply_theme(theme_name)
  if not theme_name then return nil end
  local theme = get_theme(theme_name)
  if not theme then
    -- Fall back to first theme if not found
    theme = themes[1]
  end
  
  local ok = pcall(theme.setup)
  if not ok then
    -- If theme setup fails, try to fall back to everforest
    if theme.name ~= "everforest" then
      vim.schedule(function()
        vim.notify("Theme '" .. theme_name .. "' failed to load, falling back to everforest", vim.log.levels.WARN)
      end)
      theme = themes[1]
      ok = pcall(theme.setup)
      if not ok then
        vim.schedule(function()
          vim.notify("Failed to load fallback theme", vim.log.levels.ERROR)
        end)
        return nil
      end
    else
      vim.schedule(function()
        vim.notify("Failed to load theme: " .. theme_name, vim.log.levels.ERROR)
      end)
      return nil
    end
  end
  
  state.current = theme.name
  persistence.save_theme(theme.name)
  show_theme_notification(theme.name)
  vim.schedule(function() vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" }) end)
  return theme.name
end

function M.next()
  local current = state.current or persistence.load_theme()
  local index = 1
  for i, t in ipairs(themes) do if t.name == current then index = i; break end end
  local next_index = (index % #themes) + 1
  return apply_theme(themes[next_index].name)
end

function M.previous()
  local current = state.current or persistence.load_theme()
  local index = 1
  for i, t in ipairs(themes) do if t.name == current then index = i; break end end
  local prev_index = (index - 2) % #themes + 1
  return apply_theme(themes[prev_index].name)
end

function M.set(name) return apply_theme(name) end
M.cycle = M.next
function M.current() return state.current or persistence.load_theme() end

function M.list()
  return vim.tbl_map(function(t) return t.name end, themes)
end

function M.setup()
  if state.initialized then return end
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300
  local theme = persistence.load_theme() or themes[1].name
  apply_theme(theme)
  state.initialized = true
  return theme
end

return M
