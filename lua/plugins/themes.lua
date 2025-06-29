local M = {}

-- Cache for loaded themes to prevent redundant loading
local _M = {}
local theme_cache = {}

-- Available themes
M.themes = {
  "gruvbox",
  "solarized-osaka",
  "everforest",
  "decay",
  "nightfox",
  "material"
}

-- Load theme persistence
local theme_persistence = require('theme_persistence')

-- Function to get theme index by name
local function get_theme_index(theme_name)
  for i, name in ipairs(M.themes) do
    if name == theme_name then
      return i
    end
  end
  return 3 -- Default to everforest if not found
end

-- Initialize current theme from saved theme or use default
M.current_theme = get_theme_index(vim.g.saved_theme or "everforest")

-- Theme configurations
local theme_configs = {
  gruvbox = function()
    vim.g.gruvbox_contrast_dark = "hard"
    vim.g.gruvbox_invert_selection = 0
    vim.g.gruvbox_italic = 1
    vim.g.gruvbox_bold = 1
    require("gruvbox").setup({
      overrides = {
        Normal = { bg = "#1d2021" },
        Function = { fg = "#fabd2f", bold = true },
        String = { fg = "#b8bb26", italic = true },
      }
    })
    vim.cmd("colorscheme gruvbox")
  end,
  ["solarized-osaka"] = function()
    require("solarized-osaka").setup({
      style = "storm",
      transparent = false,
      colors = {
        base00 = "#1c2526",
        yellow = "#ffcc00",
      }
    })
    vim.cmd("silent! colorscheme solarized-osaka")
    -- vim.cmd("silent! doautocmd User ThemeChanged")
  end,
  everforest = function()
    vim.g.everforest_background = "hard"
    vim.g.everforest_better_performance = 1
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_ui_contrast = "high"
    vim.g.everforest_diagnostic_text_highlight = 1
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.g.everforest_diagnostic_virtual_text = "colored"
    vim.g.everforest_current_word = "underline"
    vim.g.everforest_show_eob = 1
    vim.cmd([[
      augroup EverforestCustom
        autocmd!
        autocmd ColorScheme everforest highlight! link @property @field
        autocmd ColorScheme everforest highlight! link @parameter @variable
        autocmd ColorScheme everforest highlight! link @lsp.type.parameter @parameter
        autocmd ColorScheme everforest highlight! link @lsp.type.property @property
        autocmd ColorScheme everforest highlight! link @lsp.typemod.variable.defaultLibrary @variable.builtin
        autocmd ColorScheme everforest highlight! link @lsp.typemod.function.defaultLibrary @function.builtin
        autocmd ColorScheme everforest highlight! link @lsp.typemod.method.defaultLibrary @function.builtin
        autocmd ColorScheme everforest highlight! link @lsp.type.namespace @namespace
        autocmd ColorScheme everforest highlight! link @lsp.type.type @type
        autocmd ColorScheme everforest highlight! link @lsp.type.class @type
        autocmd ColorScheme everforest highlight! link @lsp.type.enum @type
        autocmd ColorScheme everforest highlight! link @lsp.type.interface @type
        autocmd ColorScheme everforest highlight! link @lsp.type.struct @structure
        autocmd ColorScheme everforest highlight! link @lsp.typemod.type.defaultLibrary @type.builtin
        autocmd ColorScheme everforest highlight! link @lsp.typemod.typeParameter.declaration @type.definition
        autocmd ColorScheme everforest highlight! link @lsp.type.macro @macro
        autocmd ColorScheme everforest highlight! link @lsp.type.variable @variable
        autocmd ColorScheme everforest highlight! link @lsp.type.function @function
        autocmd ColorScheme everforest highlight! link @lsp.type.method @method
        autocmd ColorScheme everforest highlight! link @lsp.type.decorator @function
        autocmd ColorScheme everforest highlight! link @lsp.type.comment @comment
        autocmd ColorScheme everforest highlight! link @lsp.type.enumMember @constant
        autocmd ColorScheme everforest highlight! link @lsp.type.typeParameter @type.definition
        autocmd ColorScheme everforest highlight! link @lsp.type.parameter @parameter
        autocmd ColorScheme everforest highlight! link @lsp.type.property @property
        autocmd ColorScheme everforest highlight! link @lsp.type.keyword @keyword
        autocmd ColorScheme everforest highlight! link @lsp.type.number @number
        autocmd ColorScheme everforest highlight! link @lsp.type.string @string
        autocmd ColorScheme stop
        autocmd ColorScheme everforest highlight! link @lsp.type.operator @operator
        autocmd ColorScheme everforest highlight! link @lsp.type.namespace @namespace
      augroup END
    ]])
    vim.cmd("colorscheme everforest")
  end,
  decay = function()
    require("decay").setup({
      style = "decay",
      italics = {
        code = true,
        comments = true,
        folds = true,
      },
      nvim_tree = {
        contrast = true,
      },
      cmp = {
        block_kind = true,
      },
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
    vim.cmd("colorscheme decay")
    
    -- Additional highlight overrides
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
  nightfox = function()
    require("nightfox").setup({
      options = {
        styles = { comments = "italic", keywords = "bold" }, -- Vibrant styling
        transparent = false,
      },
      palettes = {
        nightfox = {
          bg1 = "#1a1d2b", -- Darker background for contrast
          yellow = "#ffcc66", -- Bright yellow for highlights
          green = "#00ffaa", -- Neon green for strings
        }
      }
    })
    vim.cmd("colorscheme nightfox")
  end,
  material = function()
    vim.g.material_style = "oceanic" -- Wild, oceanic vibe
    require("material").setup({
      contrast = { sidebars = true, floating_windows = true },
      styles = { comments = { italic = true }, keywords = { bold = true } },
      custom_colors = {
        bg = "#0c1a20", -- Deep oceanic background
        yellow = "#ffd700", -- Bright gold for vibrancy
      }
    })
    vim.cmd("colorscheme material")
  end
}

-- Function to safely load a theme
local function load_theme_safely(theme_name)
  local ok, err = pcall(function()
    local config = theme_configs[theme_name]
    if config then
      config()
    else
      vim.cmd("colorscheme " .. theme_name)
    end
  end)
  if not ok then
    vim.notify("Failed to load theme " .. theme_name .. ": " .. tostring(err), vim.log.levels.ERROR)
    theme_configs.everforest()
    return "everforest"
  end
  return theme_name
end

-- Initialize the default theme
function M.setup()
  if _M.initialized then return end
  _M.initialized = true

  local theme = M.themes[M.current_theme] or "everforest"
  theme = load_theme_safely(theme)

  vim.g.colors_name = theme
  _M.current_theme_name = theme
  _M.current_theme_index = M.current_theme

  vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" })

  vim.api.nvim_create_autocmd("User", {
    pattern = "ThemeChanged",
    callback = function()
      if _M.current_theme_name then
        theme_persistence.save_theme(_M.current_theme_name)
      end
    end,
    group = vim.api.nvim_create_augroup("ThemePersistence", { clear = true })
  })
end

-- Define nvim-tree diagnostic signs
if not _M.signs_defined then
  local signs = {
    { name = "NvimTreeDiagnosticErrorIcon", text = "" },
    { name = "NvimTreeDiagnosticWarnIcon", text = "" },
    { name = "NvimTreeDiagnosticInfoIcon", text = "" },
    { name = "NvimTreeDiagnosticHintIcon", text = "" },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name })
  end
  _M.signs_defined = true
end

-- Show theme notification
local function show_theme_notification(theme_name)
  local theme_titles = {
    gruvbox = "Gruvbox",
    ["solarized-osaka"] = "Solarized Osaka",
    everforest = "Everforest",
    decay = "Decay",
    nightfox = "Nightfox",
    material = "Material"
  }
  local title = theme_titles[theme_name] or theme_name:gsub("^%l", string.upper)
  vim.schedule(function()
    vim.notify(
      string.format("Theme: %s", title),
      vim.log.levels.INFO,
      { title = "Theme Changed", timeout = 2000, icon = "🎨" }
    )
  end)
end

-- Set a specific theme by index
function M.set_theme(index)
  if _M.current_theme_index == index and theme_cache[index] then
    return
  end

  M.current_theme = index
  local theme = M.themes[M.current_theme]

  if not theme then
    vim.notify("Invalid theme index: " .. tostring(index), vim.log.levels.ERROR)
    return
  end

  if not theme_cache[theme] then
    theme_cache[theme] = true
  end

  local loaded_theme = load_theme_safely(theme)
  _M.current_theme_index = index
  _M.current_theme_name = loaded_theme
  M.current_theme = index
  vim.g.colors_name = loaded_theme

  theme_persistence.save_theme(loaded_theme)
  vim.cmd("silent! doautocmd User ThemeChanged")
  show_theme_notification(loaded_theme)
end

-- Cycle to the next theme
function M.next_theme()
  local next_theme = (M.current_theme % #M.themes) + 1
  M.set_theme(next_theme)
end

-- Get current theme info
function M.get_current_theme()
  return {
    name = M.themes[M.current_theme] or "unknown",
    index = M.current_theme
  }
end

return M