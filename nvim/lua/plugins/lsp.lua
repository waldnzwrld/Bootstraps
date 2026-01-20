-- LSP configuration using Neovim -1.11+ native vim.lsp.config API
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Enable folding capabilities for UFO
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

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

-- on_attach with helpful keymaps
local function on_attach(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	local k = vim.keymap.set

	local root = client.root_dir or "unknown"
	vim.notify(string.format("LSP %s attached, root: %s", client.name, root), vim.log.levels.INFO)

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

	-- Diagnostic navigation
	k("n", "[d", vim.diagnostic.goto_prev, bufopts)
	k("n", "]d", vim.diagnostic.goto_next, bufopts)
	k("n", "<leader>e", vim.diagnostic.open_float, bufopts)
	k("n", "<leader>q", vim.diagnostic.setloclist, bufopts)

	-- Hover and signature help
	k("n", "K", vim.lsp.buf.hover, bufopts)
	k("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	k("i", "<C-k>", vim.lsp.buf.signature_help, bufopts)

	-- Workspace management
	k("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	k("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	k("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
end

-- Set up LspAttach autocommand for keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			on_attach(client, args.buf)
		end
	end,
})

-- Prefer source files in definition handler
do
	local original = vim.lsp.handlers["textDocument/definition"]
	vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
		if type(result) == "table" and vim.tbl_count(result) > 1 then
			local function is_preferred(uri)
				local fname = vim.uri_to_fname(uri)
				if fname:match("%.d%.ts$") then
					return false
				end
				if fname:match("%.h$") or fname:match("%.hpp$") or fname:match("%.hh$") then
					return false
				end
				return true
			end
			local filtered = {}
			for _, loc in ipairs(result) do
				local uri = loc.uri or loc.targetUri
				if uri and is_preferred(uri) then
					table.insert(filtered, loc)
				end
			end
			if #filtered > 0 then
				result = filtered
			end
		end
		return original(err, result, ctx, config)
	end
end

-- Configure LSP servers using vim.lsp.config (Neovim 0.11+ API)

-- gopls
vim.lsp.config("gopls", {
	cmd = { os.getenv("HOME") .. "/.go/bin/gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	capabilities = capabilities,
	settings = {
		gopls = {
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			gofumpt = true,
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				useany = true,
				nilness = true,
				unusedvariable = true,
				shadow = true,
			},
			codelenses = {
				gc_details = true,
				generate = true,
				regenerate_cgo = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

-- clangd
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--offset-encoding=utf-16",
		"--header-insertion=iwyu",
		"--suggest-missing-includes",
		"--all-scopes-completion",
		"--cross-file-rename",
		"--enable-config",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
	capabilities = capabilities,
})

-- Solargraph (Ruby)
vim.lsp.config("solargraph", {
	cmd = { os.getenv("HOME") .. "/.rbenv/shims/solargraph", "stdio" },
	filetypes = { "ruby" },
	root_markers = { "Gemfile", ".git" },
	capabilities = capabilities,
	settings = {
		solargraph = {
			autoformat = true,
			completion = true,
			diagnostic = true,
			folding = true,
			references = true,
			rename = true,
			symbols = true,
			gems = true,
			documentation = true,
			hover = true,
			signatureHelp = true,
			definition = true,
			workspaceSymbols = true,
			diagnostics = true,
			formatting = true,
			logLevel = "warn",
			transport = "stdio",
			plugins = { solargraph_rails = { enabled = true } },
			maps = { rails = true },
			requirePaths = {},
			reporters = {},
			maxFileSize = 1000000,
			useBundler = true,
			bundlerPath = "bundle",
			checkGemVersion = true,
			includeGems = true,
		},
	},
})

-- Python (Pyright)
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
				stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
				diagnosticSeverityOverrides = {
					reportGeneralTypeIssues = "warning",
					reportOptionalMemberAccess = "warning",
					reportOptionalSubscript = "warning",
					reportPrivateImportUsage = "warning",
				},
			},
		},
	},
})

-- Java (jdtls)
vim.lsp.config("jdtls", {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", ".git" },
	capabilities = capabilities,
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.mockito.Mockito.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
		},
	},
})

-- TypeScript
vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	capabilities = capabilities,
	settings = {
		typescript = {
			compilerOptions = {
				target = "ES2020",
				lib = { "ES2020", "DOM", "DOM.Iterable" },
				module = "ESNext",
				moduleResolution = "node",
				allowSyntheticDefaultImports = true,
				esModuleInterop = true,
				allowJs = true,
				skipLibCheck = true,
				strict = true,
				forceConsistentCasingInFileNames = true,
				noEmit = true,
				resolveJsonModule = true,
				isolatedModules = true,
				jsx = "preserve",
				incremental = true,
			},
		},
	},
})

-- Enable all configured LSP servers
vim.lsp.enable({ "gopls", "clangd", "solargraph", "pyright", "jdtls", "ts_ls" })

-- Inlay hints if supported
if vim.lsp.inlay_hint then
	vim.lsp.inlay_hint.enable(true)
end
