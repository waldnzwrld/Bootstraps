local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()
local lspconfig = require("lspconfig")

-- Enhanced diagnostic configuration
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings and errors inline
		source = "if_many", -- Show source if multiple sources provide diagnostics
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
		severity = { min = vim.diagnostic.severity.HINT }, -- Show all severities in sign column
	},
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
	severity_sort = true,
	update_in_insert = false, -- Don't update diagnostics while typing
})

-- Set diagnostic signs
local signs = { Error = "✗", Warn = "⚠", Hint = "💡", Info = "ℹ" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Global LSP defaults
lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
	capabilities = capabilities,
})

-- Prefer compile_commands/flags or git ancestor for root
do
	local util = require("lspconfig.util")
	local function global_root_dir(fname)
		return util.root_pattern("compile_commands.json", "compile_flags.txt")(fname)
			or util.find_git_ancestor(fname)
			or util.path.dirname(fname)
	end
	local orig_config = lspconfig.util.default_config
	lspconfig.util.default_config = vim.tbl_extend("force", orig_config, { root_dir = global_root_dir })
end

-- on_attach with helpful keymaps and notify
local function keys_on_attach(_, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	local k = vim.keymap.set
	for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		local root = client.config.root_dir or "unknown"
		vim.notify(string.format("LSP %s attached, root: %s", client.name, root), vim.log.levels.INFO)
	end

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

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
	on_attach = keys_on_attach,
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

-- gopls
lspconfig.gopls.setup({
	cmd = { os.getenv("HOME") .. "/.go/bin/gopls" },
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern("go.work", "go.mod")(fname)
			or util.find_git_ancestor(fname)
			or util.path.dirname(fname)
	end,
	settings = {
		gopls = {
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			gofumpt = true, -- Use gofumpt for more strict formatting
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				useany = true,
				nilness = true,
				unusedvariable = true,
				shadow = true,
			},
			codelenses = {
				gc_details = true, -- Show garbage collector details
				generate = true, -- Show code generation options
				regenerate_cgo = true, -- Regenerate cgo
				test = true, -- Show test/benchmark options
				tidy = true, -- Show go mod tidy option
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
lspconfig.clangd.setup({
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--offset-encoding=utf-16",
		"--header-insertion=iwyu", -- Include what you use
		"--suggest-missing-includes",
		"--all-scopes-completion",
		"--cross-file-rename",
		"--enable-config", -- Enable .clangd config files
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern("compile_commands.json", "compile_flags.txt")(fname)
			or util.find_git_ancestor(fname)
			or util.path.dirname(fname)
	end,
	on_new_config = function(new_config, root_dir)
		local util = require("lspconfig.util")
		local uv = vim.loop
		local function exists(p)
			return p and uv.fs_stat(p) ~= nil
		end
		local ccdir = util.search_ancestors(root_dir, function(path)
			if exists(path .. "/compile_commands.json") then
				return path
			end
			if exists(path .. "/build/compile_commands.json") then
				return path .. "/build"
			end
		end)
		if not ccdir and exists(root_dir .. "/Makefile") then
			vim.fn.jobstart({ "which", "bear" }, {
				on_exit = function(_, code)
					if code == 0 then
						vim.fn.jobstart({ "bear", "--", "make", "clean" }, {
							cwd = root_dir,
							on_exit = function(_, clean_code)
								if clean_code == 0 then
									vim.fn.jobstart({ "bear", "--", "make" }, {
										cwd = root_dir,
										on_exit = function(_, make_code)
											if make_code == 0 and exists(root_dir .. "/compile_commands.json") then
												vim.notify(
													"Generated compile_commands.json from Makefile",
													vim.log.levels.INFO
												)
												vim.cmd("LspRestart")
											end
										end,
									})
								end
							end,
						})
					else
						vim.notify(
							"Install 'bear' to generate compile_commands.json from Makefile: brew install bear",
							vim.log.levels.WARN
						)
					end
				end,
			})
		end
		if ccdir then
			local cmd = new_config.cmd or { "clangd" }
			local filtered = {}
			for _, c in ipairs(cmd) do
				if not c:match("^%-%-compile%-commands%-dir=") then
					table.insert(filtered, c)
				end
			end
			table.insert(filtered, "--compile-commands-dir=" .. ccdir)
			new_config.cmd = filtered
		end
	end,
})

-- Solargraph (Ruby)
lspconfig.solargraph.setup({
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern("Gemfile", ".git")(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
	end,
	cmd = { os.getenv("HOME") .. "/.rbenv/shims/solargraph", "stdio" },
	on_attach = function(client, bufnr)
		keys_on_attach(client, bufnr)
		local root_dir = client.config.root_dir
		local solargraph_config = root_dir .. "/.solargraph.yml"
		local gemfile_path = root_dir .. "/Gemfile"
		local file_exists = vim.fn.filereadable(solargraph_config) == 1
		local gemfile_exists = vim.fn.filereadable(gemfile_path) == 1
		if not file_exists then
			local config_content = [[
include:
  - "**/*.rb"
exclude:
  - spec/**/*
  - test/**/*
  - vendor/**/*
  - ".bundle/**/*"
reporters:
  - rubocop
  - typecheck
require: []
domains: []
max_files: 5000
useBundler: true
bundlerPath: bundle
checkGemVersion: true
includeGems: true
]]
			if gemfile_exists then
				local gemfile_content = vim.fn.readfile(gemfile_path)
				local gems = {}
				for _, line in ipairs(gemfile_content) do
					local gem_name = line:match("^%s*gem%s+['\"]([^'\"]+)['\"]")
					if gem_name then
						table.insert(gems, gem_name)
					end
				end
				if #gems > 0 then
					local require_section = "require:\n"
					for _, gem in ipairs(gems) do
						require_section = require_section .. "  - " .. gem .. "\n"
					end
					config_content = config_content:gsub("require: %[%]", require_section)
				end
			end
			vim.fn.writefile(vim.fn.split(config_content, "\n"), solargraph_config)
			vim.notify("Created .solargraph.yml for gem support", vim.log.levels.INFO)
		end
	end,
	on_new_config = function(new_config, root_dir)
		new_config.env = {
			BUNDLE_GEMFILE = root_dir .. "/Gemfile",
			BUNDLE_PATH = root_dir .. "/vendor/bundle",
		}
	end,
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

-- TypeScript
lspconfig.ts_ls.setup({
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern("tsconfig.json", "jsconfig.json")(fname)
			or util.find_git_ancestor(fname)
			or util.path.dirname(fname)
	end,
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

-- Inlay hints if supported
if vim.lsp.inlay_hint then
	vim.lsp.inlay_hint.enable(true, { 0 })
end
