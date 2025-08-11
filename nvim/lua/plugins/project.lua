-- Project (root) auto-detection
require("project_nvim").setup({
	detection_methods = { "lsp", "pattern" },
	patterns = { ".git", "compile_commands.json", "package.json", "go.mod", "pyproject.toml", "Makefile" },
	silent_chdir = true,
	respect_buf_cwd = false,
})

-- optional: integrate with telescope
pcall(require("telescope").load_extension, "projects")
