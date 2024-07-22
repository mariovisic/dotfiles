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

-- I use ctrl+c instead of escape, but ctrl+c doesn't trigger some events which
-- are needed for LSP, let's map ctrl+c to match escape to get this behaviour
vim.keymap.set({'i', 'n', 'v'}, '<C-C>', '<esc>')

-- <leader>n opens nvim-tree
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', {
  noremap = true
})

-- Fuzzy finding files (and searching contents of files)
local telescope_spec = {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope_config = require('telescope.builtin')
    local action_state = require('telescope.actions.state')
    local state = require('telescope.state')
    local actions = require('telescope.actions')

    vim.keymap.set('n', '<C-P>', telescope_config.find_files, {})
    vim.keymap.set('n', '<C-F>', telescope_config.live_grep, {})
    vim.keymap.set('n', '<leader>fb', telescope_config.buffers, {})
    vim.keymap.set('n', '<leader>fh', telescope_config.help_tags, {})

    vim.keymap.set({'n', 'i'}, '<leader>t', function()
      local prompt_bufnr = vim.api.nvim_get_current_buf()
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local cached_pickers = state.get_global_key('cached_pickers')

      -- Check if there is an open telescope window
      if current_picker then
        -- and close it if it's open
        actions.close(prompt_bufnr)
      else
        -- check if telescope has been open before!
        if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
          -- if it hasn't then open a new fuzzy file finder
          telescope_config.find_files()
        else
          -- if it has then resume the last window (in normal mode, it wants to open in insert by default)
          telescope_config.resume()
          local key = vim.api.nvim_replace_termcodes("<C-c>", true, false, true)
          vim.api.nvim_feedkeys(key, 'n', false)
        end
      end
    end)

    local actions = require("telescope.actions")
    require("telescope").setup{
      defaults = {
        mappings = {
          -- I don't use the esc key as it's far away (I use ctrl+c instead).
          -- So remap ctrl+c inside of telescope to exit insert mode. In
          -- normal mode ctrl+c closes telescope
          i = { ["<C-c>"] = { "<esc>", type = "command" } },
          n = { ["<C-c>"] = "close", },
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
    require("nvim-tree").setup {
      sync_root_with_cwd = true,
    }
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
  'neovim/nvim-lspconfig',
  'VonHeikemen/lsp-zero.nvim',
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

-- Setup language server support with lsp-zero
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Setup specific language servers (manually installed) :)

-- Typescript
require('lspconfig').tsserver.setup({})

-- Ruby
require('lspconfig').sorbet.setup({})

-- Lua
require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {}
  },
  on_init = function(client)
    local uv = vim.uv or vim.loop
    local path = client.workspace_folders[1].name

    -- Don't do anything if there is a project local config
    if uv.fs_stat(path .. '/.luarc.json')
      or uv.fs_stat(path .. '/.luarc.jsonc')
    then
      return
    end

    -- Apply neovim specific settings
    local lua_opts = lsp_zero.nvim_lua_ls()

    client.config.settings.Lua = vim.tbl_deep_extend(
      'force',
      client.config.settings.Lua,
      lua_opts.settings.Lua
    )
  end,
})

-- Setup tab autocomplete for lsp
lsp_zero.omnifunc.setup({
  tabcomplete = true,
  use_fallback = true,
  select_behavior = 'insert',
})
