local ls = require('luasnip')
local i = ls.insert_node

local helper = require('typstarLC.autosnippets')
local snip = helper.snip
local math = helper.in_math
local cap = helper.cap

return {
    snip('fa', '\\forall ', {}, math),
    snip('ex', '\\exists ', {}, math),
    snip('Sq', '\\square ', {}, math),

    -- logical chunks
    snip('fen', '\\forall \\epsilon  >> 0 ', {}, math),
    snip('fdn', '\\forall \\delta >> 0 ', {}, math),
    snip('edn', '\\exists \\delta >> 0 ', {}, math),
    snip('een', '\\exists \\epsilon >> 0 ', {}, math),

    -- boolean logic
    snip('and', '\\land ', {}, math),
    snip('or', '\\lor ', {}, math),
    snip('not', '\\neg ', {}, math),
    snip('ip', '\\implies ', {}, math),
    snip('ib', '\\impliedby ', {}, math),
    snip('iff', '\\iff ', {}, math),

    -- relations
    snip('el', '= ', {}, math),
    snip('df', '\\coloneqq ', {}, math),
    snip('lt', '<< ', {}, math),
    snip('gt', '>> ', {}, math),
    snip('le', '\\le ', {}, math),
    snip('ne', '\\neq ', {}, math),
    snip('ge', '\\ge ', {}, math),

    -- operators
    snip('mak', '\\pm ', {}, math),
    snip('oak', '\\oplus ', {}, math),
    snip('bak', '\\boxplus ', {}, math),
    snip('osk', '\\ominus ', {}, math),
    snip('bsk', '\\boxminus ', {}, math),
    snip('xx', '\\times ', {}, math),
    snip('oxx', '\\otimes ', {}, math),
    snip('bxx', '\\boxtimes ', {}, math),
    snip('ff', '\\frac{<>}{<>} <>', { i(1, 'a'), i(2, 'b'), i(3) }, math),

    -- subscript/superscript
    snip('iv', '^{-1} ', {}, math, 500, { wordTrig = false, blacklist = { 'equiv' } }),
    snip('tp', '^\\top ', {}, math, 500, { wordTrig = false }),
    snip('cmp', '^\\complement ', {}, math, 500, { wordTrig = false }),
    snip('prp', '^\\perp ', {}, math, 500, { wordTrig = false }),
    snip('sr', '^2 ', {}, math, 500, { wordTrig = false }),
    snip('cb', '^3 ', {}, math, 500, { wordTrig = false }),
    snip('jj', '_{<>} ', { i(1, 'n') }, math, 500, { wordTrig = false }),
    snip('kk', '^{<>} ', { i(1, 'n') }, math, 500, { wordTrig = false }),

    -- sets
    snip('set', '\\{<> \\mid <>\\}', { i(1), i(2) }, math),
    snip('es', '\\emptyset ', {}, math),
    snip('ses', '\\{\\emptyset\\} ', {}, math),
    snip('sp', '\\supset ', {}, math),
    snip('sb', '\\subset ', {}, math),
    snip('sep', '\\supseteq ', {}, math),
    snip('seb', '\\subseteq ', {}, math),
    snip('nn', '\\cap ', {}, math),
    snip('uu', '\\cup ', {}, math),
    snip('bnn', '\\bigcap ', {}, math),
    snip('buu', '\\bigcup ', {}, math),
    snip('swo', '\\setminus ', {}, math),
    snip('ni', '\\notin ', {}, math),

    -- misc
    snip('to', '\\to ', {}, math),
    snip('mt', '\\mapsto ', {}, math),
    snip('cp', '\\circ ', {}, math),
    snip('iso', '\\cong ', {}, math),
    snip('nab', '\\nabla ', {}, math),
    snip('ep', '\\exp(<>) ', { i(1, '1') }, math),
    snip('ccs', '\\begin{cases}\n\t<>,\n\\end{cases}', { i(1, '1') }, math),
    snip('([A-Za-z])o([A-Za-z0-9]) ', '<>(<>) ', { cap(1), cap(2) }, math, 100, {
        maxTrigLength = 4,
        blacklist = { 'bot ', 'cos ', 'cot ', 'dot ', 'log ', 'mod ', 'not ', 'top ', 'won ', 'xor ' },
    }),
    snip('(K|M|N|Q|R|S|Z)([\\dn]) ', '\\mathbb{<>}^{<>} ', { cap(1), cap(2) }, math),

    -- derivatives
    snip('dx', '\\frac{d}{d<>} ', { i(1, 'x') }, math),
    snip('ddx', '\\frac{d<>}{d<>} ', { i(1, 'f'), i(2, 'x') }, math),
    snip('DX', '\\frac{\\partial}{\\partial <>} ', { i(1, 'x') }, math),
    snip('DDX', '\\frac{\\partial <>}{\\partial <>} ', { i(1, 'f'), i(2, 'x') }, math),
    snip('part', '\\partial ', {}, math, 1600),

    -- integrals
    snip('it', '\\int ', {}, math),
    snip('int', '\\int_{<>}^{<>} ', { i(1, 'a'), i(2, 'b') }, math),
    snip('oit', '\\oint_{<>} ', { i(1, 'C') }, math),
    snip('dit', '\\int_{<>} ', { i(1, '\\Omega') }, math),

    -- sums
    snip('sm', '\\sum ', {}, math),
    snip('sum', '\\sum_{<>}^{<>} ', { i(1, 'k=1'), i(2, '\\infty') }, math),
    snip('dsm', '\\sum_{<>} ', { i(1, '\\Omega') }, math),

    -- products
    snip('prd', '\\prod ', {}, math),
    snip('prod', '\\prod_{<>}^{<>} ', { i(1, 'k=1'), i(2, 'n') }, math),

    -- limits
    snip('lm', '\\lim ', {}, math),
    snip('lim', '\\lim_{<> \\to <>} ', { i(1, 'n'), i(2, '\\infty') }, math),
    snip('lim (sup|inf)', '\\lim\\<> ', { cap(1) }, math),
    snip(
        'lim(_\\(\\s?\\w+\\s?->\\s?\\w+\\s?\\)) (sup|inf)',
        '\\lim\\<><> ',
        { cap(2), cap(1) },
        math,
        nil,
        { maxTrigLength = 25 }
    ),
}
