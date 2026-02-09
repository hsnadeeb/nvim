-- ============================================================================
-- Trouble.nvim Configuration
-- ============================================================================
-- Provides a better UI for diagnostics, references, quickfix, and location lists
-- Documentation: https://github.com/folke/trouble.nvim

local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

function M.setup()
  local status_ok, trouble = pcall(require, "trouble")
  if not status_ok then
    vim.notify("trouble.nvim not found!", vim.log.levels.ERROR)
    return
  end
  
  -- Only continue if trouble is loaded successfully
  if trouble then
    trouble.setup({
      -- UI Configuration
      position = "bottom",          -- Position of the list: bottom, top, left, right
      height = 12,                  -- Height of the trouble list (when position is top/bottom)
      width = 60,                  -- Width of the list (when position is left/right)
      padding = true,              -- Add extra new lines on top of the list
      indent_lines = true,         -- Add an indent guide below the fold icons
      auto_preview = true,         -- Automatically preview the location of the diagnostic
      auto_fold = false,           -- Automatically fold a file trouble list at creation
      auto_open = false,           -- Automatically open the list when you have diagnostics
      auto_close = false,          -- Automatically close the list when you have no diagnostics
      auto_jump = { "lsp_definitions" }, -- Auto-jump if there's only a single result
      
      -- Display Settings
      icons = true,                -- Use devicons for filenames
      mode = "workspace_diagnostics", -- Default mode: workspace_diagnostics, document_diagnostics, quickfix, lsp_references, loclist
      fold_open = "",             -- Icon used for open folds
      fold_closed = "",           -- Icon used for closed folds
      group = true,                -- Group results by file
      
      -- Action Keys Configuration
      action_keys = { 
        -- Key mappings for actions in the trouble list
        close = "q",               -- Close the list
        cancel = "<esc>",          -- Cancel and go back to last window/buffer/cursor
        refresh = "r",             -- Manually refresh
        jump = {"<cr>", "<tab>"},  -- Jump to diagnostic or open/close folds
        open_split = { "<c-x>" },  -- Open buffer in new split
        open_vsplit = { "<c-v>" }, -- Open buffer in new vsplit
        open_tab = { "<c-t>" },    -- Open buffer in new tab
        jump_close = {"o"},        -- Jump to diagnostic and close the list
        toggle_mode = "m",         -- Toggle between workspace and document diagnostics
        toggle_preview = "P",      -- Toggle auto_preview
        hover = "K",               -- Open popup with full message
        preview = "p",             -- Preview diagnostic location
        close_folds = {"zM", "zm"}, -- Close all folds
        open_folds = {"zR", "zr"},  -- Open all folds
        toggle_fold = {"zA", "za"}, -- Toggle fold of current file
        previous = "k",            -- Previous item
        next = "j",                -- Next item
        help = "?"                 -- Toggle help panel
      },
      
      -- Diagnostic Signs
      use_diagnostic_signs = false, -- Use the signs defined in your LSP client
      signs = {
        -- Icons/text used for diagnostics
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
      },
      
      -- Custom Mappings
      mappings = {
        -- Custom mappings can be added here
      },
      
      -- Filtering and Sorting
      filter = { mode = "all" },   -- Filter by diagnostic severity: all, error, warning, hint, information
      sort_keys = {
        -- Sort order of results: severity, filename, lnum, col, message, code, source
        "severity", "filename", "lnum", "col"
      },
      
      -- Preview Window
      preview = {
        type = "float",          -- Type of preview: float, split, vsplit, none
        relative = "cursor",      -- Reference point for positioning: cursor, editor, win
        border = "rounded",       -- Border style: single, double, rounded, solid, shadow, or a list of 8 chars
        position = { 0, 0 },      -- Position of the preview window
        size = { width = 0.4, height = 0.6 }, -- Size of the preview window (0-1)
        win_opts = {}             -- Additional window options
      },
      
      -- Format Configuration
      format = function(items)
        -- Custom formatting function for items
        local results = {}
        for _, item in ipairs(items) do
          table.insert(results, string.format("%s:%s: %s", 
            vim.fn.fnamemodify(item.filename, ":~:."), 
            item.lnum, 
            item.message:gsub("\n", " "):sub(1, 100)
          ))
        end
        return results
      end
    })

    -- ======================================================================
    -- Keybindings Configuration
    -- ======================================================================
    -- Note: These keybindings are organized by functionality and follow Vim's
    -- conventions. All keybindings are prefixed with '<leader>x' for consistency.
    
    -- Main Toggle and Views
    -- ====================
    map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'Toggle Trouble Window' })
    map('n', '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', 
      { desc = 'Trouble: Toggle Workspace Diagnostics' })
    
    -- Diagnostic Views
    -- ================
    map('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', 
      { desc = 'Trouble: Document Diagnostics' })
    map('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', 
      { desc = 'Trouble: Workspace Diagnostics' })
    map('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>', 
      { desc = 'Trouble: Location List' })
    map('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', 
      { desc = 'Trouble: Quickfix List' })
    
    -- LSP Navigation (Trouble Integration)
    -- ===================================
    map('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>', 
      { desc = 'Trouble: LSP References' })
    map('n', 'gD', '<cmd>TroubleToggle lsp_definitions<cr>', 
      { desc = 'Trouble: LSP Definitions' })
    map('n', 'gT', '<cmd>TroubleToggle lsp_type_definitions<cr>', 
      { desc = 'Trouble: LSP Type Definitions' })
    map('n', 'gI', '<cmd>TroubleToggle lsp_implementations<cr>', 
      { desc = 'Trouble: LSP Implementations' })
    
    -- Diagnostic Filtering
    -- ===================
    map('n', '<leader>xe', '<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.ERROR<cr>',
      { desc = 'Trouble: Show Only Errors' })
    map('n', '<leader>xW', '<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.WARN<cr>',
      { desc = 'Trouble: Show Only Warnings' })
    map('n', '<leader>xi', '<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.INFO<cr>',
      { desc = 'Trouble: Show Only Info' })
    map('n', '<leader>xh', '<cmd>TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.HINT<cr>',
      { desc = 'Trouble: Show Only Hints' })
    
    -- Quick Access Commands
    -- ====================
    vim.api.nvim_create_user_command('TroubleErrors', 'TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.ERROR', 
      { desc = 'Show only errors in Trouble' })
    vim.api.nvim_create_user_command('TroubleWarnings', 'TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.WARN', 
      { desc = 'Show only warnings in Trouble' })
    
    -- Which-key Integration
    -- ====================
    local wk = utils.safe_require('which-key')
    if wk then
      wk.register({
        x = {
          name = "Trouble",
          x = { "Toggle Window" },
          d = { "Document Diagnostics" },
          w = { "Workspace Diagnostics" },
          l = { "Location List" },
          q = { "Quickfix List" },
          e = { "Show Only Errors" },
          W = { "Show Only Warnings" },
          i = { "Show Only Info" },
          h = { "Show Only Hints" },
        }
      }, { prefix = "<leader>" })
    end
      
    -- Auto Commands
    local group = vim.api.nvim_create_augroup('TroubleConfig', { clear = true })
    
    -- Auto open Trouble when there are diagnostics
    vim.api.nvim_create_autocmd('DiagnosticChanged', {
      group = group,
      callback = function()
        -- Only auto-open if there are diagnostics
        local count = #vim.diagnostic.get(0)
        if count > 0 then
          vim.schedule(function()
            vim.cmd([[Trouble workspace_diagnostics]])
          end)
        end
      end,
    })
  end
end

-- Custom commands for easier access
vim.api.nvim_create_user_command('TroubleToggleErrors', 'TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.ERROR', {})
vim.api.nvim_create_user_command('TroubleToggleWarnings', 'TroubleToggle workspace_diagnostics filter.severity=vim.diagnostic.severity.WARN', {})

return M
