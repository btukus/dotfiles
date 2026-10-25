return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Require the lint module at the top to avoid multiple requires
		local lint = require("lint")

		-- Set up linters for file types
		lint.linters_by_ft = {
			yaml = { "yamllint" },
			markdown = { "markdownlint" },
			-- shellcheck cannot parse zsh; `zsh -n` checks syntax. sh/bash get shellcheck via bashls.
			zsh = { "zsh" },
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
