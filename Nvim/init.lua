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
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Plugin declarations
Plug('airblade/vim-gitgutter')  -- Git diff in column
Plug('akinsho/bufferline.nvim')  -- plugin for tab line at the top
Plug('catppuccin/nvim', { as = 'catppuccin' })  -- a beautiful color scheme
Plug('dense-analysis/ale')  -- linting and fixing code
Plug('inkarkat/vim-AdvancedSorters')  -- advanced sorting of text
Plug('inkarkat/vim-ingo-library')  -- a library of useful functions for Vim
Plug('lervag/vimtex')  -- LaTeX editing
Plug('lewis6991/gitsigns.nvim')  -- text buffer Git integration
Plug('majutsushi/tagbar')  -- displaying tags in a sidebar
Plug('mbbill/undotree')  -- Undo/Redo History Visualizer
Plug('morhetz/gruvbox')  -- Gruvbox: Color Scheme
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })  -- Syntax and code analysis
Plug('p00f/nvim-ts-rainbow')  -- Colorful parenthesis
Plug('ray-x/go.nvim')  -- Go for nvim
Plug('rhysd/git-messenger.vim')  -- commit history
Plug('ryanoasis/vim-devicons')  -- Developer font icons
Plug('savq/melange-nvim')  -- Melange: Color Scheme
Plug('sheerun/vim-polyglot')  -- collection of language support
Plug('tpope/vim-commentary')  -- Commenting tool
Plug('tpope/vim-dispatch')  -- Asynchronous execution
Plug('tpope/vim-fugitive')  -- Git integration
Plug('tpope/vim-surround')  -- Bracket and paren changer
Plug('vague2k/vague.nvim')  -- Vague: Color Scheme
Plug('vim-airline/vim-airline')  -- Visual status line indicators
Plug('vim-airline/vim-airline-themes')  -- Themes for airline
Plug('vim-scripts/SpellCheck')  -- Spell checking
Plug('vim-scripts/c.vim')  -- Syntax highlighting and indentation

-- LSP plugin (required for lspconfig module)
Plug('neovim/nvim-lspconfig')  -- LSP configuration

vim.call('plug#end')

-- Plugin configurations (add after plug#end)
-- You can add plugin-specific configurations here

-- LSP Configuration (moved here after plugins are loaded)
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({})

-- TypeScript LSP configuration
lspconfig.ts_ls.setup({
    settings = {
        typescript = {
            compilerOptions = {
                target = "ES2020",
                lib = {"ES2020", "DOM", "DOM.Iterable"},
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
            }
        }
    }
})

-- Example configurations for some of your plugins:
-- Treesitter configuration
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "vim", "go", "python", "javascript", "typescript" },
    highlight = {
        enable = true,
    },
}

-- Bufferline configuration
require("bufferline").setup{}

-- Gitsigns configuration
require('gitsigns').setup()

-- Go.nvim configuration
require('go').setup()

-- Catppuccin theme configuration
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
})

-- Set colorscheme (uncomment one of these)
-- vim.cmd.colorscheme "catppuccin"
-- vim.cmd.colorscheme "gruvbox"
-- vim.cmd.colorscheme "melange"
vim.cmd.colorscheme "vague"