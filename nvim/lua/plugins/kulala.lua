-- Kulala session restore persists globals; auto-session must save them too.
if not vim.o.sessionoptions:match("globals") then
	vim.o.sessionoptions = vim.o.sessionoptions .. ",globals"
end

require("kulala").setup({
	global_keymaps = true,
	global_keymaps_prefix = "<leader>R",

	ui = {
		display_mode = "split",
		split_direction = "right",
		winbar = true,
		show_icons = "on_request",
		pickers = {
			snacks = {
				layout = function()
					local has_snacks, snacks_picker = pcall(require, "snacks.picker")
					if not has_snacks then
						return {}
					end
					return vim.tbl_deep_extend("force", snacks_picker.config.layout("telescope"), {
						reverse = true,
						layout = {
							{ { win = "list" }, { height = 1, win = "input" }, box = "vertical" },
							{ win = "preview", width = 0.6 },
							box = "horizontal",
							width = 0.8,
						},
					})
				end,
			},
		},
	},

	lsp = {
		enable = true,
	},
})
