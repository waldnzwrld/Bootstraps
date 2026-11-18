vim.g.db_ui_use_nerd_fonts = 1

vim.g.dbs = {
	{
		name = "claudio-flaky-tests",
		url = "bigquery:carto-monitoring-gcp:flaky_tests",
	},
	{
		name = "claudio-environment-deltas",
		url = "bigquery:carto-monitoring-gcp:environment_deltas",
	},
	{
		name = "claudio-ci-observability",
		url = "bigquery:carto-monitoring-gcp:ci_observability",
	},
	{
		name = "claudio-monitoring",
		url = "bigquery:carto-monitoring-gcp",
	},
}

vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<CR>", { desc = "DadBod Database manager" })
