require("smart-splits").setup({
	ignored_buftypes = { "nofile", "quickfix", "prompt" },
	ignored_filetypes = { "NvimTree" },
	resize = {
		amount = 3,
		ignored_events = { "BufEnter", "WinEnter" },
	},
	move = {
		at_edge = "wrap",
		same_row = false,
		float = "previous",
	},
	swap = {
		move_cursor = false,
	},
	log = {
		level = "info",
	},
})

-- resizing
vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)

-- moving between splits
vim.keymap.set({ "n", "t" }, "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set({ "n", "t" }, "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set({ "n", "t" }, "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set({ "n", "t" }, "<C-l>", require("smart-splits").move_cursor_right)
vim.keymap.set({ "n", "t" }, "<C-\\>", "<Cmd>wincmd p<CR>")

-- swapping buffers
vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
