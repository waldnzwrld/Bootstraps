-- Non-plugin keymaps
vim.keymap.set("v", "<c-y>", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader><Tab><Tab>", ":set invlist<CR>", { desc = "show list mode for tabs new lines etc" })

-- Centering movements
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end of file and center" })
vim.keymap.set("n", "gg", "ggzz", { desc = "Go to top of file and center" })
vim.keymap.set("n", "j", "jzz", { desc = "Move down and center" })
vim.keymap.set("n", "k", "kzz", { desc = "Move up and center" })
vim.keymap.set("n", "l", "lzz", { desc = "Move right and center" })
vim.keymap.set("n", "$", "$zz", { desc = "Move to end of line and center" })
vim.keymap.set("n", "_", "_zz", { desc = "Move to beginning of line and center" })
vim.keymap.set("n", "<c-m>", "<c-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { desc = "Half-page up and center" })

-- Map CTRL C to Escape functionality
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode" })
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Remove search highlighting" })
vim.keymap.set("v", "<C-c>", "<Esc>", { desc = "Escape visual mode" })
vim.keymap.set("s", "<C-c>", "<Esc>", { desc = "Escape select mode" })

-- Map CTRL S to Escape/Write functionality
vim.keymap.set("i", "<C-s>", "<Esc>:write<CR>", { desc = "Escape insert mode" })
vim.keymap.set("n", "<C-s>", "<Esc>:write<CR>", { desc = "Escape to normal mode" })
vim.keymap.set("v", "<C-s>", "<Esc>:write<CR>", { desc = "Escape visual mode" })

-- map leader f to Telescope finder
vim.keymap.set("n", "<leader>f", ":Telescope live_grep<CR>", { desc = "Telescope finder" })

-- map leader i to toggle inlay hints
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)

-- LazyGit
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit is the laziest" })

-- GitLinker
vim.keymap.set("n", "<leader>gl", ":GitLink<CR>", { desc = "GitLinker Copy URL" })
vim.keymap.set("i", "<leader>gl", ":GitLink<CR>", { desc = "GitLinker Copy URL" })
vim.keymap.set("v", "<leader>gl", ":GitLink<CR>", { desc = "GitLinker Copy URL" })

-- Cursor
vim.keymap.set("n", "<leader>cc", ":CursorAgent<CR>", { desc = "Cursor Agent" })
vim.keymap.set("v", "<leader>cu", ":CursorAgentSelection<CR>", { desc = "Cursor Agent Selection" })
vim.keymap.set("n", "<leader>cu", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent Buffer" })

-- Codeium Chat
vim.keymap.set("n", "<leader>ct", ":Codeium Toggle<CR>", { desc = "Codeium Toggle" })

-- Terminal
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>", { desc = "exit terminal insert" })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
