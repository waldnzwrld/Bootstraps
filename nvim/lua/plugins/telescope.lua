require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
			},
			n = {
				["j"] = require("telescope.actions").move_selection_next,
				["k"] = require("telescope.actions").move_selection_previous,
			},
		},
	},
	pickers = {
		lsp_definitions = { jump_type = "never" },
	},
})

local t = require("telescope.builtin")
vim.keymap.set("n", "<leader>gd", t.lsp_definitions, { desc = "Telescope: LSP Definitions" })
vim.keymap.set("n", "<leader>gr", t.lsp_references, { desc = "Telescope: LSP References" })
vim.keymap.set("n", "<leader>gi", t.lsp_implementations, { desc = "Telescope: LSP Implementations" })
vim.keymap.set("n", "<leader>ds", t.lsp_document_symbols, { desc = "Telescope: Document Symbols" })
vim.keymap.set("n", "<leader>ws", t.lsp_dynamic_workspace_symbols, { desc = "Telescope: Workspace Symbols" })
