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
			bulk_dependency_update = "There are multiple open dependency update pr's. Read them, merge them together into a single pr, identify potential issues and make sure the code will still run without problems and ship when all of the updates are included",
			claudio_reviewer = "Please review the changes in this branch using the claudio reviewer skill",
			devils_advocate = "Given _______ explain why this is a solid approach, and why it is not. Do not hold any sycophantic bias, objectively assess the code here for pros and cons. Highlight any issues as well as any benefits. ",
			parallelize = "Review the spec in _______ and identify ways in which the work can be parallelized. When you are ready use the worktrees skill to parallelize and build to the spec.",
			pr = "Open a draft pull request for the current branch. If there is a PR template, use it, otherwise just write an apt description. Keep things human readable. Verbosity is not desireable here. We want to stick to the facts. You do not need to commit or push any changes.",
			pr_desc = "Update the pull request description to match the current state of the diff. Keep things human readable. Verbosity is not desireable here, there is a 150 word budget and the pr will be flagged as high risk if we exceed it. We want to stick to the facts. DO: Describe the broad overall impact of the pull request. DO: Explain why the changes are being made either from our conversation, spec-dev, or shortcut story. DO NOT: Describe individual code changes, these drift as we iterate on the pr, and are always flagged as a source of failure in reviews. DO NOT: Go to great lengths describing why the changes are being made, keep it simple, link to resources instead of repeating. DO: Ask if we have verified things if you are not sure. ",
			pr_feedback = "Review the feedback presented against the current pr, identify the validity and likelihood of the issues presented there, then resolve the meaningful issues identified by the feedback",
			pr_review = "Use the pr-deep-dive skill against the current pr, note that this is not the same pr that was loaded when the session started. Check the git branch and pr before beginning.",
			regression_check = "Looking at the version updates in the current pr, identify whether or not any potential issues or regressions would be introduced if the pr merges",
			update_docs = "Use the documentation_sync agent to update the docs to match the changes in this branch. Work in the background.",
			update_tests = "Use the test-custodian agent to update tests to validate the changes in this branch. Be thorough but tidy. Do not add repetitive tests, update existing tests if that is the best option, otherwise add tests. Work in the background.",
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

vim.keymap.set("n", "<leader>cn", function()
	require("sidekick.nes").toggle()
end, { desc = "Toggle copilot nes suggestions" })

vim.keymap.set("v", "<leader>cu", function()
	require("sidekick.cli").send({ name = "claude", msg = "{selection}" })
end, { desc = "Sidekick send selection" })

vim.keymap.set("n", "<leader>cu", function()
	require("sidekick.cli").send({ name = "claude", msg = "{file}" })
end, { desc = "Sidekick send file" })

vim.keymap.set("n", "<leader>cp", function()
	require("sidekick.cli").prompt({ name = "claude" })
end, { silent = true, desc = "Sidekick prompt" })

vim.keymap.set("n", "<leader>cd", function()
	require("sidekick.cli").close()
end, { silent = true, desc = "Sidekick close" })

vim.keymap.set("t", "<C-s>", "<Nop>", { desc = "disable stash in claude" })
