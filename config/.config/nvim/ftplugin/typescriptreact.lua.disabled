if not vim.g.vscode then
	vim.opt_local.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
	vim.opt_local.softtabstop = 4 -- Number of spaces that a <Tab> counts for while performing editing operations
	vim.opt_local.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for

	local lspconfig = require("lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")

	local function filter(arr, fn)
		if type(arr) ~= "table" then
			return arr
		end

		local filtered = {}
		for k, v in pairs(arr) do
			if fn(v, k, arr) then
				table.insert(filtered, v)
			end
		end

		return filtered
	end

	local function filterReactDTS(value)
		return string.match(value.targetUri, "%.d.ts") == nil
	end

	-- LSP server setup for TypeScript
	lspconfig.ts_ls.setup({
		capabilities = cmp_nvim_lsp.default_capabilities(),
		handlers = {
			["textDocument/definition"] = function(err, result, method, ...)
				if vim.tbl_islist(result) and #result > 1 then
					local filtered_result = filter(result, filterReactDTS)
					return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
				end

				vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
			end,
		},
	})
end
