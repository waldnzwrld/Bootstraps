local neotest = require("neotest")

local function read_pkg_json(root, rel_path)
	local pkg = root .. "/" .. rel_path .. "/package.json"
	local f = io.open(pkg, "r")
	if not f then
		return nil
	end
	local contents = f:read("*a")
	f:close()
	return contents
end

local function has_jest_config(root, rel_path)
	for _, ext in ipairs({ "js", "ts", "cjs", "mjs", "json" }) do
		local p = root .. "/" .. rel_path .. "/jest.config." .. ext
		local f = io.open(p, "r")
		if f then
			f:close()
			return true
		end
	end
	local contents = read_pkg_json(root, rel_path)
	return contents ~= nil and contents:find('"jest"%s*:') ~= nil
end

local jest = require("neotest-jest")({
	-- only descend into packages with a jest config (jest.config.* or "jest" key in package.json)
	filter_dir = function(name, rel_path, root)
		if name == "node_modules" then
			return false
		end
		if not read_pkg_json(root, rel_path) then
			return true
		end
		return has_jest_config(root, rel_path)
	end,
})
local vitest = require("neotest-vitest")({
	-- filter directories and only return dirs where the root dir package.json has the text "vitest"
	filter_dir = function(name, rel_path, root)
		if name == "node_modules" then
			return false
		end
		local pkg = root .. "/" .. rel_path .. "/package.json"
		local f = io.open(pkg, "r")
		if not f then
			return true
		end
		local contents = f:read("*a")
		f:close()
		return contents:find("vitest", 1, true) ~= nil
	end,
})

neotest.setup({
	adapters = {
		jest,
		vitest,
	},
})

vim.keymap.set("n", "<leader>nr", function()
	neotest.run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>nf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run all tests in current file" })

vim.keymap.set("n", "<leader>na", function()
	neotest.run.run({ suite = true })
end, { desc = "Run all tests" })

vim.keymap.set("n", "<leader>nl", function()
	neotest.run.run_last()
end, { desc = "Run last test" })

vim.keymap.set("n", "<leader>nd", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

vim.keymap.set("n", "<leader>nx", function()
	neotest.run.stop()
end, { desc = "Stop running tests" })

vim.keymap.set("n", "<leader>nn", function()
	neotest.run.attach()
end, { desc = "Attach to nearest test" })

vim.keymap.set("n", "<leader>ns", function()
	neotest.summary.toggle()
end, { desc = "Toggle summary" })

vim.keymap.set("n", "<leader>no", function()
	neotest.output.open()
end, { desc = "Show test output" })

vim.keymap.set("n", "<leader>np", function()
	neotest.output_panel.toggle()
end, { desc = "Toggle output panel" })

vim.keymap.set("n", "<leader>nw", function()
	neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "Toggle watch file" })

vim.keymap.set("n", "<leader>nc", function()
	neotest.run.run({ suite = true, env = { CI = true } })
end, { desc = "Run all tests with CI " })

vim.keymap.set("n", "<leader>nj", function()
	neotest.jump.next({ status = "failed" })
end, { desc = "Jump to next failed" })
