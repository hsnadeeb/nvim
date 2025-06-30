-- Centralized keybindings for Neovim
local M = {}

function M.setup()
  -- Defer setup to reduce startup time
  vim.defer_fn(function()
    local utils = require("utils")
    local map = utils.map
    local wk_ok, wk = pcall(require, "which-key")

    -- Helper function to register keymaps
    local function register_keymaps(mode, prefix, keymaps, opts)
      if wk_ok then
        wk.register(keymaps, vim.tbl_extend("force", { mode = mode, prefix = prefix }, opts or {}))
      end
      for key, mapping in pairs(keymaps) do
        if type(key) == "string" and mapping[1] then
          map(mode, prefix .. key, mapping[1], { desc = mapping.desc or mapping[2], noremap = true, silent = true })
        end
      end
    end

    -- General keymaps
    local general_keymaps = {
      -- Window navigation
      ["<C-h>"] = { "<C-w>h", "Move to left window" },
      ["<C-j>"] = { "<C-w>j", "Move to window below" },
      ["<C-k>"] = { "<C-w>k", "Move to window above" },
      ["<C-l>"] = { "<C-w>l", "Move to right window" },
      -- IntelliJ-style navigation
      ["<leader>["] = { "<C-o>", "Previous cursor position" },
      ["<leader>]"] = { "<C-i>", "Next cursor position" },
      -- Line navigation
      ["H"] = { "^", "Start of line" },
      ["L"] = { "$", "End of line" },
      -- Quickfix navigation
      ["]q"] = { ":cnext<CR>", "Next quickfix item" },
      ["[q"] = { ":cprev<CR>", "Previous quickfix item" },
    }

    -- Register general keymaps
    register_keymaps("n", "", general_keymaps)
    register_keymaps("v", "", {
      ["H"] = { "^", "Start of line" },
      ["L"] = { "$", "End of line" },
    })

    -- Window navigation (which-key)
    if wk_ok then
      wk.register({
        w = {
          name = "+window",
          h = { "<C-w>h", "Move to left window" },
          j = { "<C-w>j", "Move to window below" },
          k = { "<C-w>k", "Move to window above" },
          l = { "<C-w>l", "Move to right window" },
          ["="] = { "<C-w>=", "Balance windows" },
          ["|"] = { "<C-w>v", "Split vertically" },
          ["-"] = { "<C-w>s", "Split horizontally" },
          c = { "<C-w>c", "Close window" },
          o = { "<C-w>o", "Close other windows" },
        },
      }, { prefix = "<leader>" })
    end

    -- Buffer keymaps (barbar.nvim)
    local buffer_keymaps = {
      ["<A-,>"] = { ":BufferPrevious<CR>", "Previous buffer" },
      ["<A-.>"] = { ":BufferNext<CR>", "Next buffer" },
      ["<A-<>"] = { ":BufferMovePrevious<CR>", "Move buffer left" },
      ["<A->>"] = { ":BufferMoveNext<CR>", "Move buffer right" },
      ["<A-c>"] = { ":BufferClose<CR>", "Close buffer" },
      ["<A-p>"] = { ":BufferPin<CR>", "Pin/Unpin buffer" },
      ["<A-1>"] = { ":BufferGoto 1<CR>", "Go to buffer 1" },
      ["<A-2>"] = { ":BufferGoto 2<CR>", "Go to buffer 2" },
      ["<A-3>"] = { ":BufferGoto 3<CR>", "Go to buffer 3" },
      ["<A-4>"] = { ":BufferGoto 4<CR>", "Go to buffer 4" },
      ["<A-5>"] = { ":BufferGoto 5<CR>", "Go to buffer 5" },
      ["<A-6>"] = { ":BufferGoto 6<CR>", "Go to buffer 6" },
      ["<A-7>"] = { ":BufferGoto 7<CR>", "Go to buffer 7" },
      ["<A-8>"] = { ":BufferGoto 8<CR>", "Go to buffer 8" },
      ["<A-9>"] = { ":BufferLast<CR>", "Go to last buffer" },
      ["<Tab>"] = { ":BufferNext<CR>", "Next buffer" },
      ["<S-Tab>"] = { ":BufferPrevious<CR>", "Previous buffer" },
    }
    register_keymaps("n", "", buffer_keymaps)

    -- Java-specific keymap
    register_keymaps("n", "<leader>j", {
      r = {
        function()
          vim.cmd("silent! write")
          local filename = vim.fn.expand("%:t:r")
          local filepath = vim.fn.expand("%:p")
          local dir = vim.fn.fnamemodify(filepath, ":h")
          local compile_cmd = string.format("silent !cd %s && javac %s", vim.fn.shellescape(dir), vim.fn.shellescape(vim.fn.expand("%:t")))
          local run_cmd = string.format("ToggleTerm cd %s && java %s", vim.fn.shellescape(dir), filename)
          vim.cmd(compile_cmd)
          vim.cmd("botright split")
          vim.cmd(run_cmd)
          vim.cmd("startinsert")
        end,
        "Compile and run Java file",
      },
    })
  end, 50) -- Defer by 50ms
end

return M