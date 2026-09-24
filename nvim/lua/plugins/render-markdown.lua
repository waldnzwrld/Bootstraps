require("render-markdown").setup({
	completions = { lsp = { enabled = true } },
})

-- requires gh extension install yusukebe/gh-markdown-preview
-- gh markdown-preview runs a foreground local server, so track its job and
-- kill it to stop the preview.
local preview_job = nil

local function preview_stop()
	if preview_job then
		vim.fn.jobstop(preview_job)
		preview_job = nil
	end
end

local function preview_open()
	preview_stop()
	local file = vim.fn.expand("%:p")
	preview_job = vim.fn.jobstart({ "gh", "markdown-preview", file }, {
		on_exit = function()
			preview_job = nil
		end,
	})
end

local function preview_toggle()
	if preview_job then
		preview_stop()
	else
		preview_open()
	end
end

vim.keymap.set("n", "<leader>po", preview_open, { desc = "Open Markdown Preview" })
vim.keymap.set("n", "<leader>pc", preview_stop, { desc = "Close Markdown Preview" })
vim.keymap.set("n", "<leader>pp", preview_toggle, { desc = "Toggle Markdown Preview" })
