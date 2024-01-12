require("vim-options")
-- lazy lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
require("lazy").setup("plugins", opts)
vim.keymap.set("n", "<leader>n", ":Neotree <CR>", {})

require("MAHIB.core.keymaps")

-- Enable the built-in LSP
if vim.fn.has('nvim-0.5') or vim.fn.has('nvim-0.6') then
    -- Enable LSP
    vim.cmd('set nocompatible')
    vim.cmd('filetype plugin indent on')
    -- Start the language server for CSS
    vim.api.nvim_command('autocmd FileType css,lcss,lua LspStart css-languageserver')
end

