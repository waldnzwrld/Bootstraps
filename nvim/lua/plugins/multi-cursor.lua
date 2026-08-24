-- multicursor.nvim (jake-stewart), replacing vim-visual-multi.
-- The keys below preserve the hotkeys that were set in vim.g.VM_maps:
--
--   VM "Find Under" / "Find Subword Under" = <C-d>  -> match word/selection next
--   VM "Add Cursor Up"                     = <C-u>  -> add cursor on line above
--   VM "Add Cursor Down"                   = <C-m>  -> add cursor on line below
--   VM "Add Cursor At Pos"                 = <C-a>  -> drop a cursor at position
--
-- Caveats carried over from the old mappings:
--   * <C-m> is the same keycode as <CR> (Enter) in normal mode.
--   * <C-a> shadows the built-in increment-number command in normal mode.
--   * <C-u> shadows the built-in half-page-scroll-up in normal mode.
-- These were already overridden under vim-visual-multi, so behaviour is unchanged.

local mc = require("multicursor-nvim")
mc.setup()

local set = vim.keymap.set

-- Find next/prev occurrence of the word under cursor (n) or the selection (x).
-- (VM: "Find Under" / "Find Subword Under" on <C-d>)
set({ "n", "x" }, "<C-d>", function()
	mc.matchAddCursor(1)
end, { desc = "MC: add cursor at next match" })

-- Add a cursor on the line above / below the main cursor.
-- (VM: "Add Cursor Up" <C-u> / "Add Cursor Down" <C-m>)
set({ "n", "x" }, "<C-u>", function()
	mc.lineAddCursor(-1)
end, { desc = "MC: add cursor up" })
set({ "n", "x" }, "<C-m>", function()
	mc.lineAddCursor(1)
end, { desc = "MC: add cursor down" })

-- Drop / toggle a cursor at the current position.
-- (VM: "Add Cursor At Pos" <C-a> -- press to disable cursors, move, press to add)
set({ "n", "x" }, "<C-a>", mc.toggleCursor, { desc = "MC: toggle cursor at position" })

-- Layer active only while multiple cursors exist (won't clash with normal maps):
-- <esc> re-enables disabled cursors, otherwise collapses back to one cursor.
mc.addKeymapLayer(function(layerSet)
	layerSet("n", "<esc>", function()
		if not mc.cursorsEnabled() then
			mc.enableCursors()
		else
			mc.clearCursors()
		end
	end)
end)

-- Cursor appearance (safe defaults from the plugin docs).
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { reverse = true })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorMatchPreview", { link = "Search" })
hl(0, "MultiCursorDisabledCursor", { reverse = true })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
