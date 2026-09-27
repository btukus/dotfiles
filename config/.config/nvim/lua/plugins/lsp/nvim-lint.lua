return {
	"mfussenegger/nvim-lint",
	config = function()
		-- Require the lint module at the top to avoid multiple requires
		local lint = require("lint")

		-- Set up linters for file types
		lint.linters_by_ft = {
			yaml = { "yamllint" },
			zsh = { "shellcheck" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
		}

		-- Create autocommand for linting on InsertLeave and BufWritePost
		vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
			callback = function()
				-- Use the already required lint module to try linting
				lint.try_lint()
			end,
		})
	end,
}
