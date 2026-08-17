local haunt_sk = require("haunt.sidekick")
-- use MasonInstall to install copilot-language-server
-- must be enabled with vim.lsp.enable
-- then use :LspCopilotSignIn to log in
require("sidekick").setup({
	nes = {
		enabled = true,
	},
	keys = {
		buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
		files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
	},
	cli = {
		prompts = {
			haunt_all = function()
				return haunt_sk.get_locations()
			end,
			haunt_current = function()
				return haunt_sk.get_locations({ current_buffer = true })
			end,
		},
		win = {
			split = {
				width = 0.3,
			},
		},
	},
})

vim.keymap.set({ "n", "i" }, "<Tab>", function()
	-- if there is a next edit, jump to it, otherwise apply it if any
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>" -- jumped or applied
	end
end, { desc = "jump or apply nes" })

vim.keymap.set("n", "<leader>cc", function()
	require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick toggle" })

vim.keymap.set("v", "<leader>cu", function()
	require("sidekick.cli").send({ name = "claude", msg = "{selection} in {file}" })
end, { desc = "Sidekick send selection" })

vim.keymap.set("n", "<leader>cu", function()
	require("sidekick.cli").send({ name = "claude", msg = "{this}" })
end, { desc = "Sidekick send file" })

vim.keymap.set("n", "<leader>cp", function()
	require("sidekick.cli").prompt({ name = "claude" })
end, { silent = true, desc = "Sidekick prompt" })

vim.keymap.set("n", "<leader>cd", function()
	require("sidekick.cli").close()
end, { silent = true, desc = "Sidekick close" })
