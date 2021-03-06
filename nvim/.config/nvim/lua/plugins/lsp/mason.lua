local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
	return
end

local servers = {
	-- "csharp_ls",
	"jdtls",
	"kotlin_language_server",
	"pyright",
	-- "dartls",
	"cssls",
	"html",
	"tsserver",
	"angularls",
	"sumneko_lua",
	"bashls",
	"jsonls",
	"yamlls",
	"dockerls",
	"terraformls",
	"ansiblels",
	-- "ltex",
	"grammarly",
	"marksman",
}

local settings = {
	ensure_installed = servers,
	ui = {
		keymaps = {
			toggle_server_expand = "<CR>",
			install_server = "i",
			update_server = "u",
			check_server_version = "c",
			update_all_servers = "U",
			check_outdated_servers = "C",
			uninstall_server = "X",
		},
	},

	log_level = vim.log.levels.INFO,
	-- max_concurrent_installers = 4,
	-- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" },
}

mason.setup(settings)
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("plugins.lsp.handlers").on_attach,
		capabilities = require("plugins.lsp.handlers").capabilities,
	}

	if server == "jsonls" then
		local jsonls_opts = require("plugins.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server == "yamlls" then
		local yamlls_opts = require("plugins.lsp.settings.yamlls")
		opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
	end

	if server == "sumneko_lua" then
		local sumneko_opts = require("plugins.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server == "pyright" then
		local pyright_opts = require("plugins.lsp.settings.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	if server == "jdtls" then
		goto continue
	end

	lspconfig[server].setup(opts)
	::continue::
end
