vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.cmd.colorscheme("matugen")


local UI = require('core.ui')

-- Run on startup
UI.apply_ui_theme()

-- Ensure it persists if you manually change colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        UI.apply_ui_theme()
    end,
})

-- options
require('core.options')

-- load keymappings
require('core.mappings').setup()

-- load QoL autocmds
require('core.autocmds')

-- load theme watcher for live reloading
require('core.theme_watcher').setup()

-- load plugins
require('plugins')
