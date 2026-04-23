local M = {}

M.transparency = require("core.ui.transparency")
M.statusLine = require("core.ui.statusline")

function M.apply_ui_theme()
    M.transparency.set_transparent()
    M.statusLine.setup_colors()

    M.statusLine.setup_dynamic_statusline()
    
    _G.mode_icon = M.statusLine.mode_icon
    _G.git_branch = M.statusLine.git_branch
    _G.file_type = M.statusLine.file_type
    _G.file_size = M.statusLine.file_size
end

require('core.ui.terminal')

return M

