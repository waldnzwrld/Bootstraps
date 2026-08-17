require("atlas").setup({
	ui = { listed_buffer = true },
	pulls = {
		providers = {
			github = {
				cache_ttl = 300,

				---@type AtlasGitHubViewConfig[]
				views = {
					{
						name = "My PRs",
						key = "1",
						layout = "plain",
						search = "author:@me sort:updated-desc",
					},
					{
						name = "Architexture Enterprises",
						key = "2",
						layout = "compact",
						search = "org:Architexture-Enterprises sort:updated-desc",
					},
					{
						name = "Second Line",
						key = "3",
						layout = "plain",
						search = "repo:architexture-enterprises/second-line sort:updated-desc",
					},
				},

				bookmarks = {
					key = "S", -- default
					label = "Search", -- default
					items = {
						["Drafts"] = "is:pr is:draft author:@me",
						["Recently merged"] = "is:pr is:merged author:@me sort:updated-desc",
						["Review requested"] = "is:pr is:open review-requested:@me",
					},
				},
			},
		},
	},
	issues = {
		providers = {
			github = {
				cache_ttl = 300,

				-- -@type AtlasGitHubIssuesViewConfig[]
				views = {
					{
						name = "Assigned",
						key = "1",
						layout = "plain",
						search = "assignee:@me is:open",
					},
					{
						name = "Created",
						key = "2",
						layout = "compact",
						search = "author:@me is:open",
					},
					{
						name = "Mentions",
						key = "3",
						layout = "plain",
						search = "mentions:@me is:open",
					},
				},

				bookmarks = {
					key = "S", -- default
					label = "Search", -- default
					items = {
						["Bugs"] = "is:issue is:open label:bug",
						["Recently closed"] = "is:issue is:closed author:@me sort:updated-desc",
						["Review requested"] = "is:pr is:open org:CartoDB review-requested:@me draft:false",
					},
				},
			},
		},
	},
})

vim.api.nvim_set_keymap("n", "<leader>rr", ":Atlas<CR>", { noremap = true, silent = true })
