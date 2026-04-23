local M = {}

-- ============================================================================
-- STATUSLINE
-- ============================================================================
local colors = require("core.ui.colors")

function M.setup_colors()
    -- StatusLine: The active window statusline
    -- StatusLineNC: The non-active window statusline

    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.background, fg = colors.on_surface })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.background, fg = colors.surface })

    vim.api.nvim_set_hl(0, "StatusLineMode", { bg = colors.primary, fg = colors.on_primary, bold = true })
    vim.api.nvim_set_hl(0, "StatusLineBranch", { bg = colors.secondary, fg = colors.on_secondary })
    vim.api.nvim_set_hl(0, "StatusLineFile", { bg = colors.surface, fg = colors.on_surface_variant })
end

-- Git branch function with caching and Nerd Font icon
M.cached_branch = ""
M.last_check = 0

function M.git_branch()
    local now = vim.loop.now()
    if now - M.last_check > 5000 then -- Check every 5 seconds
        M.cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
        M.last_check = now
    end
    if M.cached_branch ~= "" then
        return " \u{e725} " .. M.cached_branch .. " " -- nf-dev-git_branch
    end
    return ""
end

-- File type with Nerd Font icon
function M.file_type()
    local ft = vim.bo.filetype
    local icons = {
        lua = "\u{e620} ",
        python = "\u{e73c} ",
        -- ... (keep all your other icons here)
        astro = "\u{e628} ",
    }

    if ft == "" then
        return " \u{f15b} " -- nf-fa-file_o
    end

    return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- File size with Nerd Font icon
function M.file_size()
    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size < 0 then
        return ""
    end
    local size_str
    if size < 1024 then
        size_str = size .. "B"
    elseif size < 1024 * 1024 then
        size_str = string.format("%.1fK", size / 1024)
    else
        size_str = string.format("%.1fM", size / 1024 / 1024)
    end
    return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

-- Mode indicators with Nerd Font icons
function M.mode_icon()
    local mode = vim.fn.mode()
    local modes = {
        n = " \u{f121}  NORMAL",
        i = " \u{f11c}  INSERT",
        v = " \u{f0168} VISUAL",
        V = " \u{f0168} V-LINE",
        ["\22"] = " \u{f0168} V-BLOCK",
        c = " \u{f120} COMMAND",
        s = " \u{f0c5} SELECT",
        S = " \u{f0c5} S-LINE",
        ["\19"] = " \u{f0c5} S-BLOCK",
        R = " \u{f044} REPLACE",
        r = " \u{f044} REPLACE",
        ["!"] = " \u{f489} SHELL",
        t = " \u{f120} TERMINAL",
    }
    return modes[mode] or (" \u{f059} " .. mode)
end

-- Function to change statusline based on window focus
function M.setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        callback = function()
            vim.opt_local.statusline = table.concat({
                "%#StatusLineMode#",
                "%{v:lua.mode_icon()} ",
                "%#StatusLineBranch#",
                "%{v:lua.git_branch()}",
                "%#StatusLineFile#",
                " %f %h%m%r ",
                "\u{e0b1} ",
                "%{v:lua.file_type()}",
                "\u{e0b1} ",
                "%{v:lua.file_size()}",
                "%#StatusLine#",
                "%=",
                " \u{f017} %l:%c  %P ",
            })
        end,
    })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        callback = function()
            vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
        end,
    })
end


return M
