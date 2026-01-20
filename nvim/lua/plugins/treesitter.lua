-- nvim-treesitter configuration (main branch - new API)
-- Add nvim-treesitter's runtime directory to runtimepath for query priority
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/plugged/nvim-treesitter/runtime")

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})
require("nvim-treesitter").install("all")

-- Enable treesitter highlighting and indentation for all filetypes with available parsers
vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable treesitter highlighting and indentation",
	callback = function(args)
		local buf = args.buf
		local max_filesize = 100 * 1024 -- 100 KB

		-- Skip large files
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
		if ok and stats and stats.size > max_filesize then
			return
		end

		-- Enable treesitter highlighting (silently fail if no parser available)
		pcall(vim.treesitter.start)
	end,
})

-- Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
