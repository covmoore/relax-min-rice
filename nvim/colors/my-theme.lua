-- my-theme.lua
--
-- Setup steps:
--   1. Install lush: restart Neovim and run :Lazy sync
--   2. Activate this theme with :colorscheme my-theme
--   3. Open this file and run :Lushify for a live preview while editing
--   4. To load on startup, add to init.lua:
--        vim.cmd.colorscheme 'my-theme'
--
-- To customize: edit the hex values in the palette (p) table below.
local lush = require 'lush'
local hsl = lush.hsl

-- Palette
local p = {
  bg = hsl '#1e1e2e',
  bg_dark = hsl '#181825',
  bg_light = hsl '#313244',
  fg = hsl '#cdd6f4',
  fg_dim = hsl '#a6adc8',
  comment = hsl '#6c7086',
  red = hsl '#f38ba8',
  orange = hsl '#fab387',
  yellow = hsl '#f9e2af',
  green = hsl '#a6e3a1',
  teal = hsl '#94e2d5',
  blue = hsl '#89b4fa',
  purple = hsl '#cba6f7',
  pink = hsl '#f5c2e7',
  selection = hsl '#45475a',
  border = hsl '#585b70',
}

local theme = lush(function(injected_functions)
  local sym = injected_functions.sym
  return {
    -- Editor
    Normal { fg = p.fg, bg = p.bg },
    NormalFloat { fg = p.fg, bg = p.bg_dark },
    NormalNC { fg = p.fg_dim, bg = p.bg },
    ColorColumn { bg = p.bg_light },
    Cursor { fg = p.bg, bg = p.fg },
    CursorLine { bg = p.bg_light },
    CursorLineNr { fg = p.yellow, gui = 'bold' },
    LineNr { fg = p.comment },
    SignColumn { fg = p.comment, bg = p.bg },
    VertSplit { fg = p.border },
    WinSeparator { fg = p.border },
    Folded { fg = p.comment, bg = p.bg_light },
    FoldColumn { fg = p.comment, bg = p.bg },

    -- Selection / Search
    Visual { bg = p.selection },
    Search { fg = p.bg, bg = p.yellow },
    IncSearch { fg = p.bg, bg = p.orange },
    CurSearch { fg = p.bg, bg = p.orange },

    -- Popups / Menus
    Pmenu { fg = p.fg, bg = p.bg_dark },
    PmenuSel { fg = p.bg, bg = p.blue },
    PmenuSbar { bg = p.bg_light },
    PmenuThumb { bg = p.border },

    -- Messages / Status
    StatusLine { fg = p.fg, bg = p.bg_dark },
    StatusLineNC { fg = p.comment, bg = p.bg_dark },
    TabLine { fg = p.comment, bg = p.bg_dark },
    TabLineSel { fg = p.fg, bg = p.bg },
    TabLineFill { bg = p.bg_dark },
    WildMenu { fg = p.bg, bg = p.blue },

    -- Diagnostics
    DiagnosticError { fg = p.red },
    DiagnosticWarn { fg = p.yellow },
    DiagnosticInfo { fg = p.blue },
    DiagnosticHint { fg = p.teal },
    DiagnosticUnderlineError { gui = 'undercurl', sp = p.red },
    DiagnosticUnderlineWarn { gui = 'undercurl', sp = p.yellow },

    -- Syntax
    Comment { fg = p.comment, gui = 'italic' },
    Constant { fg = p.orange },
    String { fg = p.green },
    Character { fg = p.green },
    Number { fg = p.orange },
    Boolean { fg = p.orange },
    Float { fg = p.orange },
    Identifier { fg = p.fg },
    Function { fg = p.blue },
    Statement { fg = p.purple },
    Keyword { fg = p.purple, gui = 'bold' },
    Conditional { fg = p.purple },
    Repeat { fg = p.purple },
    Label { fg = p.purple },
    Operator { fg = p.teal },
    Exception { fg = p.red },
    PreProc { fg = p.pink },
    Include { fg = p.pink },
    Define { fg = p.pink },
    Macro { fg = p.pink },
    Type { fg = p.yellow },
    StorageClass { fg = p.yellow },
    Structure { fg = p.yellow },
    Typedef { fg = p.yellow },
    Special { fg = p.pink },
    Underlined { gui = 'underline' },
    Error { fg = p.red },
    Todo { fg = p.bg, bg = p.yellow, gui = 'bold' },

    -- Treesitter
    sym '@variable' { fg = p.fg },
    sym '@variable.builtin' { fg = p.orange },
    sym '@variable.parameter' { fg = p.orange },
    sym '@variable.member' { fg = p.teal },
    sym '@constant' { fg = p.orange },
    sym '@string' { fg = p.green },
    sym '@string.escape' { fg = p.pink },
    sym '@number' { fg = p.orange },
    sym '@boolean' { fg = p.orange },
    sym '@function' { fg = p.blue },
    sym '@function.builtin' { fg = p.blue, gui = 'italic' },
    sym '@function.call' { fg = p.blue },
    sym '@method' { fg = p.blue },
    sym '@method.call' { fg = p.blue },
    sym '@keyword' { fg = p.purple, gui = 'bold' },
    sym '@keyword.return' { fg = p.purple },
    sym '@conditional' { fg = p.purple },
    sym '@repeat' { fg = p.purple },
    sym '@type' { fg = p.yellow },
    sym '@type.builtin' { fg = p.yellow, gui = 'italic' },
    sym '@constructor' { fg = p.teal },
    sym '@property' { fg = p.teal },
    sym '@attribute' { fg = p.yellow },
    sym '@namespace' { fg = p.blue },
    sym '@tag' { fg = p.red },
    sym '@tag.attribute' { fg = p.orange },
    sym '@tag.delimiter' { fg = p.border },
    sym '@comment' { fg = p.comment, gui = 'italic' },
    sym '@punctuation' { fg = p.fg_dim },
    sym '@operator' { fg = p.teal },

    -- LSP
    LspReferenceText { bg = p.selection },
    LspReferenceRead { bg = p.selection },
    LspReferenceWrite { bg = p.selection },

    -- Git (gitsigns)
    GitSignsAdd { fg = p.green },
    GitSignsChange { fg = p.yellow },
    GitSignsDelete { fg = p.red },
  }
end)

return theme
