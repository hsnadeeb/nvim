return {
    {
      repo = "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = {
            enabled = true,
            auto_trigger = true,
            keymap = {
              accept = "<Tab>",
              accept_line = "<C-l>",
              accept_word = "<C-Right>",
              next = "<M-j>",
              prev = "<M-k>",
              dismiss = "<C-]>"
            },
          },
          panel = { enabled = false },
        })
      end,
    },
    {
      repo = "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup()
      end,
    },
  }