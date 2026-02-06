local ts = vim.treesitter
local ls = require('luasnip')
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet_node
local t = ls.text_node

local helper = require('typstarLatexCompat.autosnippets')
local utils = require('typstarLatexCompat.utils')
local cfg = require('typstarLatexCompat.config').config.snippets
local math = helper.in_math
local snip = helper.snip

local snippets = {}
local visual_disable = {}
local visual_disable_normal = {}
local visual_disable_postfix = {}
utils.generate_bool_set(cfg.visual_disable, visual_disable)
utils.generate_bool_set(cfg.visual_disable_normal, visual_disable_normal)
utils.generate_bool_set(cfg.visual_disable_postfix, visual_disable_postfix)

local operations = {
    { 'vi',  '\\frac{1}',        '',                true,  true },
    { 'bb',  '\\left(',          '\\right)',        true,  false },              -- add round brackets
    { 'sq',  '\\left[',          '\\right]',        true,  false },              -- add square brackets
    { 'st',  '\\{',              '\\}',             true,  false },              -- add curly brackets
    { 'bB',  '\\left(',          '\\right)',        false, false },              -- replace with round brackets
    { 'sQ',  '\\left[',          '\\right]',        false, false },              -- replace with square brackets
    { 'BB',  '',                 '',                false, false },              -- remove brackets
    { 'ss',  '\\text',           '',                false, true },
    { 'chv', '\\left\\langle',   '\\right\\rangle', true,  false },
    { 'abs', '\\left|',          '\\right|',        true,  false },
    { 'ul',  '\\underline',      '',                true,  true },
    { 'ol',  '\\overline',       '',                true,  true },
    { 'ub',  '\\underbrace',     '',                true,  true },
    { 'ob',  '\\overbrace',      '',                true,  true },
    { 'ht',  '\\hat',            '',                true,  true },
    { 'br',  '\\bar',            '',                true,  true },
    { 'dt',  '\\dot',            '',                true,  true },
    { 'dia', '\\ddot',           '',                true,  true },
    { 'ci',  '\\mathring',       '',                true,  true },
    { 'td',  '\\tilde',          '',                true,  true },
    { 'nr',  '\\left\\|',        '\\right\\|',      true,  false },
    { 'arr', '\\overrightarrow', '',                true,  true },
    { 'vv',  '\\vec',            '',                true,  true },
    { 'rt',  '\\sqrt',           '',                true,  true },
    { 'flo', '\\left\\lfloor',   '\\right\\rfloor', true,  false },
    { 'cei', '\\left\\lceil',    '\\right\\rceil',  true,  false },
}

local ts_wrap_query_latex = ts.query.parse('latex', [[
    [
        (math_environment)
        (generic_command)
        (subscript)
        (superscript)
        (text)
        (inline_formula)
    ] @wrap
]])
local ts_group_query_latex = ts.query.parse('latex', [[
    (inline_formula) @group
]])

local process_ts_query = function(bufnr, cursor, query, root, insert1, insert2, cut_offset)
    for _, match in ipairs(utils.treesitter_iter_matches(root, query, bufnr, cursor[1], cursor[1] + 1)) do
        for _, nodes in pairs(match) do
            local start_row, start_col, end_row, end_col = utils.treesitter_match_start_end(nodes)
            if end_row == cursor[1] and end_col == cursor[2] then
                vim.schedule(function()
                    local cursor_offset = 0
                    local old_len1, new_len1 = utils.insert_text(bufnr, start_row, start_col, insert1, 0, cut_offset)
                    if start_row == cursor[1] then cursor_offset = cursor_offset + (new_len1 - old_len1) end

                    local old_len2, new_len2 = utils.insert_text(bufnr, end_row, cursor[2] + cursor_offset,
                        insert2, cut_offset, 0)
                    if end_row == cursor[1] then cursor_offset = cursor_offset + (new_len2 - old_len2) end

                    vim.api.nvim_win_set_cursor(0, { cursor[1] + 1, cursor[2] + cursor_offset })
                end)
                return true
            end
        end
    end
    return false
end

local smart_wrap = function(args, parent, old_state, expand)
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = utils.get_cursor_pos()
    local root = utils.get_treesitter_root(bufnr)

    local trigger = expand[1]
    local expand1 = expand[5] and expand[2] .. '{' or expand[2]
    local expand2 = expand[5] and '}' or expand[3]

    local keep_brackets = expand[4]

    if #parent.env.LS_SELECT_RAW > 0 then
        return s(nil, t(expand1 .. table.concat(parent.env.LS_SELECT_RAW) .. expand2))
    end

    if not keep_brackets then
        if process_ts_query(bufnr, cursor, ts_group_query_latex, root, expand[2], expand[3], 1) then
            return s(nil, t())
        end
    end

    if process_ts_query(bufnr, cursor, ts_wrap_query_latex, root, expand1, expand2, 0) then
        return s(nil, t())
    end

    -- Fallback snippet
    return s(nil, { t(expand1), i(1), t(expand2) })
end

for _, val in pairs(operations) do
    table.insert(
        snippets,
        snip(
            val[1],
            "<>",
            { d(1, smart_wrap, {}, { user_args = { val } }) },
            math,
            1000,
            { wordTrig = false, snippetType = "autosnippet" }
        )
    )
end

return {
    unpack(snippets),
}
