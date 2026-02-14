return function()
  local auto_save = require("auto-save")
  local pref_file = vim.fn.stdpath("data") .. "/autosave_enabled"

  local function load_preference()
    local f = io.open(pref_file, "r")
    if f then
      local content = f:read("*a")
      f:close()
      return content == "true"
    end
    return false
  end

  local function save_preference(enabled)
    local f = io.open(pref_file, "w")
    if f then
      f:write(enabled and "true" or "false")
      f:close()
    end
  end

  local saved_state = load_preference()

  auto_save.setup({
    enabled = saved_state,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    callbacks = {
      after_saving = function()
        vim.notify("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"), vim.log.levels.INFO)
      end,
    },
    condition = function(buf)
      local fn = vim.fn
      local buftype = fn.getbufvar(buf, "&buftype")
      local filetype = fn.getbufvar(buf, "&filetype")
      if buftype ~= "" then return false end
      local excluded = { "NvimTree", "alpha", "TelescopePrompt", "lazy", "mason" }
      for _, ft in ipairs(excluded) do
        if filetype == ft then return false end
      end
      return fn.getbufvar(buf, "&modifiable") == 1
    end,
    write_all_buffers = false,
    debounce_delay = 1000,
  })

  vim.g.auto_save_state = saved_state
  _G.toggle_autosave = function()
    auto_save.toggle()
    vim.g.auto_save_state = not vim.g.auto_save_state
    save_preference(vim.g.auto_save_state)
    local state = vim.g.auto_save_state and "Enabled" or "Disabled"
    vim.notify("AutoSave: " .. state, vim.log.levels.INFO)
  end

  local utils = require("config.utils")
  utils.map("n", "<leader>aa", _G.toggle_autosave, { desc = "Toggle AutoSave" })
end
