return function()
  local comment = require("Comment")
  comment.setup({
    padding = true, sticky = true, ignore = "^$",
    toggler = { line = "<leader>/", block = "<leader>/" },
    opleader = { line = "<leader>/", block = "<leader>/" },
    mappings = { basic = false, extra = false, extended = false },
  })

  local api = require("Comment.api")
  vim.keymap.set("n", "<leader>/", api.toggle.linewise.current, { desc = "Toggle comment" })
  vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { silent = true, desc = "Toggle comment" })

  local comment_ft = require("Comment.ft")
  comment_ft.set("lua", { "-- %s", "--[[%s]]" })
  comment_ft.set("vim", { '"%s', '"%s' })
  comment_ft.set("c", { "// %s", "/*%s*/" })
end
