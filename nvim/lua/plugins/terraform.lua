-- tf.nvim: registry docs, state browser, terraform validate.
-- Syntax/highlighting via arborist (terraform + hcl parsers). Not an LSP.

require("tf").setup({
	filetypes = { "terraform", "tf", "terraform-vars", "tfvars", "hcl" },
	doc = {
		default_action = "open",
	},
	state = {
		detail = {
			foldmethod = "indent",
		},
		window = {
			mode = "vsplit",
			split = { position = "botright", size = 80 },
		},
	},
})

local map = vim.keymap.set

-- Capital T prefix: ,ts = snacks treesitter, ,tf = conform format-on-save toggle
map("n", "<leader>Td", ":TerraformDoc<CR>", { desc = "Terraform doc" })
map("n", "<leader>Tc", ":TerraformDocCopy<CR>", { desc = "Terraform doc (copy URL)" })
map("n", "<leader>To", ":TerraformDocOpen<CR>", { desc = "Terraform doc (open in browser)" })
map("n", "<leader>Ts", ":TerraformState<CR>", { desc = "Terraform state viewer" })
map("n", "<leader>Tv", ":TerraformValidate<CR>", { desc = "Terraform validate" })
