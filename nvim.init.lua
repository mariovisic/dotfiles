-- load legacy vim config --
-- TODO: Start moving this old config to this init file!
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

-- Syntax settings (2 space soft-tabs)
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Use the system clipboard when yanking/pasting
vim.api.nvim_set_option("clipboard","unnamed")

-- Use tab for autocomplete!
vim.api.nvim_set_keymap("i", "<Tab>", "<C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-p>", { noremap = true, silent = true })

-- Disable netrw as it interferes with nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- <leader>n opens nvim-tree
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', {
  noremap = true
})

-- Fuzzy finding files (and searching contents of files)
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
  end
}

-- shows the last commit message when hovering a line
local gitblame_spec = {
  'f-person/git-blame.nvim',
  opts = {
    -- git-blame  does not let you change the color of the message, but you can
    -- changer its group, Float is not significant, other than the colour is a
    -- nice oranger in tokyo_night :)
    highlight_group = 'Float'
  }
}

-- Color theme
local tokyo_night_spec = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
}

-- Shows git line status in sidebar
local git_signs_spec = {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
  end,
}

-- Mini: A collection of small plugins
local mini_spec = {
  'echasnovski/mini.nvim',
  config = function()
    -- Show a status line down the bottom
    require('mini.statusline').setup()

    -- Show indentation scope for current line
    require('mini.indentscope').setup({
      draw = {
        -- Use a little delay with no animations to make it seem seemless
        delay = 30,
        animation = require('mini.indentscope').gen_animation.none(),
      },
      options = {
        indent_at_cursor = false,
      },
      symbol = '|',
    })

    -- Comment out lines with \c + vector
    require('mini.comment').setup({
      mappings = {
        comment = '<leader>c',
        comment_visual = '<leader>c',
        comment_line = '<leader>cc',
      }
    })
  end,
}

-- Highlight TODO and FIXME in comments
local todo_comments_spec = {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
}

-- Show a file tree explorer
local nvim_tree_spec = {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,
}

-- Install lazy.nvim from GitHub. (for installing plugins)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim...")
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

-- Install plugins using lazy.nvim.
require("lazy").setup({
  'tpope/vim-rails',
  git_signs_spec,
  gitblame_spec,
  mini_spec,
  nvim_tree_spec,
  telescope_spec,
  todo_comments_spec,
  tokyo_night_spec,
})

if vim.g.neovide then
  -- Enable 24-bit color :)
  vim.o.termguicolors = true
  vim.cmd[[colorscheme tokyonight]]
  -- Disable the neovide cursor animations as they're distrating
  vim.g.neovide_cursor_animation_length = 0

  -- Allow clipboard copy paste in neovide
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
end

-- Open file tree if no file specified
if vim.fn.argc(-1) == 0 then
  vim.cmd("NvimTreeOpen")
end
