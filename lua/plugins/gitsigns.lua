local M = {}

-- Load utility functions
local utils = require("utils")

function M.setup()
	local status_ok, gitsigns = pcall(require, "gitsigns")
	if not status_ok then
		vim.notify("gitsigns.nvim not found!", vim.log.levels.ERROR)
		return
	end

	-- Configure gitsigns
	gitsigns.setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~_" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
		},
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})

	-- Setup keybindings
	-- Navigation
	utils.map("n", "<leader>gj", gitsigns.next_hunk, { desc = "Next Git Hunk" })
	utils.map("n", "<leader>gk", gitsigns.prev_hunk, { desc = "Previous Git Hunk" })

	-- Staging
	utils.map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Git Hunk" })
	utils.map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
	utils.map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })

	-- Reset
	utils.map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Git Hunk" })
	utils.map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
	utils.map("n", "<leader>gU", gitsigns.reset_buffer_index, { desc = "Reset Buffer Index" })

	-- Diff
	utils.map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git Diff" })
	utils.map("n", "<leader>gD", function()
		gitsigns.diffthis("~")
	end, { desc = "Git Diff (Staged)" })

	-- Blame
	utils.map("n", "<leader>gbl", function()
		gitsigns.blame_line({ full = true })
	end, { desc = "Git Blame Line" })
	utils.map("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "Toggle Git Blame" })

	-- Preview
	utils.map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Git Hunk" })
	utils.map("n", "<leader>gP", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

	-- Toggles
	utils.map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Toggle Git Deleted" })
	utils.map("n", "<leader>gtl", gitsigns.toggle_linehl, { desc = "Toggle Git Line Highlight" })
	utils.map("n", "<leader>gtw", gitsigns.toggle_word_diff, { desc = "Toggle Git Word Diff" })
	utils.map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle Git Blame" })

	-- Mappings are now centrally managed in which-key.lua
end

return M

