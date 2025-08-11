require("go").setup({
	-- Disable features that overlap with your LSP setup
	lsp_cfg = false, -- Don't configure LSP (you have comprehensive lsp.lua)
	lsp_gofumpt = false, -- Don't configure gofumpt via LSP (conform handles formatting)
	lsp_on_attach = false, -- Don't override your LSP on_attach

	-- Enable useful Go-specific features
	goimports = "gopls", -- Use gopls for imports (consistent with LSP)
	gofmt = "gofumpt", -- Use gofumpt for stricter formatting
	tag_transform = false, -- Don't auto-transform struct tags

	-- Test configuration
	test_runner = "go", -- Use standard go test
	run_in_floaterm = false, -- Run tests in regular terminal

	-- Debugging
	dap_debug = true, -- Enable DAP integration if vimspector isn't sufficient
	dap_debug_gui = false, -- Use text-based debugging interface

	-- Code generation and refactoring
	textobjects = false, -- Disable Go-specific text objects (interferes with visual mode)
	test_efm = true, -- Better error formatting for tests

	-- Diagnostic and linting (complementary to LSP)
	lsp_diag_hdlr = false, -- Let your LSP handle diagnostics
	lsp_diag_virtual_text = { space = 0, prefix = "" },
	lsp_diag_signs = false, -- Use your LSP sign configuration

	-- Icons and UI
	icons = { breakpoint = "🔴", currentpos = "🔵" },

	-- Additional tools integration
	gotests = {
		template_dir = "", -- Use default test templates
		template = "", -- Use default template
	},

	-- Build tags
	build_tags = "", -- Add build tags if needed: "integration,e2e"

	-- Coverage
	coverage = {
		sign = "▎",
		sign_covered = "▎",
	},
})

-- Additional Go-specific keymaps that complement LSP
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		local bufopts = { noremap = true, silent = true, buffer = 0 }

		-- Go-specific commands
		vim.keymap.set(
			"n",
			"<leader>gt",
			"<cmd>GoTest<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Run tests" })
		)
		vim.keymap.set(
			"n",
			"<leader>gT",
			"<cmd>GoTestFile<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Test current file" })
		)
		vim.keymap.set(
			"n",
			"<leader>gc",
			"<cmd>GoCoverage<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Show coverage" })
		)
		vim.keymap.set(
			"n",
			"<leader>gC",
			"<cmd>GoCoverageClear<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Clear coverage" })
		)

		-- Code generation
		vim.keymap.set(
			"n",
			"<leader>gsj",
			"<cmd>GoAddTag json<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Add json tags" })
		)
		vim.keymap.set(
			"n",
			"<leader>gsy",
			"<cmd>GoAddTag yaml<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Add yaml tags" })
		)
		vim.keymap.set(
			"n",
			"<leader>gsr",
			"<cmd>GoRmTag<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Remove tags" })
		)
		vim.keymap.set(
			"n",
			"<leader>gsf",
			"<cmd>GoFillStruct<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Fill struct" })
		)
		vim.keymap.set(
			"n",
			"<leader>gse",
			"<cmd>GoIfErr<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Add if err" })
		)

		-- Debugging (if vimspector isn't sufficient)
		vim.keymap.set(
			"n",
			"<leader>gdb",
			"<cmd>GoDebug<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Start debugger" })
		)
		vim.keymap.set(
			"n",
			"<leader>gdt",
			"<cmd>GoDebug -t<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Debug test" })
		)

		-- Alternative to LSP for some operations
		vim.keymap.set(
			"n",
			"<leader>gfs",
			"<cmd>GoFillSwitch<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Fill switch" })
		)
		vim.keymap.set(
			"n",
			"<leader>gfp",
			"<cmd>GoFixPlurals<cr>",
			vim.tbl_extend("force", bufopts, { desc = "Go: Fix plurals" })
		)
	end,
})
