-- Set leader key to comma
vim.g.mapleader = ","
--
-- Set runtime paths
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()

-- Source existing vimrc if it exists
local vimrc_path = vim.fn.expand("~/.vimrc")
if vim.fn.filereadable(vimrc_path) == 1 then
	vim.cmd("source " .. vimrc_path)
end

-- rainbow-delimiters attaches on FileType; yazi.nvim sets ft=yazi, which maps to TS
-- lang "yazi" but vim.treesitter.get_parser returns nil for that buffer, crashing
-- lib.attach. This global MUST be set before rainbow-delimiters is added to the
-- runtimepath (below), so its plugin script sees the blacklist.
do
	local r = vim.g.rainbow_delimiters
	if type(r) ~= "table" then
		r = {}
		vim.g.rainbow_delimiters = r
	end
	r.blacklist = r.blacklist or {}
	if not vim.tbl_contains(r.blacklist, "yazi") then
		table.insert(r.blacklist, "yazi")
	end
end

-- Plugin management with vim.pack (Neovim 0.12 built-in). Declarations only;
-- per-plugin configuration lives in lua/plugins/*.lua, loaded by require("plugins").
vim.pack.add({
	-- Color scheme (active)
	{ src = "https://github.com/folke/tokyonight.nvim" }, -- Tokyo Night
	-- Color schemes (available; uncomment to use)
	-- { src = "https://github.com/jaredgorski/spacecamp" },
	-- { src = "https://github.com/bluz71/vim-moonfly-colors" },
	-- { src = "https://github.com/ellisonleao/gruvbox.nvim" },
	-- { src = "https://github.com/scottmckendry/cyberdream.nvim" },
	-- { src = "https://github.com/iagorrr/noctis-high-contrast.nvim" },
	-- { src = "https://github.com/idr4n/andromeda.nvim" },
	-- { src = "https://github.com/initsyscall/themeinitNvim" },
	-- { src = "https://github.com/voylin/godot_color_theme" },
	-- { src = "https://github.com/rebelot/kanagawa.nvim" },
	-- { src = "https://github.com/vague2k/vague.nvim" },

	{ src = "https://github.com/akinsho/toggleterm.nvim" }, -- terminal integration
	{ src = "https://github.com/Allaman/tf.nvim" }, -- terraform integration
	{ src = "https://github.com/arborist-ts/arborist.nvim" }, -- Treesitter lang installer
	{ src = "https://github.com/atiladefreitas/bloocky" }, -- Calendar integration
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" }, -- highlight color codes
	{ src = "https://github.com/brianhuster/live-preview.nvim" }, -- live preview
	{ src = "https://github.com/giuxtaposition/blink-cmp-copilot" }, -- blink copilot source
	{ src = "https://github.com/emrearmagan/atlas.nvim" }, -- Atlas PR and Issue management
	{ src = "https://github.com/folke/flash.nvim" }, -- advanced search
	{ src = "https://github.com/folke/sidekick.nvim" }, -- sidekick ai integration
	{ src = "https://github.com/folke/snacks.nvim" }, -- multiplug for nvim
	{ src = "https://github.com/folke/todo-comments.nvim" }, -- todo comments
	{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim" }, -- rainbow delimiters
	{ src = "https://github.com/igorlfs/nvim-dap-view" }, -- dap views
	{ src = "https://github.com/kevinhwang91/promise-async" }, -- dep for nvim-ufo
	{ src = "https://github.com/kevinhwang91/nvim-ufo" }, -- folding
	{ src = "https://github.com/leoluz/nvim-dap-go" }, -- Go debugging
	{ src = "https://github.com/lewis6991/gitsigns.nvim" }, -- git signs in gutter
	{ src = "https://github.com/linrongbin16/gitlinker.nvim" }, -- GitHub file links
	{ src = "https://github.com/MagicDuck/grug-far.nvim" }, -- find and replace
	{ src = "https://github.com/mason-org/mason.nvim" }, -- LSP/DAP/Linter/Formatter installer
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- LSP installer
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, -- markdown renderer
	{ src = "https://github.com/mfussenegger/nvim-dap" }, -- Debug Adapter Protocol
	{ src = "https://github.com/mfussenegger/nvim-lint" }, -- Linting framework
	{ src = "https://github.com/mikavilpas/yazi.nvim" }, -- yazi tree for nvim
	{ src = "https://github.com/mistweaverco/kulala.nvim" }, -- API tool
	{ src = "https://github.com/jake-stewart/multicursor.nvim", version = "1.0" }, -- multiple cursors
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" }, -- split navigation
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- LSP configuration
	{ src = "https://github.com/nemanjamalesija/smart-paste.nvim" }, -- smart paste
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- dep for yazi.nvim
	{ src = "https://github.com/nvim-lualine/lualine.nvim" }, -- statusline
	{ src = "https://github.com/nvim-mini/mini.nvim" }, -- Mini: minimal Lua modules
	-- { src = "https://github.com/nvim-neotest/neotest" }, -- Testing framework
	{ src = "https://github.com/nvim-neotest/nvim-nio" }, -- async io (neotest/dap)
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" }, -- context for treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" }, -- textobjects for treesitter
	{ src = "https://github.com/Owen-Dechow/videre.nvim" }, -- JSON/YAML explorer
	{ src = "https://github.com/Owen-Dechow/graph_view_yaml_parser" }, -- YAML plug
	{ src = "https://github.com/ray-x/go.nvim" }, -- Go development plugin
	{ src = "https://github.com/rcarriga/nvim-dap-ui" }, -- dap ui
	{ src = "https://github.com/rmagatti/auto-session" }, -- session management
	{ src = "https://github.com/Saghen/blink.cmp" }, -- blink completion
	{ src = "https://github.com/Saghen/blink.lib" }, -- blink cmp dependency
	{ src = "https://github.com/spacedentist/resolve.nvim" }, -- conflict resolver
	{ src = "https://github.com/sphamba/smear-cursor.nvim" }, -- make that cursor moooov
	{ src = "https://github.com/stevearc/aerial.nvim" }, -- code outline / symbol tree
	{ src = "https://github.com/stevearc/conform.nvim" }, -- conform formatter
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" }, -- dap virtual text
	{ src = "https://github.com/TheNoeTrevino/haunt.nvim" }, -- buffered comments
})

-- Familiar management commands (vim-plug had :PlugUpdate / :PlugClean)
vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all vim.pack plugins" })

vim.api.nvim_create_user_command("PackClean", function()
	local names = vim.iter(vim.pack.get())
		:filter(function(p)
			return not p.active
		end)
		:map(function(p)
			return p.spec.name
		end)
		:totable()
	if #names == 0 then
		vim.notify("PackClean: no unused plugins", vim.log.levels.INFO)
	else
		vim.pack.del(names)
	end
end, { desc = "Remove vim.pack plugins no longer declared" })

require("plugins")

-- Core keymaps (non-plugin specific)
require("core.keymaps")

vim.cmd("set termguicolors")
-- Set default fold method to indent
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.opt.termguicolors = true
vim.opt.listchars = "tab:▷▷⋮"
-- vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.spell = true

vim.api.nvim_create_autocmd("FileType", {
	desc = "Ensures tabs are used on Makefiles instead of spaces",
	callback = function(event)
		if event.match == "make" then
			vim.bo.autoindent = false
			vim.bo.expandtab = false
			vim.bo.tabstop = 4
			vim.bo.shiftwidth = 4
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "show the fucking quotes in json files",
	pattern = { "json", "jsonc" },
	callback = function()
		vim.g.indentLine_enabled = 0
	end,
})
