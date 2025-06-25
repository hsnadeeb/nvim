local M = {
  'numToStr/Comment.nvim',
  keys = {
    -- Toggle line comment (normal and visual mode)
    { 'gcc', mode = 'n', desc = 'Toggle current line comment' },
    { 'gc', mode = { 'n', 'x' }, desc = 'Toggle linewise comment' },
    { 'gbc', mode = 'n', desc = 'Toggle current block comment' },
    { 'gb', mode = { 'n', 'x' }, desc = 'Toggle blockwise comment' },
    -- Operator-pending mappings
    { 'gc', mode = 'o', desc = 'Toggle comment with operator' },
    { 'gb', mode = 'o', desc = 'Toggle block comment with operator' },
    -- Leader mappings
    { '<leader>cc', '<Plug>(comment_toggle_linewise_current)', mode = 'n', desc = 'Toggle line comment' },
    { '<leader>cb', '<Plug>(comment_toggle_blockwise_current)', mode = 'n', desc = 'Toggle block comment' },
    { '<leader>cl', '<Plug>(comment_toggle_linewise)', mode = 'n', desc = 'Toggle line comment (motion)' },
    { '<leader>cB', '<Plug>(comment_toggle_blockwise)', mode = 'n', desc = 'Toggle block comment (motion)' },
    -- Visual mode mappings
    { '<leader>c', '<Plug>(comment_toggle_linewise_visual)', mode = 'x', desc = 'Toggle line comment' },
    { '<leader>b', '<Plug>(comment_toggle_blockwise_visual)', mode = 'x', desc = 'Toggle block comment' },
  },
  config = function()
    require('Comment').setup({
      -- Add any custom configuration options here
      -- See :h comment.config for available options
      toggler = {
        line = 'gcc', -- Line-comment toggle keymap
        block = 'gbc', -- Block-comment toggle keymap
      },
      -- LHS of operator-pending mappings
      opleader = {
        line = 'gc', -- Line-comment operator
        block = 'gb', -- Block-comment operator
      },
      -- LHS of extra mappings
      extra = {
        above = 'gcO', -- Add comment on the line above
        eol = 'gcA', -- Add comment at the end of the line
      },
      -- Enable keybindings (false will disable the mappings)
      mappings = {
        -- Operator-pending mapping
        basic = true, -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        extra = true, -- Includes `gco`, `gcO`, `gcA`
      },
    })
  end,
}

return M
