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
						name = "Reviews",
						key = "2",
						layout = "compact",
						search = "is:pr is:open org:CartoDB review-requested:@me draft:false",
					},
					{
						name = "cloud-native",
						key = "3",
						layout = "plain",
						search = "is:pr is:open repo:CartoDB/cloud-native",
					},
				},

				bookmarks = {
					key = "S", -- default
					label = "Search", -- default
					items = {
						["Drafts"] = "is:pr is:draft author:@me",
						["Recently merged"] = "is:pr is:merged author:@me sort:updated-desc",
						["Review requested"] = "is:pr is:open org:CartoDB review-requested:@me draft:false",
					},
				},
			},
		},
	},
})
