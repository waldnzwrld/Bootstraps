require("smart-splits").setup({
	ignored_buftypes = { "nofile", "quickfix", "prompt" },
	ignored_filetypes = { "NvimTree" },
	resize = {
		amount = 3,
		ignored_events = { "BufEnter", "WinEnter" },
	},
	move = {
		-- inside Rex, hand edge moves to Rex (its ctrl+hjkl binds pass keys back when nvim is focused)
		at_edge = function(ctx)
			if vim.env.REX_BLOCK then
				vim.system({ "rex", "focus", ctx.direction })
			else
				ctx.wrap()
			end
		end,
		same_row = false,
		float = "previous",
	},
	swap = {
		move_cursor = false,
	},
	log = {
		level = "info",
	},
})

-- resizing
vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)

-- moving between splits
vim.keymap.set({ "n", "t" }, "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set({ "n", "t" }, "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set({ "n", "t" }, "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set({ "n", "t" }, "<C-l>", require("smart-splits").move_cursor_right)
vim.keymap.set({ "n", "t" }, "<C-\\>", "<Cmd>wincmd p<CR>")

-- swapping buffers
vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

-- bottom terminal toggle: a Rex block inside Rex, else an nvim terminal split
local term_win, term_block
vim.keymap.set("n", "<leader>tt", function()
	if vim.env.REX_BLOCK then
		if term_block then
			local closed = vim.system({ "rex", "block", "close", term_block }):wait().code == 0
			term_block = nil
			if closed then
				return
			end -- block was already closed by hand, so open a new one
		end
		local res = vim.system(
			{ "rex", "split", "-b", vim.env.REX_BLOCK, "--split", "below", "--ratio", "25", "-c", vim.fn.getcwd(), "--json" },
			{ text = true }
		):wait()
		if res.code ~= 0 then
			vim.notify(res.stderr, vim.log.levels.ERROR)
			return
		end
		term_block = vim.json.decode(res.stdout).block_ids[1]
		return
	end
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		local buf = vim.api.nvim_win_get_buf(term_win)
		pcall(vim.api.nvim_win_close, term_win, true) -- E444 if it is the last window
		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
		term_win = nil
		return
	end
	vim.cmd("botright " .. math.max(1, math.floor(vim.o.lines * 0.25)) .. "split | terminal")
	term_win = vim.api.nvim_get_current_win()
end)
