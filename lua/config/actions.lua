-- ============================================================================
-- Shared Action Functions
-- ============================================================================

local M = {}

function M.diagnostic_prev()
  vim.diagnostic.jump({ count = -1 })
end

function M.diagnostic_next()
  vim.diagnostic.jump({ count = 1 })
end

function M.format_document()
  local ok_conform, conform = pcall(require, "conform")
  if not ok_conform then
    vim.notify("conform is not available", vim.log.levels.WARN)
    return
  end

  local format_fn = type(conform) == "table" and conform["format"] or nil
  if type(format_fn) == "function" then
    format_fn()
  end
end

-- Close all listed buffers except the current one and report skipped modified buffers.
function M.close_other_buffers()
  local current = vim.api.nvim_get_current_buf()
  local closed = 0
  local skipped = 0

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      local ok = pcall(vim.api.nvim_buf_delete, buf, { force = false })
      if ok then
        closed = closed + 1
      else
        skipped = skipped + 1
      end
    end
  end

  if skipped > 0 then
    vim.notify(("Closed %d buffers (%d skipped: likely modified)"):format(closed, skipped), vim.log.levels.WARN)
  else
    vim.notify(("Closed %d buffers"):format(closed), vim.log.levels.INFO)
  end
end

-- Create user commands owned by this config (idempotent on reload).
function M.register_user_commands()
  pcall(vim.api.nvim_del_user_command, "BufOnly")
  vim.api.nvim_create_user_command("BufOnly", M.close_other_buffers, {
    desc = "Close all listed buffers except current",
  })
end

-- Install buffer-local LSP convenience keymaps on attach.
function M.setup_lsp_attach_keymaps()
  local utils = require("config.utils")
  local group = vim.api.nvim_create_augroup("ConfigLspAttachKeymaps", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local function buf_map(lhs, rhs, desc)
        utils.buf_map(bufnr, "n", lhs, rhs, { desc = desc })
      end

      buf_map("<leader>la", vim.lsp.buf.code_action, "Code Action")
      buf_map("<leader>ld", vim.diagnostic.open_float, "Diagnostics")
      buf_map("<leader>lD", vim.lsp.buf.declaration, "Declaration")
      buf_map("<leader>lg", vim.lsp.buf.definition, "Definition")
      buf_map("<leader>li", vim.lsp.buf.implementation, "Implementation")
      buf_map("<leader>lr", vim.lsp.buf.references, "References")
      buf_map("<leader>ln", vim.lsp.buf.rename, "Rename")
      buf_map("<leader>lh", vim.lsp.buf.hover, "Hover")
      buf_map("<leader>lk", M.diagnostic_prev, "Previous Diagnostic")
      buf_map("<leader>lj", M.diagnostic_next, "Next Diagnostic")
      buf_map("<leader>lt", vim.lsp.buf.type_definition, "Type Definition")
      buf_map("<leader>ls", vim.lsp.buf.document_symbol, "Document Symbols")
      buf_map("<leader>lS", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
      buf_map("<leader>lf", M.format_document, "Format")
    end,
  })
end

-- Build a lazy-safe Telescope action by picker name.
function M.telescope_call(fn_name, opts)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then
      vim.notify("Telescope is not available", vim.log.levels.WARN)
      return
    end
    builtin[fn_name](opts or {})
  end
end

-- Build a lazy-safe DAP/DAPUI action by module and function name.
function M.dap_call(mod, fn)
  return function()
    local ok, m = pcall(require, mod)
    if not ok then
      vim.notify(mod .. " is not available", vim.log.levels.WARN)
      return
    end
    local f = m[fn]
    if type(f) == "function" then
      f()
    end
  end
end

-- Toggle the DAP REPL if DAP is available.
function M.toggle_dap_repl()
  local ok_repl, dap_repl = pcall(require, "dap.repl")
  if not ok_repl then
    vim.notify("dap.repl is not available", vim.log.levels.WARN)
    return
  end
  if type(dap_repl.toggle) == "function" then
    dap_repl.toggle()
  end
end

-- Switch to the next configured theme.
function M.theme_next()
  local ok, themes = pcall(require, "plugins.themes")
  if ok then
    themes.next()
  end
end

-- Switch to the previous configured theme.
function M.theme_previous()
  local ok, themes = pcall(require, "plugins.themes")
  if ok then
    themes.previous()
  end
end

-- Open a one-off ToggleTerm instance for a shell command.
local function run_file_in_term(cmd, cwd)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = cmd,
    dir = cwd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

local function java_project_root()
  local start = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  if not start or start == "" then
    start = vim.fn.getcwd()
  end

  local markers = {
    "mvnw",
    "pom.xml",
    "gradlew",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
  }
  local root_marker = vim.fs.find(markers, { upward = true, path = start })[1]
  if root_marker then
    return vim.fs.dirname(root_marker)
  end
  return start
end

local function java_build_tool(root)
  local function exists(path)
    return vim.fn.filereadable(path) == 1
  end
  local function executable(path)
    return vim.fn.executable(path) == 1
  end
  local has_mvn = vim.fn.executable("mvn") == 1

  if exists(root .. "/mvnw") then
    if has_mvn then
      vim.notify("Using system mvn instead of mvnw", vim.log.levels.INFO)
      return "mvn", "maven"
    end
    if executable(root .. "/mvnw") then
      return "./mvnw", "maven"
    end
    return "sh ./mvnw", "maven"
  end
  if exists(root .. "/pom.xml") then
    if has_mvn then
      return "mvn", "maven"
    end
    vim.notify("Maven project detected but mvn is not installed and no mvnw found", vim.log.levels.ERROR)
    return nil, nil
  end
  if exists(root .. "/gradlew") then
    if executable(root .. "/gradlew") then
      return "./gradlew", "gradle"
    end
    return "sh ./gradlew", "gradle"
  end
  if exists(root .. "/build.gradle") or exists(root .. "/build.gradle.kts") then
    return "gradle", "gradle"
  end
  return nil, nil
end

-- Compile and run the current Java file.
function M.run_java_file()
  if vim.fn.expand("%:e") == "java" then
    local class_name = vim.fn.shellescape(vim.fn.expand("%:t:r"))
    local dir = vim.fn.shellescape(vim.fn.expand("%:p:h"))
    local file = vim.fn.shellescape(vim.fn.expand("%:t"))
    run_file_in_term("cd " .. dir .. " && javac " .. file .. " && java " .. class_name)
  else
    vim.notify("Not a Java file", vim.log.levels.WARN)
  end
end

-- Build the current Java project (Maven/Gradle).
function M.run_java_build()
  local root = java_project_root()
  local cmd, tool = java_build_tool(root)
  if not cmd then
    vim.notify("No Maven/Gradle build file found for this project", vim.log.levels.WARN)
    return
  end

  if tool == "maven" then
    run_file_in_term(cmd .. " -q -DskipTests package", root)
  else
    run_file_in_term(cmd .. " -q build -x test", root)
  end
end

-- Run project tests (Maven/Gradle).
function M.run_java_tests()
  local root = java_project_root()
  local cmd, tool = java_build_tool(root)
  if not cmd then
    vim.notify("No Maven/Gradle build file found for this project", vim.log.levels.WARN)
    return
  end

  if tool == "maven" then
    run_file_in_term(cmd .. " -q test", root)
  else
    run_file_in_term(cmd .. " -q test", root)
  end
end

-- Run Spring Boot app (tries run/dev profile by build tool).
function M.run_spring_boot()
  local root = java_project_root()
  local cmd, tool = java_build_tool(root)
  if not cmd then
    vim.notify("No Maven/Gradle build file found for this project", vim.log.levels.WARN)
    return
  end

  if tool == "maven" then
    run_file_in_term(cmd .. " spring-boot:run", root)
  else
    run_file_in_term(cmd .. " bootRun", root)
  end
end

-- Run the current Python file.
function M.run_python_file()
  if vim.fn.expand("%:e") == "py" then
    local file = vim.fn.shellescape(vim.fn.expand("%:p"))
    run_file_in_term("python3 " .. file)
  else
    vim.notify("Not a Python file", vim.log.levels.WARN)
  end
end

return M
