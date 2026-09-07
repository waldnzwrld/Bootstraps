-- Aerial lualine component that truncates each symbol name individually while
-- preserving aerial's section-aware highlighting. Extends the upstream aerial
-- component and only intercepts name text before it is colored.
local M = require("lualine.components.aerial"):extend()

local function truncate_name(name, max)
	if vim.fn.strchars(name) <= max then
		return name
	end
	return vim.fn.strcharpart(name, 0, max - 1) .. "…"
end

function M:format_status(symbols, depth, separator, icons_enabled, colored)
	local max = self.options.max_symbol_width or 20
	local truncated = {}
	for i, symbol in ipairs(symbols) do
		local copy = vim.tbl_extend("force", {}, symbol)
		copy.name = truncate_name(symbol.name, max)
		truncated[i] = copy
	end
	return M.super.format_status(self, truncated, depth, separator, icons_enabled, colored)
end

return M
