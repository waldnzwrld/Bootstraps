require("videre").setup({
	box_style = "sharp",
	line_style = "sharp",

	editor_type = "split",
	split_editor_style = {
		side = "right",
		fill_percentage = 0.7,
	},

	scrolloff = 10,
	sidescrolloff = 20,
})

vim.keymap.set("n", "<leader>jv", ":Videre<CR>", { desc = "Open Videre graph view" })
