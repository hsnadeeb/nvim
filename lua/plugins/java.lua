-- Java/Spring Boot Configuration for IntelliJ-like experience
-- This module provides enhanced Java development support using nvim-jdtls

local M = {}

-- Get the Mason installation path for jdtls
local function get_jdtls_paths()
	local mason_path = vim.fn.stdpath("data") .. "/mason"
	local jdtls_path = mason_path .. "/packages/jdtls"

	-- Platform-specific launcher
	local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

	-- Platform-specific config
	local os_config = "config_mac" -- Default to Mac
	if vim.fn.has("linux") == 1 then
		os_config = "config_linux"
	elseif vim.fn.has("win32") == 1 then
		os_config = "config_win"
	end

	local config_path = jdtls_path .. "/" .. os_config

	return {
		jdtls_path = jdtls_path,
		launcher_jar = launcher_jar,
		config_path = config_path,
		mason_path = mason_path,
	}
end

-- Get the workspace folder for the current project
local function get_workspace_folder()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
	vim.fn.mkdir(workspace_dir, "p")
	return workspace_dir
end

-- Get Lombok jar path if available
local function get_lombok_jar()
	local paths = get_jdtls_paths()
	-- Check common locations for lombok
	local lombok_paths = {
		paths.mason_path .. "/packages/lombok-nightly/lombok.jar",
		paths.jdtls_path .. "/lombok.jar",
		vim.fn.expand("~/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar"),
		vim.fn.expand("~/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/*/lombok-*.jar"),
	}

	for _, path in ipairs(lombok_paths) do
		local expanded = vim.fn.glob(path)
		if expanded ~= "" then
			return expanded
		end
	end
	return nil
end

-- Get debug adapter paths
local function get_debug_paths()
	local mason_path = vim.fn.stdpath("data") .. "/mason"

	-- Java debug adapter (required for debugging)
	local java_debug = vim.fn.glob(
		mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
	)

	-- Java test (optional - for running JUnit tests)
	-- Try the share directory first (recommended by Mason), then fallback to extension
	local java_test = vim.fn.glob(mason_path .. "/share/java-test/*.jar")
	if java_test == "" then
		java_test = vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar")
	end

	return {
		java_debug = java_debug,
		java_test = java_test,
	}
end

function M.setup()
	local paths = get_jdtls_paths()
	local workspace_dir = get_workspace_folder()
	local lombok_jar = get_lombok_jar()
	local debug_paths = get_debug_paths()

	-- Build the cmd
	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx2g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
	}

	-- Add Lombok support if available
	if lombok_jar then
		table.insert(cmd, "-javaagent:" .. lombok_jar)
	end

	-- Add launcher and config
	table.insert(cmd, "-jar")
	table.insert(cmd, paths.launcher_jar)
	table.insert(cmd, "-configuration")
	table.insert(cmd, paths.config_path)
	table.insert(cmd, "-data")
	table.insert(cmd, workspace_dir)

	-- Extended capabilities for nvim-cmp
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok_cmp then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	-- Bundles for debugging
	local bundles = {}
	if debug_paths.java_debug ~= "" then
		table.insert(bundles, debug_paths.java_debug)
	end
	if debug_paths.java_test ~= "" then
		vim.list_extend(bundles, vim.split(debug_paths.java_test, "\n"))
	end

	-- Root markers for project detection
	local root_markers = {
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
		"settings.gradle",
		"settings.gradle.kts",
		".git",
		"mvnw",
		"gradlew",
	}

	local root_dir = require("jdtls.setup").find_root(root_markers) or vim.fn.getcwd()

	-- JDTLS configuration
	local config = {
		cmd = cmd,
		root_dir = root_dir,
		capabilities = capabilities,

		settings = {
			java = {
				-- Eclipse JDT settings
				eclipse = {
					downloadSources = true,
				},
				-- Maven settings
				maven = {
					downloadSources = true,
					updateSnapshots = true,
				},
				-- Gradle settings
				gradle = {
					enabled = true,
					wrapper = {
						enabled = true,
					},
				},
				-- Code generation settings (like IntelliJ)
				codeGeneration = {
					toString = {
						template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					},
					useBlocks = true,
					hashCodeEquals = {
						useInstanceof = true,
						useJava7Objects = true,
					},
					generateComments = true,
				},
				-- Completion settings
				completion = {
					enabled = true,
					favoriteStaticMembers = {
						"org.junit.Assert.*",
						"org.junit.Assume.*",
						"org.junit.jupiter.api.Assertions.*",
						"org.junit.jupiter.api.Assumptions.*",
						"org.junit.jupiter.api.DynamicContainer.*",
						"org.junit.jupiter.api.DynamicTest.*",
						"org.mockito.Mockito.*",
						"org.mockito.ArgumentMatchers.*",
						"org.mockito.Answers.*",
						"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
						"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
						"org.assertj.core.api.Assertions.*",
					},
					filteredTypes = {
						"com.sun.*",
						"io.micrometer.shaded.*",
						"java.awt.*",
						"jdk.*",
						"sun.*",
					},
					importOrder = {
						"java",
						"javax",
						"org",
						"com",
						"",
					},
				},
				-- Content provider settings
				contentProvider = {
					preferred = "fernflower", -- Better decompiler
				},
				-- Source paths
				sources = {
					organizeImports = {
						starThreshold = 9999,
						staticStarThreshold = 9999,
					},
				},
				-- Configuration
				configuration = {
					updateBuildConfiguration = "automatic",
					-- Add your JDK installations here
					runtimes = {
						{
							name = "JavaSE-17",
							path = vim.fn.expand("$JAVA_HOME"),
							default = true,
						},
						{
							name = "JavaSE-21",
							path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
						},
					},
				},
				-- Format settings
				format = {
					enabled = true,
					settings = {
						url = vim.fn.stdpath("config") .. "/java-formatter.xml",
						profile = "GoogleStyle",
					},
				},
				-- Signature help
				signatureHelp = {
					enabled = true,
					description = {
						enabled = true,
					},
				},
				-- Inlay hints (like IntelliJ parameter hints)
				inlayHints = {
					parameterNames = {
						enabled = "all", -- "none" | "literals" | "all"
					},
				},
				-- Import settings
				import = {
					enabled = true,
					gradle = {
						enabled = true,
					},
					maven = {
						enabled = true,
					},
					exclusions = {
						"**/node_modules/**",
						"**/.metadata/**",
						"**/archetype-resources/**",
						"**/META-INF/maven/**",
					},
				},
				-- References code lens
				referencesCodeLens = {
					enabled = true,
				},
				-- Implementations code lens
				implementationsCodeLens = {
					enabled = true,
				},
				-- Autobuild
				autobuild = {
					enabled = true,
				},
			},
		},

		-- Initialization options
		init_options = {
			bundles = bundles,
			extendedClientCapabilities = {
				progressReportProvider = true,
				classFileContentsSupport = true,
				generateToStringPromptSupport = true,
				hashCodeEqualsPromptSupport = true,
				advancedExtractRefactoringSupport = true,
				advancedOrganizeImportsSupport = true,
				generateConstructorsPromptSupport = true,
				generateDelegateMethodsPromptSupport = true,
				moveRefactoringSupport = true,
				overrideMethodsPromptSupport = true,
				inferSelectionSupport = { "extractMethod", "extractVariable", "extractConstant" },
			},
		},

		-- On attach function
		on_attach = function(client, bufnr)
			-- Enable jdtls-specific commands
			local ok_dap, _ = pcall(require, "dap")
			if ok_dap then
				pcall(function()
					require("jdtls").setup_dap({ hotcodereplace = "auto" })
					require("jdtls.dap").setup_dap_main_class_configs()
				end)
			end

			-- Java-specific keymaps
			local opts = { buffer = bufnr, silent = true }

			-- Check if java-test is available for test commands
			local java_test_available = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/share/java-test/*.jar") ~= ""
				or vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar") ~= ""

			-- Code actions
			vim.keymap.set("n", "<leader>jo", function()
				require("jdtls").organize_imports()
			end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))

			vim.keymap.set("n", "<leader>jv", function()
				require("jdtls").extract_variable()
			end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))

			vim.keymap.set("v", "<leader>jv", function()
				require("jdtls").extract_variable(true)
			end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))

			vim.keymap.set("n", "<leader>jc", function()
				require("jdtls").extract_constant()
			end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))

			vim.keymap.set("v", "<leader>jc", function()
				require("jdtls").extract_constant(true)
			end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))

			vim.keymap.set("v", "<leader>jm", function()
				require("jdtls").extract_method(true)
			end, vim.tbl_extend("force", opts, { desc = "Extract method" }))

			-- Test keymaps (require java-test to be installed)
			vim.keymap.set("n", "<leader>jt", function()
				if java_test_available then
					require("jdtls").test_class()
				else
					vim.notify("java-test not installed. Run :MasonInstall java-test", vim.log.levels.WARN)
				end
			end, vim.tbl_extend("force", opts, { desc = "Test class" }))

			vim.keymap.set("n", "<leader>jn", function()
				if java_test_available then
					require("jdtls").test_nearest_method()
				else
					vim.notify("java-test not installed. Run :MasonInstall java-test", vim.log.levels.WARN)
				end
			end, vim.tbl_extend("force", opts, { desc = "Test nearest method" }))

			-- Generate keymaps (like IntelliJ Alt+Insert)
			vim.keymap.set("n", "<leader>jg", function()
				vim.ui.select({
					"Generate constructor",
					"Generate toString",
					"Generate hashCode/equals",
					"Generate getters/setters",
					"Override methods",
					"Delegate methods",
				}, { prompt = "Generate:" }, function(choice)
					if choice == "Generate constructor" then
						require("jdtls").generate_constructors()
					elseif choice == "Generate toString" then
						require("jdtls").generate_toString()
					elseif choice == "Generate hashCode/equals" then
						require("jdtls").generate_hashcode_equals()
					elseif choice == "Generate getters/setters" then
						-- Use code action for this
						vim.lsp.buf.code_action({
							context = { only = { "source.generate.accessors" } },
						})
					elseif choice == "Override methods" then
						require("jdtls").override_methods()
					elseif choice == "Delegate methods" then
						require("jdtls").generate_delegate_methods()
					end
				end)
			end, vim.tbl_extend("force", opts, { desc = "Generate code (Alt+Insert)" }))

			-- Update project configuration
			vim.keymap.set("n", "<leader>ju", function()
				require("jdtls").update_project_config()
			end, vim.tbl_extend("force", opts, { desc = "Update project config" }))

			-- Open Java projects
			vim.keymap.set("n", "<leader>jp", function()
				require("jdtls").open_projectsmanager()
			end, vim.tbl_extend("force", opts, { desc = "Open project manager" }))

			-- Build project
			vim.keymap.set("n", "<leader>jb", function()
				require("jdtls").build_projects({ select_mode = "all", full_build = true })
			end, vim.tbl_extend("force", opts, { desc = "Build project" }))

			-- Spring Boot specific
			vim.keymap.set("n", "<leader>jr", function()
				-- Run Spring Boot application
				local main_class = vim.fn.input("Main class (or leave empty to detect): ")
				if main_class == "" then
					require("jdtls.dap").setup_dap_main_class_configs()
					vim.cmd("DapContinue")
				else
					require("dap").run({
						type = "java",
						request = "launch",
						name = "Spring Boot",
						mainClass = main_class,
						projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
					})
				end
			end, vim.tbl_extend("force", opts, { desc = "Run Spring Boot app" }))
		end,

		flags = {
			allow_incremental_sync = true,
			debounce_text_changes = 150,
		},
	}

	return config
end

-- Start JDTLS for Java files
function M.start()
	local ok, jdtls = pcall(require, "jdtls")
	if not ok then
		vim.notify("nvim-jdtls not found!", vim.log.levels.ERROR)
		return
	end

	local config = M.setup()
	jdtls.start_or_attach(config)
end

return M
