local ls = require('luasnip')
local i = ls.insert_node

local helper = require('typstarLatexCompat.autosnippets')
local cap = helper.cap
local markup = helper.in_markup
local snip = helper.snip
local start = helper.start_snip

local indent_visual = function(idx, default) return helper.visual(idx, default or '', '\t', 1) end

local ctheorems = {
    { 'tem', 'theorem' },
    { 'pro', 'proof' },
    { 'prp', 'proposition' },
    { 'axi', 'axiom' },
    { 'cor', 'corollary' },
    { 'lem', 'lemma' },
    { 'def', 'definition' },
    { 'exa', 'example' },
    { 'rem', 'remark' },
}

local wrappings = {
    { 'ITL', '\\textit{', '}', 'abc' },
    { 'BLD', '\\textbf{', '}', 'abc' },
    { 'HIG', '\\hl{',     '}', 'abc' }, -- Requires \usepackage{soul} or similar
    { 'UND', '\\uline{', '}', 'abc' }, -- Requires ulem package (recommended)
}

local document_snippets = {}
local ctheoremsstr = '\\begin{%s}\n<>\n<>\\end{%s} <>'
local wrappingsstr = '%s<>%s'

for _, val in pairs(ctheorems) do
    local snippet = start(val[1], string.format(ctheoremsstr, val[2], val[2]), { indent_visual(1), cap(1), i(1)}, markup)
    table.insert(document_snippets, snippet)
end

for _, val in pairs(wrappings) do
    local snippet = snip(val[1], string.format(wrappingsstr, val[2], val[3]), { helper.visual(1, val[4]) }, markup)
    table.insert(document_snippets, snippet)
end

return {
    helper.start_snip('dm', '\\[\n<>\n<>\\]', { indent_visual(1), cap(1) }, markup),
    helper.start_snip_in_newl('dm', '\\[\n\t<>\n\\] <>', { helper.visual(1), i(2) }, markup, nil,
        { wordTrig = false }),
    -- not necessary in latex
    -- helper.list_snip('dm', '\n\\[\n\t<>\n\\] <>', { helper.visual(1), i(2) }, markup, 1100, { prepend = '\t' }),

    -- not functional in latex
    -- start('fla', '#flashcard(0)[<>][\n<>\n<>]', { i(1, 'flashcard'), indent_visual(2), cap(1) }, markup),
    -- start('flA', '#flashcard(0, "<>")[\n<>\n<>]', { i(1, 'flashcard'), indent_visual(2), cap(1) }, markup),
    snip('IMP', '\\(\\implies\\) ', {}, markup),
    snip('IFF', '\\(\\iff\\) ', {}, markup),
    unpack(document_snippets),
}
