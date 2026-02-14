-- ============================================================================
-- Keybindings
-- ============================================================================

local utils = require("config.utils")
local map = utils.map

-- ============================================================================
-- General Navigation
-- ============================================================================

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

-- Line navigation
map("n", "H", "^", { desc = "Start of line" })
map("n", "L", "$", { desc = "End of line" })
map("v", "H", "^", { desc = "Start of line" })
map("v", "L", "$", { desc = "End of line" })

-- Quickfix
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })
map("n", "[q", ":cprev<CR>", { desc = "Prev quickfix" })

-- ============================================================================
-- Buffer Management
-- ============================================================================

map("n", "<leader>bd", ":BufferClose<CR>", { desc = "Close buffer" })
map("n", "<leader>bD", ":BufferClose!<CR>", { desc = "Force close buffer" })
map("n", "<leader>ws", ":w<CR>", { desc = "Save file" })
map("n", "<leader>wq", ":w | BufferClose<CR>", { desc = "Save and close" })

-- ============================================================================
-- Yank/Cut/Paste
-- ============================================================================

-- Yank entire buffer
map("n", "<leader>yy", "ggVGy", { desc = "Yank entire buffer" })

-- ============================================================================
-- LSP Keymaps (buffer-local)
-- ============================================================================

local function setup_lsp_keymaps(bufnr)
	local buf_map = function(key, cmd, desc)
		utils.buf_map(bufnr, "n", key, cmd, { desc = desc })
	end

	local function safe_lsp_call(func, msg)
		return function()
			local ok, _ = pcall(func)
			if not ok then
				vim.notify("LSP: " .. msg, vim.log.levels.INFO)
			end
		end
	end

	buf_map("K", safe_lsp_call(vim.lsp.buf.hover, "no docs"), "Hover docs")
	buf_map("<C-k>", safe_lsp_call(vim.lsp.buf.signature_help, "no signature"), "Signature help")
	buf_map("gr", safe_lsp_call(vim.lsp.buf.references, "no refs"), "References")
	buf_map("gs", safe_lsp_call(vim.lsp.buf.document_symbol, "no symbols"), "Document symbols")
	buf_map("gS", safe_lsp_call(vim.lsp.buf.workspace_symbol, "no ws symbols"), "Workspace symbols")
	buf_map("gt", safe_lsp_call(vim.lsp.buf.type_definition, "no type def"), "Type definition")

	-- IntelliJ-like
	buf_map("<leader>bb", safe_lsp_call(vim.lsp.buf.definition, "no def"), "Go to definition (Cmd+B)")
	buf_map("<leader>bi", safe_lsp_call(vim.lsp.buf.implementation, "no impl"), "Go to implementation")
	buf_map("<leader>br", safe_lsp_call(vim.lsp.buf.references, "no refs"), "Find usages")
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		setup_lsp_keymaps(args.buf)
	end,
})

-- ============================================================================
-- Telescope (additional)
-- ============================================================================

local function telescope_keymap(builtin_name, desc)
	map("n", "<leader>" .. builtin_name, function()
		local builtin = require("telescope.builtin")
		builtin[builtin_name]()
	end, { desc = desc })
end

telescope_keymap("fk", "Find Keymaps")
telescope_keymap("fs", "Document Symbols")
telescope_keymap("fS", "Workspace Symbols")
telescope_keymap("fd", "LSP Definitions")
telescope_keymap("fi", "LSP Implementations")

-- ============================================================================
-- DAP
-- ============================================================================

map("n", "<leader>dc", require("dap").continue, { desc = "Continue" })
map("n", "<leader>di", require("dap").step_into, { desc = "Step into" })
map("n", "<leader>do", require("dap").step_over, { desc = "Step over" })
map("n", "<leader>dO", require("dap").step_out, { desc = "Step out" })
map("n", "<leader>dr", require("dap").repl.toggle, { desc = "Toggle REPL" })
map("n", "<leader>dl", require("dap").run_last, { desc = "Run last" })
map("n", "<leader>du", require("dapui").toggle, { desc = "Toggle DAP UI" })
map("n", "<leader>dx", require("dap").terminate, { desc = "Terminate" })

-- ============================================================================
-- Which-key Groups
-- ============================================================================

local wk = utils.safe_require("which-key")
if wk then
	local builtin = require("telescope.builtin")
	wk.register({
		["<leader>a"] = {
			name = "+autosave",
			a = {
				_G.toggle_autosave or function()
					vim.notify("AutoSave not loaded", vim.log.levels.WARN)
				end,
				"Toggle AutoSave",
			},
		},
		["<leader>f"] = {
			name = "+find",
			f = { builtin.find_files, "Find File" },
			g = { builtin.live_grep, "Live Grep" },
			b = { builtin.buffers, "Buffers" },
			h = { builtin.help_tags, "Help Tags" },
			r = { builtin.oldfiles, "Recent Files" },
			k = { builtin.keymaps, "Keymaps" },
			s = { builtin.lsp_document_symbols, "Document Symbols" },
			S = { builtin.lsp_workspace_symbols, "Workspace Symbols" },
			d = { builtin.lsp_definitions, "Definitions" },
			i = { builtin.lsp_implementations, "Implementations" },
		},
		["<leader>b"] = {
			name = "+buffer",
			d = { ":BufferClose<CR>", "Close" },
			n = { ":BufferNext<CR>", "Next" },
			p = { ":BufferPrevious<CR>", "Previous" },
		},
		["<leader>g"] = {
			name = "+git",
			c = { "<cmd>Telescope git_commits<CR>", "Commits" },
			B = { "<cmd>Telescope git_branches<CR>", "Branches" },
			s = { "<cmd>Telescope git_status<CR>", "Status" },
			j = { require("gitsigns").next_hunk, "Next Hunk" },
			k = { require("gitsigns").prev_hunk, "Prev Hunk" },
			p = { require("gitsigns").preview_hunk, "Preview Hunk" },
		},
		["<leader>l"] = {
			name = "+lsp",
			a = { vim.lsp.buf.code_action, "Code Action" },
			d = { vim.diagnostic.open_float, "Diagnostics" },
			D = { vim.lsp.buf.declaration, "Declaration" },
			i = { vim.lsp.buf.implementation, "Implementation" },
			r = { vim.lsp.buf.references, "References" },
			n = { vim.lsp.buf.rename, "Rename" },
			f = { require("conform").format, "Format" },
			h = { vim.lsp.buf.hover, "Hover" },
		},
		["<leader>x"] = {
			name = "+diagnostics",
			x = { "<cmd>TroubleToggle<CR>", "Toggle" },
			w = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace" },
			d = { "<cmd>TroubleToggle document_diagnostics<CR>", "Document" },
			q = { "<cmd>TroubleToggle quickfix<CR>", "Quickfix" },
		},
		["<leader>t"] = {
			name = "+terminal",
			["`"] = { "<cmd>ToggleTerm<CR>", "Toggle" },
			f = { "<cmd>ToggleTerm direction=float<CR>", "Float" },
			v = { "<cmd>ToggleTerm direction=vertical<CR>", "Vertical" },
			h = { "<cmd>ToggleTerm direction=horizontal<CR>", "Horizontal" },
		},
		["<leader>s"] = {
			name = "+session",
			s = { "<cmd>Autosession save<CR>", "Save" },
			r = { "<cmd>Autosession restore<CR>", "Restore" },
			d = { "<cmd>Autosession delete<CR>", "Delete" },
		},
		["<leader>r"] = {
			name = "+search/replace",
			w = {
				function()
					require("spectre").open_visual({ select_word = true })
				end,
				"Replace word",
			},
			p = {
				function()
					require("spectre").open()
				end,
				"Replace in project",
			},
			f = {
				function()
					require("spectre").open_file_search()
				end,
				"Replace in file",
			},
		},
		["<leader>re"] = {
			name = "+extract",
			e = { ":Refactor extract ", "Extract to function" },
			f = { ":Refactor extract_to_file ", "Extract to file" },
			i = { ":Refactor inline_var", "Inline variable" },
			b = { ":Refactor extract_block ", "Extract block" },
		},
		["<leader>T"] = {
			name = "+theme",
			n = {
				function()
					require("plugins.config.themes").next()
				end,
				"Next Theme",
			},
			p = {
				function()
					require("plugins.config.themes").previous()
				end,
				"Previous Theme",
			},
		},
		["<leader>y"] = {
			name = "+yank",
			y = { "ggVGy", "Yank entire buffer" },
		},
		["<leader>w"] = {
			name = "+write/quit",
			s = { "<cmd>w<CR>", "Save" },
			q = { "<cmd>wq<CR>", "Save & Quit" },
		},
		["<leader>q"] = {
			function()
				if vim.fn.bufname("") ~= "NvimTree" then
					vim.cmd("q")
				end
			end,
			"Quit",
		},
		["<leader>Q"] = {
			function()
				if vim.fn.bufname("") ~= "NvimTree" then
					vim.cmd("q!")
				end
			end,
			"Force Quit",
		},
	})
end

-- Clean up conflicting mappings
pcall(vim.keymap.del, "n", "gc")
