-- Disable netrw plugin (recommended when using yazi)
vim.g.loaded_netrwPlugin = 1

require("yazi").setup({
	open_for_directories = true,
	keymaps = { show_help = "<f1>" },
	config = {
		keymaps = { copy_relative_path_to_selected_files = nil },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>m", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Open file manager in nvim's cwd" })
vim.keymap.set("n", "<c-up>", "<cmd>Yazi prev<cr>", { desc = "Resume last yazi session" })
