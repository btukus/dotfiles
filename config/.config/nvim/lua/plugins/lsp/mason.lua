return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
			ensure_installed = {
				"vtsls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"prismals",
				"pyright",
				"eslint",
			},
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"pylint",
					"eslint_d",
					"yamlfix",
					"shfmt",
				},
			},
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "rshkarin/mason-nvim-lint",
    opts = {
				ensure_installed = {
					"eslint_d",
					"markdownlint",
					"shellcheck",
					"yamllint",
					"jsonlint",
					"luacheck",
					"pylint",
					"tflint",
					"shellcheck",
				},

    }
  }
}
