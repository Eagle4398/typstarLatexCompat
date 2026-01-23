local M = {}

local config = require('typstarLC.config')
local luasnip = nil

M.setup = function(args)
    config.merge_config(args)
    local autosnippets = require('typstarLC.autosnippets')
    local drawings = require('typstarLC.drawings')

    vim.api.nvim_create_user_command('TypstarToggleSnippets', autosnippets.toggle_autosnippets, {})
    vim.api.nvim_create_user_command('TypstarSmartJump', function() M.smart_jump(1) end, {})
    vim.api.nvim_create_user_command('TypstarSmartJumpBack', function() M.smart_jump(-1) end, {})

    vim.api.nvim_create_user_command('TypstarInsertExcalidraw', drawings.insert_obsidian_excalidraw, {})
    vim.api.nvim_create_user_command('TypstarInsertRnote', drawings.insert_rnote, {})
    vim.api.nvim_create_user_command('TypstarOpenExcalidraw', drawings.open_obsidian_excalidraw, {})
    vim.api.nvim_create_user_command('TypstarOpenRnote', drawings.open_rnote, {})
    vim.api.nvim_create_user_command('TypstarOpenDrawing', drawings.open_drawing, {})

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
