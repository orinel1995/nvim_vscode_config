
-- ======================================
-- VSCode Neovim compatible init.lua
-- Minimal plugin loading for conflict-free VSCode
-- Retains all your config requires
-- ======================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local vim = vim

-- ------------------------
-- Keymaps
-- ------------------------
local map = vim.keymap.set

map("i", "jk", "<Esc>", { silent = true })
map("v", "<", "<gv")
map("v", ">", ">gv")

local opts = { noremap = true, silent = true }
local modes = { "n", "v", "o" }

vim.keymap.set(modes, "j", "h", opts)  -- j = left
vim.keymap.set(modes, "k", "k", opts)  -- k = up
vim.keymap.set(modes, "l", "l", opts)  -- l = right
vim.keymap.set(modes, ",", "j", opts)  -- , = down

vim.opt.clipboard = "unnamedplus"
-- ------------------------
-- Explorer
-- ------------------------

-- Переключение на файловый менеджер (Explorer)
map('n', '<leader>e', function()
  vim.fn['VSCodeNotify']('workbench.view.explorer')
end, { silent = true })

-- Дальше пробел для предпросмотра/enter для открытия и перехода 
-- в режим редактирования

-- Переместить текущий файл в правый сплит
vim.keymap.set('n', '<leader>ml', function()
  vim.fn['VSCodeNotify']('workbench.action.moveEditorToNextGroup')
end, { silent = true })

-- Вернуть текущий файл в левый сплит (первую группу)
vim.keymap.set('n', '<leader>mj', function()
  vim.fn['VSCodeNotify']('workbench.action.moveEditorToFirstGroup')
end, { silent = true })

-- Переключение между сплитами (одинаково в любом режиме)
map({'n','v','i'}, '<C-j>', function()
  vim.fn['VSCodeNotify']('workbench.action.focusLeftGroup')
end, { silent = true })

map({'n','v','i'}, '<C-l>', function()
  vim.fn['VSCodeNotify']('workbench.action.focusRightGroup')
end, { silent = true })

-- ------------------------
-- Tabs (documents) in current split
-- ------------------------
-- Следующий открытый документ
map('n', '<leader>l', function()
  vim.fn['VSCodeNotify']('workbench.action.nextEditor')
end, { silent = true })
-- Предыдущий открытый документ
map('n', '<leader>j', function()
  vim.fn['VSCodeNotify']('workbench.action.previousEditor')
end, { silent = true })

-- ------------------------
-- Lazy.nvim bootstrap
-- ------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ------------------------
-- Plugin setup
-- ------------------------
require("lazy").setup({
	-- Core non-conflicting plugins
	{ "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup({}) end },
	{ "numToStr/Comment.nvim", config = function() require("Comment").setup({}) end },
	{ 
		"kylechui/nvim-surround", 
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					visual = "<leader>s",
					normal = "ys",
					normal_cur = "yss",
					delete = "ds",
					change = "cs",
				},
			})
		end
	},
	-- Color schemes
	{ "catppuccin/nvim", as = "catppuccin" },
	{ "ellisonleao/gruvbox.nvim", as = "gruvbox" },
	{ "uZer/pywal16.nvim", as = "pywal16" },

	-- Keep plugin requires for configs that don't conflict with VSCode UI
	{ "lewis6991/gitsigns.nvim" },          -- git
	{ "ron-rs/ron.vim" },                   -- ron syntax
	{ "MeanderingProgrammer/render-markdown.nvim" }, -- markdown rendering
	{ "numToStr/FTerm.nvim" },              -- floating terminal
	{ "nvim-treesitter/nvim-treesitter" }, -- syntax highlighting
	{ "folke/twilight.nvim" },              -- dim surrounding
})

-- ------------------------
-- Retain config requires
-- ------------------------
require("config.options")

vim.defer_fn(function()
	require("plugins.autopairs")
	require("plugins.fterm")
	require("plugins.treesitter")
	require("plugins.twilight")
end, 100)

-- Load theme last
if load_theme then
	load_theme()
end
