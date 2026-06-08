-- orinel nvim config

vim.g.start_time = vim.fn.reltime()

local source = debug.getinfo(1, "S").source
local init_file = source:match("^@(.+)$") or vim.fn.expand("<sfile>:p")
local config_root = vim.fn.fnamemodify(init_file, ":p:h")
vim.opt.runtimepath:prepend(config_root)
package.path = table.concat({
  config_root .. "/lua/?.lua",
  config_root .. "/lua/?/init.lua",
  package.path,
}, ";")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"

local map = vim.keymap.set

map("i", "jk", "<esc>", { silent = true })
map("v", "<", "<gv")
map("v", ">", ">gv")

local im_select_candidates = {
  "C:/im-select/im-select.exe",
  "im-select.exe",
}
if vim.env.IM_SELECT_PATH and vim.env.IM_SELECT_PATH ~= "" then
  table.insert(im_select_candidates, 1, vim.env.IM_SELECT_PATH)
end
local en_us_layout_id = "1033"

local function find_executable(candidates)
  for _, candidate in ipairs(candidates) do
    if candidate and candidate ~= "" and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
end

local function switch_to_english_layout()
  local im_select_path = find_executable(im_select_candidates)
  if not im_select_path then
    return
  end

  vim.fn.system({ im_select_path, en_us_layout_id })
end

vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
  callback = switch_to_english_layout,
})

if not vim.g.vscode then
  switch_to_english_layout()
end

if vim.g.vscode then
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
end

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
      require("nvim-surround").setup({})
      vim.keymap.set("x", "<leader>s", "<Plug>(nvim-surround-visual)", {
        desc = "Add a surrounding pair around a visual selection",
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
