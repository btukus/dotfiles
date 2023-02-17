local cmp_status_ok, lsp = pcall(require, "lsp-zero")
if not cmp_status_ok then
  return
end
lsp.preset('recommended')

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/snippets" } })

lsp.ensure_installed({
  -- "csharp_ls",
  "jdtls",
  "kotlin_language_server",
  "pyright",
  -- "dartls",
  "cssls",
  "html",
  "tsserver",
  "angularls",
  "lua_ls",
  "bashls",
  "jsonls",
  "yamlls",
  "dockerls",
  "terraformls",
  "ansiblels",
  -- "ltex",
  "grammarly",
  "marksman",
})

lsp.setup_nvim_cmp({
  sources = {
    { name = "nvim_lsp", group_index = 2 },
    { name = "nvim_lua", group_index = 2 },
    { name = "luasnip",  group_index = 2 },
    { name = "buffer",   group_index = 2 },
    { name = "path",     group_index = 2 },
  },
})

local cmp = require('cmp')
local cmp_config = lsp.defaults.cmp_config({
  window = {
    completion = cmp.config.window.bordered()
  },
  experimental = {
    ghost_text = false,
  },
})
cmp.setup(cmp_config)


local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>lm", "<cmd>Mason<cr>", opts)
  keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

lsp.on_attach(function(client, bufnr)
  lsp_keymaps(bufnr)
end)


lsp.configure('tsserver', {
  handlers = {
    ["textDocument/definition"] = function(_, result, params)
      if result == nil or vim.tbl_isempty(result) then
        --[[ local _ = vim.lsp.log.info() and vim.lsp.log.info(params.method, 'No location found') ]]
        return nil
      end

      if vim.tbl_islist(result) then
        vim.lsp.util.jump_to_location(result[1])
        if #result > 1 then
          local isReactDTs = false
          for key, value in pairs(result) do
            if string.match(value.targetUri, '%.d.ts') then
              isReactDTs = true
              break
            end
          end
          if not isReactDTs then
            vim.fn.setqflist(vim.lsp.util.locations_to_items(result))
            vim.api.nvim_command("copen")
          end
        end
      else
        vim.lsp.util.jump_to_location(result)
      end
    end
  },
})

lsp.nvim_workspace()

lsp.setup()
