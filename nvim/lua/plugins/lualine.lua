local function truncate(str, max)
	max = type(max) == "number" and max or 25
	if vim.fn.strchars(str) <= max then
		return str
	end
	return vim.fn.strcharpart(str, 0, max - 3) .. "…"
end

require("lualine").setup({
	options = {
		theme = "tokyonight",
	},
	sections = {
		lualine_b = {
			{
				"branch",
				fmt = function(name)
					return truncate(name:match("[^/]*$"))
				end,
			},
			"diff",
			"diagnostics",
		},
		lualine_c = {
			{
				"filename",
				path = 2,
				fmt = function(name)
					local cwd = vim.fn.getcwd()
					if name:sub(1, #cwd + 1) == cwd .. "/" then
						name = name:sub(#cwd + 2)
					end
					local segs = {}
					for seg in name:gmatch("[^/]+") do
						table.insert(segs, seg)
					end
					local n = #segs
					if n <= 2 then
						return table.concat(segs, "/")
					end
					return "‹ " .. truncate(segs[n - 1]) .. "/" .. truncate(segs[n])
				end,
			},
			{ "aerial_trunc", sep = " > ", dense = false, depth = -2, colored = true, max_symbol_width = 20 },
		},
		lualine_x = {
			function()
				return require("auto-session.lib").current_session_name(true)
			end,
		},
	},
})
