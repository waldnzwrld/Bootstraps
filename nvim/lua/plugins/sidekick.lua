local haunt_sk = require("haunt.sidekick")
local in_rex = vim.env.REX_BLOCK ~= nil

-- sidekick session backend: runs CLI tools in a native Rex block split beside nvim's block
local Rex = {}
Rex.__index = Rex

local function rex(args, opts)
	local _, out = require("sidekick.util").exec(vim.list_extend({ "rex" }, args), opts)
	return out
end

local function rex_json(args, opts)
	local out = rex(args, opts)
	return out and vim.json.decode(out, { luanil = { object = true } })
end

local function block_child(block)
	local proc = rex_json({ "block", "call", "-b", block, "process" }, { notify = false })
	return proc and proc.child
end

function Rex:start()
	local split = require("sidekick.config").cli.mux.split
	-- the block is not a child of nvim, so pin $NVIM (nvim-mcp) to this editor explicitly
	local cmd = {
		"split",
		"-b",
		vim.env.REX_BLOCK,
		"--split",
		split.vertical and "right" or "below",
		"--ratio",
		tostring(math.floor(split.size * 100)),
		"--label",
		"sidekick:" .. self.tool.name,
		"-c",
		self.cwd,
		"--json",
		"--",
		"env",
		"NVIM=" .. vim.v.servername,
	}
	-- shortcut: env=false (unset) entries are skipped, no configured tool uses them
	for key, value in pairs(self.tool.env or {}) do
		if value ~= false then
			cmd[#cmd + 1] = ("%s=%s"):format(key, tostring(value))
		end
	end
	vim.list_extend(cmd, self.tool.cmd)
	local res = rex_json(cmd)
	if res then
		self.rex_block = res.block_ids[1]
		self.rex_pid = (block_child(self.rex_block) or {}).pid
		self.id = "rex " .. self.rex_block
		self.started = true
	end
end

function Rex:attach()
	rex({ "focus", self.rex_block })
end

function Rex:is_running()
	return self.rex_pid ~= nil and vim.api.nvim_get_proc(self.rex_pid) ~= nil
end

function Rex:send(text)
	rex({ "send", "-b", self.rex_block }, { stdin = text })
end

function Rex:submit()
	rex({ "send-key", "-b", self.rex_block, "enter" })
end

function Rex:detach()
	if self:is_running() then
		rex({ "block", "close", self.rex_block }, { notify = false })
	end
end

function Rex.sessions()
	local ret = {}
	local tools = require("sidekick.config").cli.tools
	local res = rex_json({ "block", "ls", "--json" }, { notify = false })
	for _, block in ipairs(res and res.blocks or {}) do
		local tool = (block.label or ""):match("^sidekick:(.+)$")
		local child = tool and tools[tool] and block_child(block.block_id)
		if child then
			ret[#ret + 1] = {
				id = "rex " .. block.block_id,
				tool = tool,
				cwd = child.cwd,
				rex_block = block.block_id,
				rex_pid = child.pid,
			}
		end
	end
	-- sidekick detaches (and so closes) attached sessions missing here, so keep live ones a rex hiccup, rename or move hid
	local seen = {}
	for _, s in ipairs(ret) do
		seen[s.id] = true
	end
	for id, s in pairs(require("sidekick.cli.session")._attached) do
		if s.backend == "rex" and not seen[id] and s:is_running() then
			ret[#ret + 1] = { id = id, tool = s.tool.name, cwd = s.cwd, rex_block = s.rex_block, rex_pid = s.rex_pid }
		end
	end
	return ret
end

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
		tools = {
			omp = {
				cmd = { "omp" },
				is_proc = "\\<omp\\>",
				resume = { "--resume" },
				continue = { "--continue" },
				native_scroll = false,
			},
		},
		prompts = {
			haunt_all = function()
				return haunt_sk.get_locations()
			end,
			haunt_current = function()
				return haunt_sk.get_locations({ current_buffer = true })
			end,
			bulk_dependency_update = "There are multiple open dependency update pr's. Read them, merge them together into a single pr, identify potential issues and make sure the code will still run without problems and ship when all of the updates are included",
			ci = "CI is failing for this pr. Check the branch and pr before taking action as they may have changed during the conversation. Identify why CI is failing and fix it.",
			claudio_reviewer = "Please review the changes in this branch using the claudio reviewer skill. Check the branch and pr before taking action as they may have changed since during the conversation",
			devils_advocate = "Given _______ explain why this is a solid approach, and why it is not. Do not hold any sycophantic bias, objectively assess the code here for pros and cons. Highlight any issues as well as any benefits. ",
			parallelize = "Review the spec in _______ and identify ways in which the work can be parallelized. When you are ready use the worktrees skill to parallelize and build to the spec.",
			pr = "Open a draft pull request for the current branch, note this may not be the branch we were on when the chat started. If there is a PR template, use it, otherwise just write an apt description. Keep things human readable. Verbosity is not desireable here. We want to stick to the facts. You do not need to commit or push any changes.",
			pr_desc = "Update the current PR description and title to match its diff; re-check branch and PR first. Max 150 words, factual, human readable. State overall impact and why (from conversation, spec, or Shortcut story), linking sources instead of restating them. Never describe individual code changes. Mention verification only if the PR template has a section for it; ask me if unsure what was verified.",
			pr_feedback = "Review the feedback presented against the current pr, identify the validity and likelihood of the issues presented there, then resolve the meaningful issues identified by the feedback. Check the branch and pr before taking action as they may have changed since during the conversation.",
			pr_review = "Use the pr-review-queue skill against __________ .",
			regression_check = "Looking at the version updates in the current pr, identify whether or not any potential issues or regressions would be introduced if the pr merges",
			update_docs = "Use the documentation_sync agent to update the docs to match the changes in this branch. Work in the background.",
			update_tests = "Use the test-custodian agent to update tests to validate the changes in this branch. Be thorough but tidy. Do not add repetitive tests, update existing tests if that is the best option, otherwise add tests. Work in the background.",
		},
		tools = {
			omp = {
				cmd = { "bili", "omp" },
				is_proc = "\\<omp\\>",
				resume = { "--resume" },
				continue = { "--continue" },
			},
		},
		win = {
			split = {
				width = 0.3,
			},
		},
		mux = {
			enabled = in_rex,
			split = { size = 0.3 },
		},
	},
})

if in_rex then
	require("sidekick.cli.session").register("rex", Rex)
	-- sidekick validates cli.mux.backend against tmux|zellij on its next tick, so select rex after that
	vim.schedule(function()
		require("sidekick.config").cli.mux.backend = "rex"
	end)
end

vim.keymap.set({ "n", "i" }, "<Tab>", function()
	-- if there is a next edit, jump to it, otherwise apply it if any
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>" -- jumped or applied
	end
end, { desc = "jump or apply nes" })

vim.keymap.set("n", "<leader>cc", function()
	require("sidekick.cli").toggle({ name = "omp", focus = true })
end, { desc = "Sidekick toggle" })

vim.keymap.set("n", "<leader>ch", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick toggle" })

vim.keymap.set("n", "<leader>cn", function()
	require("sidekick.nes").toggle()
end, { desc = "Toggle copilot nes suggestions" })

vim.keymap.set("v", "<leader>cu", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Sidekick send selection" })

vim.keymap.set("n", "<leader>cu", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Sidekick send file" })

vim.keymap.set("n", "<leader>cp", function()
	require("sidekick.cli").prompt()
end, { silent = true, desc = "Sidekick prompt" })

vim.keymap.set("n", "<leader>cd", function()
	require("sidekick.cli").close()
end, { silent = true, desc = "Sidekick close" })

-- vim.keymap.set("t", "<C-s>", "<Nop>", { desc = "disable stash in claude" })
