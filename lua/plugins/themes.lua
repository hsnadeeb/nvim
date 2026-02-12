local M = {}

-- Ensure proper color rendering
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Theme configurations
local themes = {
	{
		name = "everforest",
		setup = function()
			vim.g.everforest_background = "hard"
			vim.g.everforest_better_performance = 1
			vim.g.everforest_diagnostic_text_highlight = 1
			vim.g.everforest_diagnostic_line_highlight = 1
			vim.g.everforest_diagnostic_virtual_text = "colored"
			vim.cmd.colorscheme("everforest")
		end,
	},

	{
		name = "gruvbox",
		setup = function()
			vim.g.gruvbox_contrast_dark = "hard"
			vim.g.gruvbox_invert_selection = 0
			vim.g.gruvbox_italic = 1
			vim.g.gruvbox_bold = 1
			vim.cmd.colorscheme("gruvbox")
		end,
	},

	{
		name = "nightfox",
		setup = function()
			local ok, nightfox = pcall(require, "nightfox")
			if not ok then
				return
			end

			nightfox.setup({
				options = {
					transparent = false,
					terminal_colors = true,
				},
			})

			-- carbonfox matches GitHub screenshots most closely
			vim.cmd.colorscheme("carbonfox")
		end,
	},

	{
		name = "onedark",
		setup = function()
			local ok, onedark = pcall(require, "onedark")
			if not ok then
				return
			end

			onedark.setup({
				style = "cool", -- matches GitHub preview
				transparent = false,
				term_colors = true,
				ending_tildes = false,
				code_style = {
					comments = "italic",
					keywords = "bold",
				},
			})

			onedark.load()
		end,
	},
	{
		name = "material",
		setup = function()
			vim.g.material_style = "oceanic"

			local ok, material = pcall(require, "material")
			if not ok then
				return
			end

			material.setup({
				contrast = {
					sidebars = true,
					floating_windows = true,
				},
				styles = {
					comments = { italic = true },
					keywords = { bold = true },
				},
			})

			vim.cmd.colorscheme("material")
		end,
	},
}

-- State
local state = {
	current = nil,
	initialized = false,
}

local persistence = require("theme_persistence")

local theme_titles = {
	gruvbox = "Gruvbox",
	everforest = "Everforest",
	material = "Material",
	nightfox = "Nightfox",
	onedark = "OneDark",
}

-- Utilities
local function get_theme(name)
	for _, theme in ipairs(themes) do
		if theme.name == name then
			return theme
		end
	end
	return themes[1]
end

local function show_theme_notification(theme_name)
	local title = theme_titles[theme_name] or theme_name
	vim.schedule(function()
		vim.notify("Theme: " .. title, vim.log.levels.INFO, { title = "Theme Switched", timeout = 1500, icon = "🎨" })
	end)
end

local function apply_theme(theme_name)
	if not theme_name then
		return
	end

	local theme = get_theme(theme_name)
	if not theme then
		return
	end

	local ok, err = pcall(theme.setup)
	if not ok then
		vim.notify("Error applying theme: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	state.current = theme.name
	persistence.save_theme(theme.name)

	show_theme_notification(theme.name)

	vim.schedule(function()
		vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" })
	end)

	return theme.name
end

-- Public API
function M.next()
	local current = state.current or persistence.load_theme()
	local index = 1

	for i, t in ipairs(themes) do
		if t.name == current then
			index = i
			break
		end
	end

	local next_index = (index % #themes) + 1
	return apply_theme(themes[next_index].name)
end

function M.previous()
	local current = state.current or persistence.load_theme()
	local index = 1

	for i, t in ipairs(themes) do
		if t.name == current then
			index = i
			break
		end
	end

	local prev_index = (index - 2) % #themes + 1
	return apply_theme(themes[prev_index].name)
end

function M.set(name)
	return apply_theme(name)
end

-- Alias for next (used by CycleTheme command)
M.cycle = M.next

function M.current()
	return state.current or persistence.load_theme()
end

function M.list()
	return vim.tbl_map(function(t)
		return t.name
	end, themes)
end

function M.setup()
	if state.initialized then
		return
	end

	vim.opt.updatetime = 250
	vim.opt.timeoutlen = 300

	local theme = persistence.load_theme() or themes[1].name
	apply_theme(theme)

	state.initialized = true
	return theme
end

return M
