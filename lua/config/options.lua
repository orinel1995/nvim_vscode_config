local options = {
    number = true, --absolute number for current line
	relativenumber = true, --relative numbers for other lines
}

-- Apply all options
for k, v in pairs(options) do
	vim.opt[k] = v
end

-- ------------------------
-- Relative number toggle in Insert Mode
-- ------------------------
vim.api.nvim_create_autocmd({"InsertEnter"}, {
	callback = function()
		vim.opt.relativenumber = false
	end
})
vim.api.nvim_create_autocmd({"InsertLeave"}, {
	callback = function()
		vim.opt.relativenumber = true
	end
})

-- Diagnostics config
vim.diagnostic.config({
	signs = false,
})

