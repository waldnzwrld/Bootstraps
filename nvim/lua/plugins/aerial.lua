require("aerial").setup({
	-- Backends are tried in order; first one that yields symbols wins. treesitter
	-- works without a language server, lsp is richer when one is attached.
	backends = { "treesitter", "lsp", "markdown", "man" },
	layout = {
		default_direction = "prefer_left",
		min_width = 30,
		win_opts = { winblend = 0 },
	},
	-- Highlight the symbol under the cursor and keep the tree in sync.
	attach_mode = "window",
	filter_kind = false,
	highlight_on_hover = true,
	show_guides = true,
	on_attach = function(bufnr)
		vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial prev symbol" })
		vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial next symbol" })
	end,
})

vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Aerial outline toggle" })
