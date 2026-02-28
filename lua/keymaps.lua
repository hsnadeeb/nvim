-- ============================================================================
-- Global Keybindings (plugin-agnostic or lazy-safe wrappers)
-- ============================================================================

local utils = require("config.utils")
local map = utils.map

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

-- Buffer management (barbar)
map("n", "<leader>ww", ":BufferClose<CR>", { desc = "Close buffer" })
map("n", "<leader>wW", ":BufferClose!<CR>", { desc = "Force close buffer" })
map("n", "<leader>ws", ":w<CR>", { desc = "Save file" })
map("n", "<leader>wq", ":w | BufferClose<CR>", { desc = "Save and close" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force quit" })

-- Select entire buffer
map("n", "<leader>y", "ggVG", { desc = "Select entire buffer" })

-- LSP extra, buffer-local maps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf

		local function buf_map(lhs, rhs, desc)
			utils.buf_map(bufnr, "n", lhs, rhs, { desc = desc })
		end

		buf_map("gs", vim.lsp.buf.document_symbol, "Document symbols")
		buf_map("gS", vim.lsp.buf.workspace_symbol, "Workspace symbols")

		-- IntelliJ-like aliases
		buf_map("<leader>bb", vim.lsp.buf.definition, "Go to definition")
		buf_map("<leader>bi", vim.lsp.buf.implementation, "Go to implementation")
		buf_map("<leader>br", vim.lsp.buf.references, "Find usages")
	end,
})

-- Telescope extras
local function telescope_call(fn_name, opts)
	return function()
		local ok, builtin = pcall(require, "telescope.builtin")
		if not ok then
			vim.notify("Telescope is not available", vim.log.levels.WARN)
			return
		end
		builtin[fn_name](opts or {})
	end
end

map("n", "<leader>dd", telescope_call("diagnostics", { bufnr = nil }), { desc = "Workspace Diagnostics" })
map("n", "<leader>fk", telescope_call("keymaps"), { desc = "Find Keymaps" })
map("n", "<leader>fs", telescope_call("lsp_document_symbols"), { desc = "Document Symbols" })
map("n", "<leader>fS", telescope_call("lsp_workspace_symbols"), { desc = "Workspace Symbols" })
map("n", "<leader>fd", telescope_call("lsp_definitions"), { desc = "LSP Definitions" })
map("n", "<leader>fi", telescope_call("lsp_implementations"), { desc = "LSP Implementations" })

-- DAP leader mappings (lazy-safe wrappers)
local function dap_call(mod, fn)
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

map("n", "<leader>dc", dap_call("dap", "continue"), { desc = "Continue" })
map("n", "<leader>di", dap_call("dap", "step_into"), { desc = "Step into" })
map("n", "<leader>do", dap_call("dap", "step_over"), { desc = "Step over" })
map("n", "<leader>dO", dap_call("dap", "step_out"), { desc = "Step out" })
map("n", "<leader>dl", dap_call("dap", "run_last"), { desc = "Run last" })
map("n", "<leader>dx", dap_call("dap", "terminate"), { desc = "Terminate" })
map("n", "<leader>du", dap_call("dapui", "toggle"), { desc = "Toggle DAP UI" })
map("n", "<leader>dr", function()
	local ok, dap = pcall(require, "dap")
	if not ok then
		vim.notify("dap is not available", vim.log.levels.WARN)
		return
	end
	dap.repl.toggle()
end, { desc = "Toggle REPL" })

-- Theme cycling
map("n", "<leader>Tn", function()
	local ok, themes = pcall(require, "plugins.themes")
	if ok then
		themes.next()
	end
end, { desc = "Next Theme" })

map("n", "<leader>Tp", function()
	local ok, themes = pcall(require, "plugins.themes")
	if ok then
		themes.previous()
	end
end, { desc = "Previous Theme" })

-- Run current Java/Python file in ToggleTerm
local function run_file_in_term(cmd)
	local Terminal = require("toggleterm.terminal").Terminal
	local term = Terminal:new({
		cmd = cmd,
		direction = "horizontal",
		close_on_exit = false,
	})
	term:toggle()
end

map("n", "<leader>jr", function()
	if vim.fn.expand("%:e") == "java" then
		local class_name = vim.fn.shellescape(vim.fn.expand("%:t:r"))
		local dir = vim.fn.shellescape(vim.fn.expand("%:p:h"))
		local file = vim.fn.shellescape(vim.fn.expand("%:t"))
		run_file_in_term("cd " .. dir .. " && javac " .. file .. " && java " .. class_name)
	else
		vim.notify("Not a Java file", vim.log.levels.WARN)
	end
end, { desc = "Compile and run Java file" })

map("n", "<leader>pr", function()
	if vim.fn.expand("%:e") == "py" then
		local file = vim.fn.shellescape(vim.fn.expand("%:p"))
		run_file_in_term("python3 " .. file)
	else
		vim.notify("Not a Python file", vim.log.levels.WARN)
	end
end, { desc = "Run Python file" })

-- Remove conflicting default mapping from comment.nvim
pcall(vim.keymap.del, "n", "gc")
