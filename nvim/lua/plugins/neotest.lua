local neotest = require("neotest")

local go = require("neotest-golang")({
	go_test_args = { "-v", "-race", "-count=1", "-tags=integration" },
	go_list_args = { "-tags=integration" },
	dap_go_opts = {
		delve = {
			build_flags = { "-tags=integration" },
		},
	},
})

local vitest = require("neotest-vitest")({
	-- filter directories so that only dirs with a package.json containing "vitest" are selected
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
	summary = {
		open = "botright vsplit | vertical resize 80",
	},
	adapters = {
		go,
		vitest,
	},
})

vim.keymap.set("n", "<leader>nr", function()
	neotest.run.run()
end, { desc = "Neotest: run nearest" })

vim.keymap.set("n", "<leader>nf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Neotest: run file" })

vim.keymap.set("n", "<leader>na", function()
	neotest.run.run(vim.fn.getcwd())
end, { desc = "Neotest: run all (cwd)" })

vim.keymap.set("n", "<leader>nl", function()
	neotest.run.run_last()
end, { desc = "Neotest: run last" })

vim.keymap.set("n", "<leader>nd", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "Neotest: debug nearest (DAP)" })

vim.keymap.set("n", "<leader>nx", function()
	neotest.run.stop()
end, { desc = "Neotest: stop" })

vim.keymap.set("n", "<leader>nn", function()
	neotest.run.attach()
end, { desc = "Neotest: attach to running test" })

vim.keymap.set("n", "<leader>ns", function()
	neotest.summary.toggle()
end, { desc = "Neotest: toggle summary" })

vim.keymap.set("n", "<leader>no", function()
	neotest.output.open({ enter = true, auto_close = true })
end, { desc = "Neotest: show output (float)" })

vim.keymap.set("n", "<leader>np", function()
	neotest.output_panel.toggle()
end, { desc = "Neotest: toggle output panel" })

vim.keymap.set("n", "<leader>nw", function()
	neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "Neotest: toggle watch (file)" })

vim.keymap.set("n", "<leader>nj", function()
	neotest.jump.next({ status = "failed" })
end, { desc = "Neotest: jump to next failed" })

vim.keymap.set("n", "<leader>nk", function()
	neotest.jump.prev({ status = "failed" })
end, { desc = "Neotest: jump to prev failed" })
