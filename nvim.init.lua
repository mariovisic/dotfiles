-- load legacy vim config --
-- TODO: Start moving this old config to this init file!
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

-- Use 2 spaces instead of tabs for indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.termguicolors = true

-- Use the system clipboard when yanking/pasting
vim.api.nvim_set_option("clipboard","unnamed")

--telescope for fuzzy finding files
local telescope_spec = {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope_config = require("telescope.builtin")
    vim.keymap.set('n', '<C-P>', telescope_config.find_files, {})
    vim.keymap.set('n', '<C-F>', telescope_config.live_grep, {})
    vim.keymap.set('n', '<leader>fb', telescope_config.buffers, {})
    vim.keymap.set('n', '<leader>fh', telescope_config.help_tags, {})

    local actions = require("telescope.actions")
    require("telescope").setup{
      defaults = {
        mappings = {
          i = {
            -- I don't use the esc key as it's far away (I use ctrl+c instead).
            -- So remap ctrl+c inside of telescope to exit insert mode Can
            -- still quit Telescope by changing split in normal mode
            ["<C-c>"] = { "<esc>", type = "command" }
          },
        },
      }
    }

  end,
}

-- shows the last commit message when hovering a line --
local gitblame_spec = {
  'f-person/git-blame.nvim',
  opts = {
    -- git-blame  does not let you change the color of the message, but you can
    -- changer its gropu, Float is not significant, other than the colour is a
    -- nice light brown :)
    highlight_group = 'Float'
  }
}

-- Install lazy.nvim from GitHub.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- Show indent lines
local indent_mini_spec = {
  'nvimdev/indentmini.nvim',
  config = function()
    require('indentmini').setup()
  end,
}

local tokyo_night_spec = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
}


vim.opt.rtp:prepend(lazypath)

-- Install plugins using lazy.nvim.
require("lazy").setup({
  'preservim/nerdtree', -- TODO: Lookup newer alternatives
  'powerline/powerline', -- TODO: Customize, (possibly replace with something in lua) currently shows very little info
  'mileszs/ack.vim', -- TODO: Now using telescope as a trial, remove 'ack' if no longer using it in favour of telescope
  'tpope/vim-rails',
  tokyo_night_spec,
  gitblame_spec,
  telescope_spec,
  indent_mini_spec,
})

-- Use tab for autocomplete!
vim.api.nvim_set_keymap("i", "<Tab>", "<C-n>", { noremap = true, silent = true })

vim.cmd[[colorscheme tokyonight]]
