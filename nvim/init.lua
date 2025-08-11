-- Set leader key to comma
vim.g.mapleader = ","

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
Plug("akinsho/bufferline.nvim") -- plugin for tab line at the top
Plug("catppuccin/nvim", { as = "catppuccin" }) -- a beautiful color scheme
Plug("echasnovski/mini.ai") -- better add insert etc
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
Plug("kylechui/nvim-surround") -- surround encapsulator
Plug("lervag/vimtex") -- LaTeX editing
Plug("lewis6991/gitsigns.nvim") -- text buffer Git integration
Plug("lewis6991/hover.nvim") -- hover documentation
Plug("majutsushi/tagbar") -- displaying tags in a sidebar
Plug("mbbill/undotree") -- Undo/Redo History Visualizer
Plug("mechatroner/rainbow_csv") -- csv highlighting
Plug("mikavilpas/yazi.nvim") -- yazi tree for nvim
Plug("morhetz/gruvbox") -- Gruvbox: Color Scheme
Plug("mrjones2014/smart-splits.nvim") -- split navigation for use with wezterm
Plug("neovim/nvim-lspconfig") -- LSP configuration
Plug("nvim-lua/plenary.nvim") -- Required dependency for yazi.nvim
Plug("nvim-lualine/lualine.nvim") -- better than airline
Plug("nvim-telescope/telescope.nvim") -- Fuzzy finder & LSP pickers
Plug("nvim-tree/nvim-web-devicons") -- icons for lualine
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" }) -- Syntax and code analysis
Plug("p00f/nvim-ts-rainbow") -- Colorful parenthesis
Plug("puremourning/vimspector") -- Debugger integration
Plug("ray-x/go.nvim") -- Go for nvim
Plug("rhysd/git-messenger.vim") -- commit history
Plug("ryanoasis/vim-devicons") -- Developer font icons
Plug("savq/melange-nvim") -- Melange: Color Scheme
Plug("stevearc/conform.nvim") -- conform formatter
Plug("tpope/vim-commentary") -- Commenting tool
Plug("tpope/vim-dispatch") -- Asynchronous execution
Plug("tpope/vim-fugitive") -- Git integration
Plug("vague2k/vague.nvim") -- Vague: Color Scheme
Plug("vim-scripts/SpellCheck") -- Spell checking

vim.call("plug#end")

-- Load modular plugin and core configuration
require("plugins.bufferline")
require("plugins.colorscheme")
require("plugins.conform")
require("plugins.cmp")
require("plugins.gitsigns")
require("plugins.go")
require("plugins.hover")
require("plugins.lsp")
require("plugins.lualine")
require("plugins.mini_ai")
require("plugins.project")
require("plugins.smart_splits")
require("plugins.surround")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.yazi")

-- Core keymaps (non-plugin specific)
require("core.keymaps")
