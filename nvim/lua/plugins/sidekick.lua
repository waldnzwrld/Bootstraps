local haunt_sk = require("haunt.sidekick")
-- use MasonInstall copilot-language-server to install the copilot-lsp server
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
			pr = "Open a draft pull request for the current branch using the PR template. You do not need to commit or push any changes.",
			pr_desc = "Update the pull request description to match the current state of the diff.",
			pr_feedback = "Review the feedback presented against the current pr, identify the validity and likelihood of the issues presented there, then resolve the meaningful issues idendified by the feedback",
			claudio_reviewer = "Please review the changes in this branch using the claudio reviewer skill",
			parallelize = "Review the spec in {this} and identify ways in which the work can be parallelized. When you are ready use the worktrees skill to parallelize and build to the spec.",
			update_docs = "Use the documentation_sync agent to update the docs to match the changes in this branch. Work in the background.",
			update_tests = "Use the test-custodian agent to update tests to validate the cnahges in this branch. Be thorough but tidy. Do not add repetetive tests, update existing tests if that is the best option, otherwise add tests. Work in the background.",
			pr_review = "Use the pr-deep-dive skill against the current pr",
			devils_advocate = "Given {this} explain why this is a solid approach, and why it is not. Do not hold any sycophantic bias, objectively assess the code here for pros and cons. Highlight any issues as well as any benefits. ",
		},
		win = {
			split = {
				width = 0.3,
			},
		},
	},
})

vim.keymap.set({ "n", "i" }, "<Tab>", function()
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>"
	end
end, { desc = "Accept copilot nes" })

vim.keymap.set("n", "<leader>cn", function()
	require("sidekick.nes").toggle()
end, { desc = "Toggle copilot nes suggestions" })

vim.keymap.set("n", "<leader>cc", function()
	require("sidekick.cli").toggle({ name = "claude", focus = "true" })
end, { desc = "Sidekick toggle" })

vim.keymap.set("v", "<leader>cu", function()
	require("sidekick.cli").send({ name = "claude", msg = "{selection} in {this}" })
end, { desc = "Sidekick send selection" })

vim.keymap.set("n", "<leader>cu", function()
	require("sidekick.cli").send({ name = "claude", msg = "{this}" })
end, { desc = "Sidekick send file" })

vim.keymap.set({ "n", "v" }, "<leader>cp", function()
	require("sidekick.cli").prompt({ name = "claude" })
end, { silent = true, desc = "Sidekick prompt" })

vim.keymap.set("n", "<leader>cd", function()
	require("sidekick.cli").close()
end, { silent = true, desc = "Sidekick close" })
