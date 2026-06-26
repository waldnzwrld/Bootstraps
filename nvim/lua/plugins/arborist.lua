require("arborist").setup({
	update_cadence = "weekly",

	-- Beyond install_popular: kulala (.http), graphql, tf.nvim (terraform/hcl).
	ensure_installed = {
		"graphql",
		"hcl",
		"http",
		"terraform",
	},

	-- Plugin UI buffers with no parser (merged with registry defaults).
	ignore = {
		"grug-far",
		"grug-far-history",
		"kulala_ui",
		"kulala_ws_input",
		"sidekick_terminal",
		"snacks_picker_list",
		"snacks_win",
		"snacks_win_backdrop",
		"snacks_win_help",
		"yazi",
	},

	disable = {
		indent = { "markdown" },
	},
})
