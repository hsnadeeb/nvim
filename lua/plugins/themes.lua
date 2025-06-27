local M = {}

-- Cache for loaded themes to prevent redundant loading
local _M = {}
local theme_cache = {}

-- Available themes based on Dotfyle trending colorschemes
M.themes = {
  "nord",
  "catppuccin",
  "tokyonight",
  "kanagawa",
  "rose-pine",
  "nightfox",
  "onedark",
  "gruvbox-material",
  "github-nvim-theme",
  "everforest",
  "vscode",
  "material",
  "cyberdream",
  "onedarkpro",
  "dracula",
  "sonokai",
  "solarized-osaka",
  "oxocarbon",
  "nordic",
  "tokyodark",
  "moonfly",
  "edge",
  "gruvbox",
  "decay",
  "melange",
  "fluoromachine",
  "bamboo",
  "lackluster"
}

-- Current theme index (11 is everforest)
M.current_theme = 11

-- Theme configurations with popular variants
local theme_configs = {
  nord = function()
    require("nord").setup({
      transparent = false,
      terminal_colors = true,
      diff = { mode = "bg" },
      borders = true,
      errors = { mode = "bg" },
    })
  end,
  
  catppuccin = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        which_key = true,
        mason = true,
        lsp_trouble = true,
        illuminate = true,
      },
    })
  end,
  
  tokyonight = function()
    require("tokyonight").setup({
      style = "storm", -- storm, moon, night, day
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
    })
  end,
  
  kanagawa = function()
    require("kanagawa").setup({
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = { bold = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = { bold = true },
      variablebuiltinStyle = { italic = true },
      specialReturn = true,
      specialException = true,
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = "wave", -- wave, dragon, lotus
    })
  end,
  
  ["rose-pine"] = function()
    require("rose-pine").setup({
      variant = "main", -- auto, main, moon, dawn
      dark_variant = "main",
      disable_background = false,
      disable_float_background = false,
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    })
  end,
  
  nightfox = function()
    require("nightfox").setup({
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
        inverse = {
          match_paren = true,
          visual = false,
          search = false,
        },
      },
    })
  end,
  
  onedark = function()
    require("onedark").setup({
      style = "dark", -- dark, darker, cool, deep, warm, warmer, light
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },
    })
  end,
  
  ["gruvbox-material"] = function()
    vim.g.gruvbox_material_background = "medium" -- hard, medium, soft
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_disable_italic_comment = 1
    vim.g.gruvbox_material_enable_italic = 0
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_transparent_background = 0
  end,
  
  ["github-nvim-theme"] = function()
    require("github-theme").setup({
      options = {
        compile_path = vim.fn.stdpath("cache") .. "/github-theme",
        compile_file_suffix = "_compiled",
        hide_end_of_buffer = true,
        hide_nc_statusline = true,
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        module_default = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    })
  end,
  
  everforest = function()
    vim.g.everforest_background = "medium" -- hard, medium, soft
    vim.g.everforest_better_performance = 1
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_enable_italic = 0
    vim.g.everforest_transparent_background = 0
  end,
  
  vscode = function()
    require("vscode").setup({
      transparent = false,
      italic_comments = true,
      disable_nvimtree_bg = true,
    })
  end,
  
  material = function()
    require("material").setup({
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        lsp_virtual_text = false,
        non_current_windows = false,
        filetypes = {},
      },
      styles = {
        comments = { italic = true },
        strings = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = {},
        operators = {},
        types = {},
      },
      plugins = {
        "dap",
        "gitsigns",
        "lsp",
        "nvim-cmp",
        "nvim-tree",
        "telescope",
        "trouble",
        "which-key",
      },
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        term_colors = false,
        eob_lines = false,
      },
      high_visibility = {
        lighter = false,
        darker = false,
      },
      lualine_style = "default",
      async_loading = true,
    })
  end,
  
  cyberdream = function()
    require("cyberdream").setup({
      transparent = false,
      italic_comments = true,
      hide_fillchars = false,
      borderless_telescope = true,
      terminal_colors = true,
    })
  end,
  
  onedarkpro = function()
    require("onedarkpro").setup({
      colors = {},
      highlights = {},
      styles = {
        types = "NONE",
        methods = "NONE",
        numbers = "NONE",
        strings = "NONE",
        comments = "italic",
        keywords = "bold,italic",
        constants = "NONE",
        functions = "italic",
        operators = "NONE",
        variables = "NONE",
        parameters = "NONE",
        conditionals = "italic",
        virtual_text = "NONE",
      },
      filetypes = {
        c = true,
        cpp = true,
        cs = true,
        java = true,
        javascript = true,
        lua = true,
        markdown = true,
        php = true,
        python = true,
        ruby = true,
        rust = true,
        typescript = true,
        vue = true,
        yaml = true,
      },
      plugins = {
        aerial = true,
        barbar = true,
        codecompanion = true,
        copilot = true,
        dashboard = true,
        gitsigns = true,
        hop = true,
        indentline = true,
        leap = true,
        lsp_saga = true,
        marks = true,
        mason = true,
        nvim_cmp = true,
        nvim_bqf = true,
        nvim_dap = true,
        nvim_dap_ui = true,
        nvim_hlslens = true,
        nvim_lsp = true,
        nvim_navic = true,
        nvim_notify = true,
        nvim_tree = true,
        nvim_ts_rainbow = true,
        op_nvim = true,
        packer = true,
        polygot = true,
        rainbow_delimiters = true,
        startify = true,
        telescope = true,
        toggleterm = true,
        treesitter = true,
        trouble = true,
        vim_ultest = true,
        which_key = true,
      },
      options = {
        cursorline = false,
        transparency = false,
        terminal_colors = true,
        lualine_transparency = false,
        highlight_inactive_windows = false,
      },
    })
  end,
  
  dracula = function()
    require("dracula").setup({
      colors = {},
      show_end_of_buffer = true,
      transparent_bg = false,
      lualine_bg_color = "#44475a",
      italic_comment = true,
    })
  end,
  
  sonokai = function()
    vim.g.sonokai_style = "default" -- default, atlantis, andromeda, shusia, maia, espresso
    vim.g.sonokai_better_performance = 1
    vim.g.sonokai_disable_italic_comment = 1
    vim.g.sonokai_enable_italic = 0
    vim.g.sonokai_transparent_background = 0
  end,
  
  ["solarized-osaka"] = function()
    require("solarized-osaka").setup({
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
    })
  end,
  
  oxocarbon = function()
    require("oxocarbon")
  end,
  
  nordic = function()
    require("nordic").setup({
      reduced_blue = true,
      swap_backgrounds = false,
      override = {},
      cursorline = {
        bold = false,
        bold_number = true,
        theme = "dark",
        blend = 0.85,
      },
      noice = {
        style = "classic",
      },
      telescope = {
        style = "classic",
      },
      leap = {
        dim_backdrop = false,
      },
      ts_context = {
        dark_background = true,
      },
    })
  end,
  
  tokyodark = function()
    require("tokyodark").setup({
      transparent_background = false,
      gamma = 1.00,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        identifiers = { italic = true },
        functions = {},
        variables = {},
      },
    })
  end,
  
  moonfly = function()
    vim.g.moonflyTransparent = false
    vim.g.moonflyItalics = true
    vim.g.moonflyUndercurls = true
    vim.g.moonflyUnderlineMatchParen = true
    vim.g.moonflyVirtualTextColor = true
  end,
  
  edge = function()
    vim.g.edge_style = "default" -- default, aura, neon
    vim.g.edge_better_performance = 1
    vim.g.edge_disable_italic_comment = 1
    vim.g.edge_enable_italic = 0
    vim.g.edge_transparent_background = 0
  end,
  
  gruvbox = function()
    require("gruvbox").setup({
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    })
  end,
  
  decay = function()
    require("decay").setup({
      style = "dark", -- dark, light, decayce
      nvim_tree = {
        contrast = true,
      },
    })
  end,
  
  melange = function()
    vim.g.melange_enable_font_variants = 1
  end,
  
  fluoromachine = function()
    require("fluoromachine").setup({
      glow = false,
      theme = "fluoromachine", -- fluoromachine, retrowave, delta
      transparent = false,
    })
  end,
  
  bamboo = function()
    require("bamboo").setup({
      style = "vulgaris", -- light, multiplex, vulgaris
      toggle_style_key = nil,
      toggle_style_list = { "vulgaris", "multiplex", "light" },
      transparent = false,
      dim_inactive = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      code_style = {
        comments = { italic = true },
        conditionals = { italic = true },
        keywords = {},
        functions = {},
        namespaces = { italic = true },
        parameters = { italic = true },
        strings = {},
        variables = {},
      },
    })
  end,
  
  lackluster = function()
    require("lackluster").setup({
      tweak_syntax = {
        comment = { italic = true },
        string = { italic = false },
        keyword = { italic = false },
      },
      tweak_background = {
        normal = "none",
        telescope = "none",
        menu = "default",
        popup = "default",
      },
    })
  end,
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
    vim.g.colors_name = theme
    vim.notify("🎨 Theme: " .. theme .. " (" .. index .. "/" .. #M.themes .. ")")
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

-- Set theme by name
function M.set_theme_by_name(name)
  for i, theme in ipairs(M.themes) do
    if theme == name then
      M.set_theme(i)
      return true
    end
  end
  vim.notify("Theme '" .. name .. "' not found", vim.log.levels.WARN)
  return false
end

-- Cycle to the next theme
function M.next_theme()
  local next_theme = (M.current_theme % #M.themes) + 1
  M.set_theme(next_theme)
end

-- Cycle to the previous theme
function M.prev_theme()
  local prev_theme = M.current_theme - 1
  if prev_theme < 1 then
    prev_theme = #M.themes
  end
  M.set_theme(prev_theme)
end

-- Random theme
function M.random_theme()
  math.randomseed(os.time())
  local random_index = math.random(1, #M.themes)
  -- Ensure we don't pick the same theme
  while random_index == M.current_theme and #M.themes > 1 do
    random_index = math.random(1, #M.themes)
  end
  M.set_theme(random_index)
end

-- Get current theme info
function M.get_current_theme()
  return {
    name = M.themes[M.current_theme] or "unknown",
    index = M.current_theme,
    total = #M.themes
  }
end

-- List all themes
function M.list_themes()
  local current_theme = M.get_current_theme()
  local themes_list = {}
  
  for i, theme in ipairs(M.themes) do
    local indicator = (i == current_theme.index) and "● " or "○ "
    table.insert(themes_list, string.format("%s%d. %s", indicator, i, theme))
  end
  
  vim.notify("Available themes (" .. current_theme.index .. "/" .. current_theme.total .. "):\n" .. table.concat(themes_list, "\n"))
end

-- Interactive theme picker
function M.pick_theme()
  local themes_with_numbers = {}
  for i, theme in ipairs(M.themes) do
    table.insert(themes_with_numbers, string.format("%d. %s", i, theme))
  end
  
  vim.ui.select(themes_with_numbers, {
    prompt = "Select theme:",
    format_item = function(item)
      local current = M.get_current_theme()
      local theme_num = tonumber(item:match("^(%d+)%."))
      local indicator = (theme_num == current.index) and "● " or "  "
      return indicator .. item
    end,
  }, function(choice)
    if choice then
      local theme_index = tonumber(choice:match("^(%d+)%."))
      if theme_index then
        M.set_theme(theme_index)
      end
    end
  end)
end

-- Search themes by name
function M.search_theme(query)
  local matches = {}
  query = query:lower()
  
  for i, theme in ipairs(M.themes) do
    if theme:lower():find(query, 1, true) then
      table.insert(matches, { index = i, name = theme })
    end
  end
  
  if #matches == 0 then
    vim.notify("No themes found matching '" .. query .. "'", vim.log.levels.WARN)
    return
  elseif #matches == 1 then
    M.set_theme(matches[1].index)
  else
    local match_strings = {}
    for _, match in ipairs(matches) do
      table.insert(match_strings, string.format("%d. %s", match.index, match.name))
    end
    
    vim.ui.select(match_strings, {
      prompt = "Multiple matches found:",
    }, function(choice)
      if choice then
        local theme_index = tonumber(choice:match("^(%d+)%."))
        if theme_index then
          M.set_theme(theme_index)
        end
      end
    end)
  end
end

-- Get theme history (last 5 themes)
M.theme_history = M.theme_history or {}

-- Add to history when theme changes
local original_set_theme = M.set_theme
M.set_theme = function(index)
  if M.current_theme ~= index then
    table.insert(M.theme_history, 1, M.current_theme)
    -- Keep only last 5 themes
    if #M.theme_history > 5 then
      table.remove(M.theme_history)
    end
  end
  original_set_theme(index)
end

-- Go back to previous theme
function M.back_theme()
  if #M.theme_history > 0 then
    local prev_theme = table.remove(M.theme_history, 1)
    -- Call original function to avoid adding to history again
    original_set_theme(prev_theme)
  else
    vim.notify("No previous theme in history", vim.log.levels.WARN)
  end
end

-- Export current theme config
function M.export_theme()
  local current = M.get_current_theme()
  local config_str = string.format("-- Theme: %s\nvim.cmd('colorscheme %s')", current.name, current.name)
  
  vim.fn.setreg('+', config_str)
  vim.notify("Theme config copied to clipboard: " .. current.name)
end

return M