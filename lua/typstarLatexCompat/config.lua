local M = {}

local default_config = {
    typstarLatexCompatRoot = nil, -- typstarLatexCompat installation location required to use default drawing templates (usually determined automatically)
    excalidraw = {
        assetsDir = 'assets',
        filename = 'drawing-%Y-%m-%d-%H-%M-%S',
        fileExtension = '.excalidraw.md',
        fileExtensionInserted = '.excalidraw.svg',
        uriOpenCommand = 'xdg-open', -- set depending on OS; try setting it to "obsidian" directly if you encounter problems and have it in your PATH
        templatePath = {},
    },
    rnote = {
        assetsDir = 'assets',
        -- can be modified to e.g. export full pages; default is to try to export strokes only and otherwise export the entire document
        exportCommand = 'rnote-cli export selection --no-background --no-pattern --on-conflict overwrite --output-file %s all %s || rnote-cli export doc --no-background --no-pattern --on-conflict overwrite --output-file %s %s',
        filename = 'drawing-%Y-%m-%d-%H-%M-%S',
        fileExtension = '.rnote',
        fileExtensionInserted = '.rnote.svg', -- valid rnote export type
        uriOpenCommand = 'xdg-open', -- see comment above for excalidraw
        templatePath = {},
    },
    snippets = {
        enable = true,
        add_undo_breakpoints = true,
        modules = { -- enable modules from ./snippets
            'letters',
            'math',
            'matrix',
            'markup',
            'visual',
            'latex',
        },
        exclude = {}, -- list of triggers to exclude
        visual_disable = {}, -- visual.lua: list of triggers to exclude from visual selection mode
        visual_disable_normal = {}, -- visual.lua: list of triggers to exclude from normal snippet mode
        visual_disable_postfix = {}, -- visual.lua: list of triggers to exclude from postfix snippet mode
    },
}

function M.merge_config(args)
    M.config = vim.tbl_deep_extend('force', default_config, args or {})
    M.config.typstarLatexCompatRoot = M.config.typstarLatexCompatRoot
        or debug.getinfo(1).source:match('^@(.*)/lua/typstarLatexCompat/config%.lua$')
        or '~/typstarLatexCompat'
    vim.list_extend(M.config.excalidraw.templatePath, {
        { '%.excalidraw%.md$', M.config.typstarLatexCompatRoot .. '/res/excalidraw_template.excalidraw.md' },
    })
    vim.list_extend(M.config.rnote.templatePath, {
        { '%.rnote$', M.config.typstarLatexCompatRoot .. '/res/rnote_template.rnote' },
    })
end

M.merge_config(nil)

return M
