-- require("gruvbox").setup({
-- 	contrast = "hard",
-- 	palette_overrides = {
-- 		dark0_hard = "#0a0a0a",
-- 	},
-- 	overrides = {
-- 		SignColumn = { bg = "none" },
-- 	},
-- })
-- vim.cmd.colorscheme("gruvbox")

-- vim.cmd.colorscheme("nightSyscall")
-- vim.cmd.colorscheme("spacecamp")
-- vim.cmd.colorscheme("cyberdream")
-- vim.cmd.colorscheme("andromeda")
-- vim.cmd.colorscheme("noctishc")
require("tokyonight").setup({
	style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
	light_style = "day", -- The theme is used when the background is set to light
	transparent = false, -- Enable this to disable setting the background color
	terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
		-- Background styles. Can be "dark", "transparent" or "normal"
		sidebars = "dark", -- style for sidebars, see below
		floats = "dark", -- style for floating windows
	},
	sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
	floats = true, -- Set the background color of floating windows to the same as the main editor window
	on_colors = function(colors)
		colors.bg = "#000000"
		colors.bg_dark = "#000000"
		colors.bg_dark1 = "#000000"
	end,
})
vim.cmd.colorscheme("tokyonight")
-- vim.cmd.colorscheme("duskhaven")
-- vim.cmd.colorscheme("onedark")
-- vim.cmd.colorscheme("moonfly")

---------------------------------- Pastel low contrast --------------------------

-- vim.cmd.colorscheme("vague")
-- vim.cmd.colorscheme("godot")
-- vim.cmd.colorscheme("kanagawa-dragon")
