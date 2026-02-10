-- orinel nvim config

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"

local map = vim.keymap.set

map("i", "jk", "<esc>", { silent = true })
map("v", "<", "<gv")
map("v", ">", ">gv")

map('n', '<leader>e', function()
  vim.fn['VSCodeNotify']('workbench.view.explorer')
end, { silent = true })

map('n', '<leader>ml', function()
  vim.fn['VSCodeNotify']('workbench.action.moveEditorToNextGroup')
end, { silent = true })

map('n', '<leader>mh', function()
  vim.fn['VSCodeNotify']('workbench.action.moveEditorToPreviousGroup')
end, { silent = true })

map({'n','v','i'}, '<c-h>', function()
  vim.fn['VSCodeNotify']('workbench.action.focusLeftGroup')
end, { silent = true })

map({'n','v','i'}, '<c-l>', function()
  vim.fn['VSCodeNotify']('workbench.action.focusRightGroup')
end, { silent = true })

map('n', '<leader>l', function()
  vim.fn['VSCodeNotify']('workbench.action.nextEditor')
end, { silent = true })

map('n', '<leader>h', function()
  vim.fn['VSCodeNotify']('workbench.action.previousEditor')
end, { silent = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "windwp/nvim-autopairs", event = "insertenter", config = function()
      require("nvim-autopairs").setup({})
    end
  },
  { "numtostr/comment.nvim", keys = {"gc", "gb"}, config = function()
      require("Comment").setup({})
    end
  },
  { "kylechui/nvim-surround", config = function()
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
  { "lewis6991/gitsigns.nvim" },
  { "numtostr/fterm.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "folke/twilight.nvim", event = "bufreadpost", config = function()
      require("twilight").setup({})
    end
  },
  { "stevearc/conform.nvim", cmd = { "Conform", "Format" }, ft = {"lua","python","sql","javascript","typescript","json"}, config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          sql = { "sqlformat" },
        },
        format_on_save = true,
      })
      vim.keymap.set("n", "<leader>cf", function()
        require("conform").format({ async = true })
      end, { noremap = true, silent = true })
    end
  },
})

require("config.options")

vim.defer_fn(function()
  require("plugins.autopairs")
  require("plugins.fterm")
  require("plugins.twilight")
end, 100)

require("kanagawa").setup({
  commentstyle = { italic = false },
  colors = {
    theme = { comment = "#ff9e3b" },
  },
  overrides = function(colors)
    return {
      ["@variable"]  = { fg = colors.palette.fujiwhite },
      ["@constant"]  = { fg = colors.palette.wavered },
      ["@attribute"] = { fg = colors.palette.samuraiblue },
      ["@comment"]   = { fg = "#ff9e3b", italic = false },
    }
  end,
})

vim.cmd("colorscheme kanagawa")
