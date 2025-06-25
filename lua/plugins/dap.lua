local M = {}

function M.setup()
  -- Check if DAP is installed
  local status_ok, dap = pcall(require, 'dap')
  if not status_ok then
    vim.notify("nvim-dap not found!", vim.log.levels.ERROR)
    return
  end

  -- Configure DAP keybindings
  local function setup_keymaps()
    local keymaps = {
      ['<leader>d'] = {
        name = '+Debug',
        ['b'] = { function() require('dap').toggle_breakpoint() end, 'Toggle breakpoint' },
        ['B'] = { 
          function() 
            require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) 
          end, 
          'Conditional breakpoint' 
        },
        ['c'] = { function() require('dap').continue() end, 'Continue' },
        ['i'] = { function() require('dap').step_into() end, 'Step into' },
        ['o'] = { function() require('dap').step_over() end, 'Step over' },
        ['O'] = { function() require('dap').step_out() end, 'Step out' },
        ['r'] = { function() require('dap').repl.toggle() end, 'Toggle REPL' },
        ['l'] = { function() require('dap').run_last() end, 'Run last' },
        ['x'] = { function() require('dap').terminate() end, 'Terminate' },
        ['u'] = { function() 
          local dapui = require('dapui')
          if dapui then 
            dapui.toggle() 
          else
            vim.notify("dapui not installed", vim.log.levels.WARN)
          end
        end, 'Toggle UI' },
      },
    }

    -- Register keymaps with which-key if available
    local wk = require('which-key')
    if wk then
      for prefix, mappings in pairs(keymaps) do
        wk.register(mappings, { prefix = prefix })
      end
    else
      -- Fallback to manual keymap setting if which-key is not available
      for _, mapping in pairs(keymaps) do
        for key, cmd in pairs(mapping) do
          if type(cmd) == 'table' and cmd[1] then
            vim.keymap.set('n', key, cmd[1], { desc = cmd.desc or cmd[2] })
          end
        end
      end
    end
  end

  -- Set up keybindings
  setup_keymaps()

  -- Optional: Configure DAP UI if installed
  local dapui_status_ok, dapui = pcall(require, 'dapui')
  if dapui_status_ok then
    dapui.setup({
      icons = { expanded = '▾', collapsed = '▸' },
      mappings = {
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 0.25,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 0.25,
          position = 'bottom',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
    })

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
  end
end

return M
