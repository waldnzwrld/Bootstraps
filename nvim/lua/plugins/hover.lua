require("hover").setup({
	init = function()
		require("hover.providers.signature_help").register_signature_help_provider()
		require("hover.providers.lsp").register_lsp_provider()
		require("hover.providers.man").register_man_provider()
		require("hover.providers.dictionary").register_dictionary_provider()
		require("hover.providers.gh").register_gh_provider()
	end,
})
