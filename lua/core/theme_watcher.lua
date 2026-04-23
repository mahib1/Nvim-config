local M = {}

function M.setup()
    local uv = vim.uv or vim.loop
    local theme_file = vim.fn.expand("~/.config/nvim/colors/matugen.lua")
    
    local w = uv.new_fs_event()
    if not w then return end
    
    w:start(theme_file, {}, vim.schedule_wrap(function(err, filename, events)
        if err then return end
        
        -- Clear cached modules so they reload the new hex codes
        package.loaded["core.ui.colors"] = nil
        package.loaded["core.ui.statusline"] = nil
        package.loaded["core.ui.terminal"] = nil
        package.loaded["core.ui.transparency"] = nil
        package.loaded["core.ui"] = nil
        
        -- Reload the entire colorscheme
        vim.cmd("colorscheme matugen")
        
        -- Re-apply our specific UI theme rules (transparency, statusline colors, etc.)
        require("core.ui").apply_ui_theme()
        
        -- Force UI update
        vim.cmd("redrawstatus!")
        vim.cmd("redraw!")
    end))
end

return M
