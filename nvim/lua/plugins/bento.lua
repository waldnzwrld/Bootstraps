require("bento").setup({
	max_open_buffers = 30,
	ui = {
		mode = "tabline",
	},
	actions = {
		delete = {
			key = "<C-x>",
			hl = "DiagnosticVirtualTextError",
			action = function(buf_id, _)
				local ui = require("bento.ui")
				local marks = require("bento").marks
				-- Find a replacement buffer from bento's tracked buffers
				local next_buf = nil
				for _, mark in ipairs(marks) do
					if mark.buf_id ~= buf_id and vim.api.nvim_buf_is_valid(mark.buf_id) then
						next_buf = mark.buf_id
						break
					end
				end
				-- Switch the buffer in any window displaying the buffer being deleted
				if next_buf then
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf_id then
							vim.api.nvim_win_set_buf(win, next_buf)
						end
					end
				end
				vim.api.nvim_buf_delete(buf_id, { force = false })
				ui.refresh_menu()
			end,
		},
	},
	highlights = {
		active = "Normal",
		current = "Bold",
	},
})
