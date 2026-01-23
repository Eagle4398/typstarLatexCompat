local M = {}

local config = require('typstarLatexCompat.config')
local luasnip = nil

M.setup = function(args)
    config.merge_config(args)
    local autosnippets = require('typstarLatexCompat.autosnippets')
    local drawings = require('typstarLatexCompat.drawings')

    vim.api.nvim_create_user_command('TypstarLatexCompatToggleSnippets', autosnippets.toggle_autosnippets, {})
    vim.api.nvim_create_user_command('TypstarLatexCompatSmartJump', function() M.smart_jump(1) end, {})
    vim.api.nvim_create_user_command('TypstarLatexCompatSmartJumpBack', function() M.smart_jump(-1) end, {})

    vim.api.nvim_create_user_command('TypstarLatexCompatInsertExcalidraw', drawings.insert_obsidian_excalidraw, {})
    vim.api.nvim_create_user_command('TypstarLatexCompatInsertRnote', drawings.insert_rnote, {})
    vim.api.nvim_create_user_command('TypstarLatexCompatOpenExcalidraw', drawings.open_obsidian_excalidraw, {})
    vim.api.nvim_create_user_command('TypstarLatexCompatOpenRnote', drawings.open_rnote, {})
    vim.api.nvim_create_user_command('TypstarLatexCompatOpenDrawing', drawings.open_drawing, {})

    autosnippets.setup()
end

-- source: https://github.com/lentilus/fastex.nvim
M.smart_jump = function(length, x, y, tries)
    if luasnip == nil then luasnip = require('luasnip') end
    local x2, y2 = unpack(vim.api.nvim_win_get_cursor(0))
    local tries = tries or 0

    if tries > 10 then return end
    if x == nil or y == nil then
        x, y = x2, y2
    end
    if x == x2 and y == y2 then
        luasnip.jump(length)
        vim.schedule(function() M.smart_jump(length, x, y, tries + 1) end)
    end
end

return M
