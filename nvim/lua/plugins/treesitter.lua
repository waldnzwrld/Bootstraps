-- Treesitter context + textobjects.
-- Highlighting, indent, and parser install are handled by arborist; folding by ufo.

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
	},
})

require("treesitter-context").setup({
	max_lines = 3,
	on_attach = function(buf)
		return vim.bo[buf].buftype == ""
	end,
})

local ts_select = require("nvim-treesitter-textobjects.select")

local textobjects = {
	{ "a=", "@assignment.outer", "Select outer assignment" },
	{ "i=", "@assignment.inner", "Select inner assignment" },
	{ "l=", "@assignment.lhs", "Select assignment left-hand side" },
	{ "r=", "@assignment.rhs", "Select assignment right-hand side" },
	{ "ac", "@class.outer", "Select outer class" },
	{ "ic", "@class.inner", "Select inner class" },
	{ "ai", "@conditional.outer", "Select outer conditional/block" },
	{ "ii", "@conditional.inner", "Select inner conditional/block" },
	{ "aa", "@parameter.outer", "Select outer parameter" },
	{ "ia", "@parameter.inner", "Select inner parameter" },
	{ "al", "@loop.outer", "Select outer loop" },
	{ "il", "@loop.inner", "Select inner loop" },
	{ "am", "@function.outer", "Select outer method/function" },
	{ "im", "@function.inner", "Select inner method/function" },
}

for _, obj in ipairs(textobjects) do
	local key, query, desc = obj[1], obj[2], obj[3]
	vim.keymap.set({ "x", "o" }, key, function()
		ts_select.select_textobject(query, "textobjects")
	end, { desc = desc })
end
