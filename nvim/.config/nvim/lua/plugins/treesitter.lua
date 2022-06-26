local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {
    -- Object Oriented
    "c",
    "c_sharp",  -- Nvim gives error that not available
    "cpp",
    "java",
    "kotlin",     -- Unable to find zip file 
    "scala",
    "python",
    "dart",
    "go",

    -- Front-end
    "css",
    "scss",
    "html",
    "javascript",
    "typescript",

    -- Scripting
    "lua",
    "vim",
    "bash",

    -- Declerative
    "yaml",
    "json",
    "hcl",
    "dockerfile",

    -- Request languages
    "graphql",

    -- Misc
    "http",
    "regex",
    "markdown",
    "latex"
    
  }, -- one of "all" or a list of languages
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
})
