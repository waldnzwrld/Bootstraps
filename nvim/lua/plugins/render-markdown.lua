require("render-markdown").setup({
	completions = { lsp = { enabled = true } },
})
-- require("mkdp")

vim.keymap.set("n", "<leader>po", ":MarkdownPreview<CR>", { desc = "Open Markdown Preview" })
vim.keymap.set("n", "<leader>pc", ":MarkdownPreviewStop<CR>", { desc = "Close Markdown Preview" })
vim.keymap.set("n", "<leader>pp", ":MarkdownPreviewToggle<CR>", { desc = "Restart Markdown Preview" })
