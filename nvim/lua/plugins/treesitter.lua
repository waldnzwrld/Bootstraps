require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "cpp", "lua", "vim", "go", "python", "javascript", "typescript", "json", "yaml" },
	highlight = { enable = true },
})
