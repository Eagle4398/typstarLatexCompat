local ls = require('luasnip')
local i = ls.insert_node

local helper = require('typstarLatexCompat.autosnippets')
local snip = helper.snip
local math = helper.in_math
local start_snip = helper.start_snip
local visual = helper.visual
local cap = helper.cap
local rep = require("luasnip.extras").rep

return {
    start_snip('beg', '\\begin{<>}\n<>\n<>\\end{<>} ', { i(1), visual(2, '', '\t', 1), helper.cap(1), rep(1), },
        helper.in_markup),
    start_snip('ali', '\\begin{align*}\n<>\n<>\\end{align*} ', { visual(1, '', '\t', 1), helper.cap(1), },
        helper.in_markup),
    start_snip('equ', '\\begin{equation}\n<>\n<>\\end{equation} ', { visual(1, '', '\t', 1), helper.cap(1), },
        helper.in_markup),
    snip('in', '\\in', {}, math, 1000, { wordTrig = true }),
}
