-- Non-plugin keymaps
vim.keymap.set("v", "<c-y>", '"+y', { desc = "Copy to clipboard" })

-- Centering movements
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end of file and center" })
vim.keymap.set("n", "j", "jzz", { desc = "Move down and center" })
vim.keymap.set("n", "k", "kzz", { desc = "Move up and center" })
vim.keymap.set("n", "l", "lzz", { desc = "Move right and center" })
vim.keymap.set("n", "$", "$zz", { desc = "Move to end of line and center" })
vim.keymap.set("n", "<c-d>", "<c-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { desc = "Half-page up and center" })
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit is the laziest" })

-- Map CTRL C to Escape functionality
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode" })
vim.keymap.set("n", "<C-c>", "<Esc>", { desc = "Escape to normal mode" })
vim.keymap.set("v", "<C-c>", "<Esc>", { desc = "Escape visual mode" })
