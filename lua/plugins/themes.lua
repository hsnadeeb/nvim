return {
  {
    repo = "sainnhe/everforest",
    lazy = false,
    priority = 1000,
  },
  {
    repo = "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup()
    end,
  },
  {
    repo = "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup()
    end,
  },
  {
    repo = "decaycs/decay.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    repo = "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("material").setup()
    end,
  },
}


-- return {
--   {
--     "sainnhe/everforest",
--     lazy = false,
--     priority = 1000,
--   },
--   {
--     "ellisonleao/gruvbox.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("gruvbox").setup()
--     end,
--   },
--   {
--     "craftzdog/solarized-osaka.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("solarized-osaka").setup()
--     end,
--   },
--   {
--     "decaycs/decay.nvim",
--     lazy = false,
--     priority = 1000,
--   },
--   {
--     "marko-cerovac/material.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("material").setup()
--     end,
--   },
--   {
--     "not-a-plugin",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       local theme_persistence = require('theme_persistence')
--       local themes = {
--         { name = "everforest", cmd = "colorscheme everforest" },
--         { name = "gruvbox", cmd = "colorscheme gruvbox" },
--         { name = "solarized-osaka", cmd = "colorscheme solarized-osaka" },
--         { name = "decay", cmd = "colorscheme decay" },
--         { name = "material", cmd = "colorscheme material" },
--       }
--       local current_index = 1

--       -- Load saved theme
--       local saved_theme = theme_persistence.load_theme()
--       for i, theme in ipairs(themes) do
--         if theme.name == saved_theme then
--           current_index = i
--           pcall(vim.cmd, theme.cmd)
--           break
--         end
--       end

--       -- Setup function
--       local function setup()
--         pcall(vim.cmd, themes[current_index].cmd)
--       end

--       -- Next theme
--       local function next()
--         current_index = current_index % #themes + 1
--         pcall(vim.cmd, themes[current_index].cmd)
--         theme_persistence.save_theme(themes[current_index].name)
--         vim.notify("Theme: " .. themes[current_index].name, vim.log.levels.INFO)
--       end

--       -- Previous theme
--       local function previous()
--         current_index = current_index - 1
--         if current_index < 1 then
--           current_index = #themes
--         end
--         pcall(vim.cmd, themes[current_index].cmd)
--         theme_persistence.save_theme(themes[current_index].name)
--         vim.notify("Theme: " .. themes[current_index].name, vim.log.levels.INFO)
--       end

--       -- Cycle theme
--       local function cycle()
--         next()
--       end

--       -- Expose functions
--       return {
--         setup = setup,
--         next = next,
--         previous = previous,
--         cycle = cycle,
--       }
--     end,
--   },
-- }