-- nvim/lua/core/ui/transparency.lua
local M = {}

function M.set_transparent()
    local groups = {
        "Normal", "NormalNC", "EndOfBuffer", "NormalFloat",
        "FloatBorder", "SignColumn", "ColorColumn",
    }

    for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
    end
end

return M
