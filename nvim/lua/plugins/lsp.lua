-- LSP configuration using Neovim 0.11+ native vim.lsp.config API.
-- blink.cmp injects its own completion capabilities into every server on
-- setup, so we only need to add the folding capability UFO wants. Merged
-- via vim.lsp.config("*") so it reaches every enabled server.
vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
		},
	},
})

-- Enhanced diagnostic configuration
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
		source = "if_many",
		format = function(diagnostic)
			if diagnostic.severity == vim.diagnostic.severity.ERROR then
				return string.format("✗ %s", diagnostic.message)
			elseif diagnostic.severity == vim.diagnostic.severity.WARN then
				return string.format("⚠ %s", diagnostic.message)
			else
				return string.format("ℹ %s", diagnostic.message)
			end
		end,
	},
	signs = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
	severity_sort = true,
	update_in_insert = false,
})

-- Set diagnostic signs
local signs = { Error = "✗", Warn = "⚠", Hint = "💡", Info = "ℹ" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Inlay hints if supported
if vim.lsp.inlay_hint then
	vim.lsp.inlay_hint.enable(true)
end

-- Buffer-local LSP keymaps: set them on LspAttach so they only apply to
-- buffers with a language server, and so `buffer` is a real bufnr (not a
-- nil captured at module load time).
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(args)
		-- Don't install LSP keymaps on terminals or other special buffers.
		-- copilot (and similar) attach to every buffer, including the
		-- toggleterm/sidekick terminals; without this guard their attach would
		-- map keys like <C-k> buffer-locally on the terminal and shadow the
		-- smart-splits window-navigation mappings.
		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		local k = vim.keymap.set
		local bufopts = { noremap = true, silent = true, buffer = args.buf }

		-- Navigation keymaps
		k("n", "gD", vim.lsp.buf.declaration, bufopts)
		k("n", "gd", vim.lsp.buf.definition, bufopts)
		k("n", "gi", vim.lsp.buf.implementation, bufopts)
		k("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
		k("n", "gr", vim.lsp.buf.references, bufopts)

		-- Code actions and refactoring
		k("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
		k("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)
		k("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

		k("n", "<leader>e", vim.diagnostic.open_float, bufopts)
		-- <leader>q closes a buffer (see core/keymaps.lua). Diagnostics list: <leader>xx / <leader>xX (Snacks).

		-- NOTE: signature help is deliberately NOT on <C-k> -- that key is
		-- smart-splits "move to window above" (see plugins/smart_splits.lua)
		-- and a buffer-local <C-k> here would shadow it in every LSP buffer.
		k("n", "gK", vim.lsp.buf.signature_help, bufopts)
		k("i", "<C-g>k", vim.lsp.buf.signature_help, bufopts)

		-- Workspace management
		k("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
		k("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
		k("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)
	end,
})
