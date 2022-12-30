local ls = require("luasnip") --{{{
local s = ls.s --> snippet
local i = ls.i --> insert node
--[[ local t = ls.t --> text node ]]
--[[]]
--[[ local d = ls.dynamic_node ]]
--[[ local c = ls.choice_node ]]
--[[ local f = ls.function_node ]]
--[[ local sn = ls.snippet_node ]]

local fmt = require("luasnip.extras.fmt").fmt
--[[ local rep = require("luasnip.extras").rep ]]

local snippets, autosnippets = {}, {}

--[[ local file_pattern = "*" ]]

local function cs(trigger, nodes)
	local snippet = s(trigger, nodes)
	local target_table = snippets

	--[[ local pattern = file_pattern ]]
	--[[ local keymaps = {} ]]

	table.insert(target_table, snippet)
end

cs(
	"cn",
	fmt([[className={{`{}`}}]], {
		i(1, ""),
	})
)

return snippets, autosnippets
