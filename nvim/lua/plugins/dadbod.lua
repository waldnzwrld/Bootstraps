vim.g.db_ui_use_nerd_fonts = 1

-- Reachable only via: kubectl port-forward -n second-line-staging \
--   svc/second-line-postgres 5433:5432
vim.g.dbs = {
	{ name = "staging-postgres", url = "postgres://postgres:postgres@localhost:5433/secondline" },
}

vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "Dadbod database ui" })
