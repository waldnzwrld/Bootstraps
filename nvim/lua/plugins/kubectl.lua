local kubectl = require("kubectl")

kubectl.setup()

vim.keymap.set("n", "<leader>k", function()
	kubectl.toggle()
end, { desc = "kubectl interface" })
