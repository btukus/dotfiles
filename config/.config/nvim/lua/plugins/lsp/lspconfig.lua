-- Language servers use nvim-lspconfig's configs with the native vim.lsp API and start
-- per filetype. TypeScript/JavaScript is typescript-tools (lang/typescript.lua) and
-- Java is nvim-java (nvim-java.lua). bashls runs shellcheck itself for sh/bash.
local servers = { "lua_ls", "eslint", "jsonls", "yamlls", "marksman", "bashls" }

local yaml_schemas = {
	azure = "https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json",
	gitlab = "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json",
}

local function has_key(text, keys, prefix)
	for _, key in ipairs(keys) do
		if text:find("\n" .. prefix .. key .. ":") then
			return true
		end
	end
	return false
end

-- yamlls picks schemas from SchemaStore by file name (GitHub workflows, .gitlab-ci.yml,
-- azure-pipelines.yml, kustomization.yaml, compose files, ...). Kubernetes manifests and
-- Azure pipeline templates have arbitrary names, so recognise them by content. This runs
-- once per buffer on attach; a `# yaml-language-server: $schema=<url>` modeline overrides it.
local function detect_yaml_schema(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if
		name:find("/.github/", 1, true)
		or name:match("kustomization%.ya?ml$")
		or name:match("%.gitlab%-ci%.ya?ml$")
	then
		return nil
	end
	if name:find("/.gitlab/ci/", 1, true) then
		return yaml_schemas.gitlab
	end
	local text = "\n" .. table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false), "\n")
	if text:find("{{", 1, true) then
		return nil -- Helm templates are not valid YAML
	end
	if has_key(text, { "apiVersion" }, "") and has_key(text, { "kind" }, "") then
		return "kubernetes"
	end
	if
		has_key(text, { "trigger", "pr", "pool", "extends", "stages", "jobs", "steps" }, "")
		-- not `- job:`/`- template:`, which GitLab's `needs:`/`include:` use too
		and has_key(text, { "stage", "deployment", "task", "script", "bash", "pwsh", "checkout" }, "%s*%- ")
	then
		return yaml_schemas.azure
	end
	return nil
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { { "b0o/SchemaStore.nvim", version = false } },
	config = function()
		vim.lsp.config("jsonls", {
			settings = { json = { validate = { enable = true } } },
			-- The catalog is large, so require it only when the server starts. Fill the table
			-- in place: the client already holds a reference to config.settings.
			before_init = function(_, config)
				config.settings.json.schemas = require("schemastore").json.schemas()
			end,
		})

		-- yamlls (2.0+) also fetches SchemaStore and resolves Kubernetes CRDs from the
		-- datreeio catalog by default; mapping a file to "kubernetes" is what triggers both.
		vim.lsp.config("yamlls", {
			on_attach = function(client, bufnr)
				local schema = detect_yaml_schema(bufnr)
				-- yamlls globs against the percent-encoded URI, and ( ) are glob syntax.
				local name = vim.uri_from_fname(vim.api.nvim_buf_get_name(bufnr)):gsub("^file://", "")
				name = name:gsub("[%(%)]", "\\%0")
				local yaml = client.settings.yaml
				yaml.schemas = yaml.schemas or {}
				local files = yaml.schemas[schema] or {}
				if not schema or vim.tbl_contains(files, name) then
					return
				end
				table.insert(files, name)
				yaml.schemas[schema] = files
				client:notify("workspace/didChangeConfiguration", { settings = client.settings })
			end,
		})

		vim.lsp.enable(servers)
	end,
}
