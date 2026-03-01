-- ============================================================================
-- Java / JDTLS Configuration
-- ============================================================================

local M = {}

local root_markers = {
  ".git",
  "mvnw",
  "pom.xml",
  "gradlew",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
}

local function find_root()
  local ok_setup, jdtls_setup = pcall(require, "jdtls.setup")
  if ok_setup and jdtls_setup.find_root then
    return jdtls_setup.find_root(root_markers)
  end

  local current = vim.api.nvim_buf_get_name(0)
  local start = vim.fs.dirname(current)
  local marker = vim.fs.find(root_markers, { upward = true, path = start })[1]
  return marker and vim.fs.dirname(marker) or nil
end

local function get_bundles()
  local mason = vim.fn.stdpath("data") .. "/mason/packages"
  local bundles = {}

  vim.list_extend(
    bundles,
    vim.fn.glob(
      mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
      true,
      true
    )
  )
  vim.list_extend(
    bundles,
    vim.fn.glob(
      mason .. "/java-test/extension/server/*.jar",
      true,
      true
    )
  )

  return bundles
end

local function build_cmd(workspace_dir)
  local mason = vim.fn.stdpath("data") .. "/mason/packages"
  local jdtls_bin = mason .. "/jdtls/bin/jdtls"
  local lombok = mason .. "/jdtls/lombok.jar"

  local cmd = {}
  if vim.fn.executable(jdtls_bin) == 1 then
    cmd = { jdtls_bin }
  else
    cmd = { "jdtls" }
  end

  if vim.fn.filereadable(lombok) == 1 then
    table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
  end

  table.insert(cmd, "-data")
  table.insert(cmd, workspace_dir)
  return cmd
end

local function setup_java_keymaps(bufnr)
  local ok_utils, utils = pcall(require, "config.utils")
  local ok_jdtls, jdtls = pcall(require, "jdtls")
  if not ok_utils or not ok_jdtls then
    return
  end

  local organize_imports = jdtls["organize_imports"]
  local extract_variable = jdtls["extract_variable"]
  local extract_constant = jdtls["extract_constant"]
  local extract_method = jdtls["extract_method"]
  local test_nearest_method = jdtls["test_nearest_method"]
  local test_class = jdtls["test_class"]
  local update_project_config = jdtls["update_project_config"]

  if type(organize_imports) == "function" then
    utils.buf_map(bufnr, "n", "<leader>jo", organize_imports, { desc = "Java Organize Imports" })
  end
  if type(extract_variable) == "function" then
    utils.buf_map(bufnr, "n", "<leader>jv", extract_variable, { desc = "Java Extract Variable" })
  end
  if type(extract_constant) == "function" then
    utils.buf_map(bufnr, "n", "<leader>jc", extract_constant, { desc = "Java Extract Constant" })
  end
  if type(extract_method) == "function" then
    utils.buf_map(bufnr, "v", "<leader>jm", function()
      extract_method(true)
    end, { desc = "Java Extract Method" })
  end
  if type(test_nearest_method) == "function" then
    utils.buf_map(bufnr, "n", "<leader>jt", test_nearest_method, { desc = "Java Test Nearest" })
  end
  if type(test_class) == "function" then
    utils.buf_map(bufnr, "n", "<leader>jT", test_class, { desc = "Java Test Class" })
  end
  if type(update_project_config) == "function" then
    utils.buf_map(bufnr, "n", "<leader>ju", update_project_config, { desc = "Java Update Project Config" })
  end
end

function M.start_or_attach()
  local ok_jdtls, jdtls = pcall(require, "jdtls")
  if not ok_jdtls then
    vim.notify("nvim-jdtls is not available", vim.log.levels.WARN)
    return
  end

  local root_dir = find_root()
  if not root_dir or root_dir == "" then
    vim.notify("No Java project root found", vim.log.levels.WARN)
    return
  end

  local project_name = vim.fs.basename(root_dir)
  local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local config = {
    cmd = build_cmd(workspace_dir),
    root_dir = root_dir,
    capabilities = capabilities,
    init_options = { bundles = get_bundles() },
    flags = { allow_incremental_sync = true },
    settings = {
      java = {
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        inlayHints = { parameterNames = { enabled = "all" } },
      },
    },
    on_attach = function(client, bufnr)
      if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      setup_java_keymaps(bufnr)
    end,
  }

  local start_or_attach = jdtls["start_or_attach"]
  if type(start_or_attach) == "function" then
    start_or_attach(config)
  else
    vim.notify("jdtls.start_or_attach is unavailable", vim.log.levels.WARN)
    return
  end

  local setup_dap = jdtls["setup_dap"]
  if type(setup_dap) == "function" then
    setup_dap({ hotcodereplace = "auto" })
  end

  local ok_dap, jdtls_dap = pcall(require, "jdtls.dap")
  if ok_dap and jdtls_dap.setup_dap_main_class_configs then
    jdtls_dap.setup_dap_main_class_configs()
  end
end

return M
