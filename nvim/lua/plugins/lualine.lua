require("lualine").setup({
	options = {
		theme = "tokyonight",
	},
	sections = {
		lualine_c = {
			{ "filename", path = 2 },
		},
		lualine_x = {
			function()
				return require("auto-session.lib").current_session_name(true)
			end,
		},
	},
})
