require("nvim-surround").setup({
	-- Ensure visual mode behavior isn't modified
	keymaps = {
		visual = "S",
		visual_line = "gS",
	},
})
