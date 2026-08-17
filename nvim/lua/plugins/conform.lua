require("conform").setup({
	formatters_by_ft = {
		-- C/C++ formatting
		c = { "clang-format" },
		cpp = { "clang-format" },
		-- Go formatting and import organization
		go = { "goimports", "gofumpt" },
		-- Java formatting
		java = { "google-java-format" },
		-- JavaScript/TypeScript formatting: prettier for layout, then eslint --fix for style-guide rules
		javascript = { "prettierd", "eslint_d" },
		javascriptreact = { "prettierd", "eslint_d" },
		-- Prefer jq for strict JSON; fall back to prettier if present
		json = { "jq", "prettierd", "prettier" },
		-- Support JSON with comments
		jsonc = { "prettierd", "prettier" },
		-- Lua formatting
		lua = { "stylua" },
		-- Markdown formatting
		markdown = { "prettierd", "prettier" },
		-- Python formatting with black and isort
		python = { "isort", "black" },
		-- Ruby formatting
		ruby = { "rubocop" },
		-- TypeScript formatting: prettier for layout, then eslint --fix for style-guide rules
		typescript = { "prettierd", "eslint_d" },
		typescriptreact = { "prettierd", "eslint_d" },
		yaml = { "yamlfmt" },
		yml = { "yamlfmt" },
	},
	formatters = {
		-- Custom goimports configuration for import organization
		goimports = {
			prepend_args = { "-local", "github.com" }, -- Adjust this to your org/project
		},
		-- Custom clang-format configuration
		["clang-format"] = {
			prepend_args = {
				"--style={IndentWidth: 2, ColumnLimit: 100, UseTab: Never, AllowShortFunctionsOnASingleLine: None}",
			},
		},
	},
	-- Format on save for specific file types
	format_on_save = function(bufnr)
		-- Disable format_on_save for certain file types or large files
		local filetype = vim.bo[bufnr].filetype
		local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))

		-- Skip formatting for large files (>500KB)
		if file_size > 500000 then
			return nil
		end

		-- Enable auto-format for these languages
		local auto_format_ft = {
			"c",
			"cpp",
			"go",
			"java",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"python",
			"ruby",
			"typescript",
			"typescriptreact",
			"yaml",
			"yml",
		}

		if vim.tbl_contains(auto_format_ft, filetype) then
			return {
				timeout_ms = 5000,
				lsp_fallback = true,
			}
		end

		return nil
	end,
	notify_on_error = true,
})

-- Manual formatting keybind (works for all file types).
-- NOTE: <leader>f is owned by Snacks grep; manual format lives on <leader>cf.
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer (Conform)" })

-- Go imports are organized by goimports on save (format_on_save) and via <leader>cf.
-- The old <leader>gi mapping was removed; that key is owned by Snacks (GitHub issues).

-- Format on save toggle
vim.g.conform_format_on_save = true
-- vim.keymap.set("n", "<leader>tf", function()
-- 	vim.g.conform_format_on_save = not vim.g.conform_format_on_save
-- 	local status = vim.g.conform_format_on_save and "enabled" or "disabled"
-- 	vim.notify("Format on save " .. status, vim.log.levels.INFO)
-- end, { desc = "Toggle format on save" })
