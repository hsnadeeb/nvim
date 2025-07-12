return {
    {
      repo = "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      config = function()
        require("lualine").setup({
          options = {
            icons_enabled = true,
            theme = "auto", -- respects whatever colorscheme you have
            component_separators = { left = "│", right = "│" },
            section_separators = { left = "", right = "" },
            globalstatus = true, -- single statusline for all windows
            disabled_filetypes = {},
          },
          sections = {
            lualine_a = {
              { "mode", icon = "" },
            },
            lualine_b = {
              { "branch", icon = "" },
              "diff",
              {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                sections = { "error", "warn", "info", "hint" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
                colored = true,
                update_in_insert = false,
              },
            },
            lualine_c = {
              {
                "filename",
                path = 1, -- relative path
                symbols = { modified = " ●", readonly = " " },
              },
            },
            lualine_x = {
              "filetype",
              "encoding",
              "fileformat",
            },
            lualine_y = {
              "progress",
            },
            lualine_z = {
              { "location", icon = "" },
            },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
          },
          extensions = { "nvim-tree", "quickfix", "fugitive", "lazy" },
        })
      end,
    },
  }