-- Set leader key to comma
vim.g.mapleader = ","
vim.cmd("set termguicolors")
-- Set runtime paths
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()

-- Source existing vimrc if it exists
local vimrc_path = vim.fn.expand("~/.vimrc")
if vim.fn.filereadable(vimrc_path) == 1 then
	vim.cmd("source " .. vimrc_path)
end

-- Plugin management with vim-plug
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- Plugin declarations
Plug("ahmedkhalf/project.nvim") -- Auto-detect project root and set cwd
Plug("akinsho/toggleterm.nvim") -- terminal helper
Plug("andymass/vim-matchup") -- better matching
Plug("catppuccin/nvim", { as = "catppuccin" }) -- a beautiful color scheme
Plug("echasnovski/mini.ai") -- better add insert etc
Plug("ellisonleao/gruvbox.nvim") -- Gruvbox: Color Scheme
Plug("Exafunction/windsurf.nvim") -- windsurf
Plug("folke/trouble.nvim") -- diagnostic helper
Plug("HiPhish/rainbow-delimiters.nvim") -- rainbow delimiters
Plug("hrsh7th/cmp-buffer") -- completions and lsp helpers
Plug("hrsh7th/cmp-cmdline") -- completions and lsp helpers
Plug("hrsh7th/cmp-nvim-lsp") -- completions and lsp helpers
Plug("hrsh7th/cmp-path") -- completions and lsp helpers
Plug("hrsh7th/cmp-vsnip") -- completions and lsp helpers
Plug("hrsh7th/nvim-cmp") -- completions and lsp helpers
Plug("hrsh7th/vim-vsnip") -- completions and lsp helpers
Plug("inkarkat/vim-AdvancedSorters") -- advanced sorting of text
Plug("inkarkat/vim-ingo-library") -- a library of useful functions for Vim
Plug("kdheepak/lazygit.nvim") -- lazygit
Plug("kevinhwang91/promise-async") -- Required dependency for nvim-ufo
Plug("kevinhwang91/nvim-ufo") -- FOLDIT
Plug("kylechui/nvim-surround") -- surround encapsulator
Plug("lervag/vimtex") -- LaTeX editing
Plug("lewis6991/gitsigns.nvim") -- text buffer Git integration
Plug("lewis6991/hover.nvim") -- hover documentation
Plug("linrongbin16/gitlinker.nvim") -- open files or get links to GitHub
Plug("majutsushi/tagbar") -- displaying tags in a sidebar
Plug("mbbill/undotree") -- Undo/Redo History Visualizer
Plug("mechatroner/rainbow_csv") -- csv highlighting
Plug("mikavilpas/yazi.nvim") -- yazi tree for nvim
Plug("mrjones2014/smart-splits.nvim") -- split navigation for use with wezterm
Plug("neovim/nvim-lspconfig") -- LSP configuration
Plug("norcalli/nvim-colorizer.lua") -- hex code color display
Plug("nvim-lua/plenary.nvim") -- Required dependency for yazi.nvim
Plug("nvim-lualine/lualine.nvim") -- better than airline
Plug("nvim-telescope/telescope.nvim") -- Fuzzy finder & LSP pickers
Plug("nvim-tree/nvim-web-devicons") -- icons for lualine
Plug("nvim-treesitter/nvim-treesitter", { ["branch"] = "main", ["do"] = ":TSUpdate" }) -- Syntax and code analysis
Plug("puremourning/vimspector") -- Debugger integration
Plug("ray-x/go.nvim") -- Go for nvim
Plug("rhysd/git-messenger.vim") -- commit history
Plug("ryanoasis/vim-devicons") -- Developer font icons
Plug("savq/melange-nvim") -- Melange: Color Scheme
Plug("serhez/bento.nvim") -- Buffer manager
Plug("stevearc/conform.nvim") -- conform formatter
Plug("tpope/vim-commentary") -- Commenting tool
Plug("tpope/vim-dispatch") -- Asynchronous execution
Plug("vague2k/vague.nvim") -- Vague: Color Scheme
Plug("vim-scripts/SpellCheck") -- Spell checking
Plug("waldnzwrld/cursor-agent.nvim") -- Cursor integration

vim.call("plug#end")

require("plugins.gruvbox")
-- Load modular plugin and core configuration
require("plugins.bento")
require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.conform")
require("plugins.cmp")
require("plugins.cursor_agent")
require("plugins.gitsigns")
require("plugins.gitlinker")
require("plugins.go")
require("plugins.hover")
require("plugins.lsp")
require("plugins.mini_ai")
require("plugins.project")
require("plugins.smart_splits")
require("plugins.surround")
require("plugins.telescope")
require("plugins.toggleterm")
require("plugins.treesitter")
require("plugins.trouble")
require("plugins.lualine")
require("plugins.ufo")
require("plugins.windsurf")
require("plugins.yazi")

-- Set default fold method to indent
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.statuscolumn =
	'%=%l%s%#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? " " : " ") : "  " }%*'
vim.opt.statusline:append("%3{v:lua.require('codeium.virtual_text').status_string()}")
vim.opt.termguicolors = true
vim.opt.listchars = "tab:▷▷⋮"
vim.wo.relativenumber = true

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

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(ev)
		vim.keymap.set("n", ";", "", { buffer = ev.buf, nowait = true, silent = true })
		vim.keymap.set("n", "<leader>m", "", { buffer = ev.buf, nowait = true, silent = true })
		vim.keymap.set("i", "<leader>m", "", { buffer = ev.buf, nowait = true, silent = true })
		vim.keymap.set("t", "<Del>", function()
			local term_chan = vim.b.terminal_job_id
			if term_chan then
				vim.api.nvim_chan_send(term_chan, "\x04")
			end
		end, { buffer = ev.buf, desc = "Forward delete in terminal" })
	end,
})

require("codeium.virtual_text").status_string()
require("codeium.virtual_text").set_statusbar_refresh(function()
	require("lualine").refresh()
end)
-- Core keymaps (non-plugin specific)
require("core.keymaps")
