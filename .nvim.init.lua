-- load legacy vim config --
-- TODO: Start moving this old config to this init file!
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- nvim-lspconfig configures neovim to talk to language servers.
local lspconfig_spec = {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason-lspconfig.nvim" },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- TypeScript setup
    lspconfig.eslint.setup({ capabilities = capabilities })
    lspconfig.relay_lsp.setup({ capabilities = capabilities })
    lspconfig.tsserver.setup({ capabilities = capabilities })

    -- Ruby setup
    lspconfig.rubocop.setup({ capabilities = capabilities })
    lspconfig.sorbet.setup({ capabilities = capabilities })
  end,
}

-- nvim-cmp provides completion from languages servers and snippets.
local cmp_spec = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip"
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
      }),
      mapping = cmp.mapping.preset.insert({}),
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })
  end
}

-- luasnip provides helpful snippets.
local luasnip_spec = {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp"
}

-- mason installs language servers for us.
local mason_spec = {
  "williamboman/mason.nvim",
  opts = {}
}

-- mason-lspconfig uses mason to install language servers and configures neovim
-- to use them.
local mason_lspconfig_spec = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    automatic_installation = true
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

vim.opt.rtp:prepend(lazypath)

-- Install plugins using lazy.nvim.
require("lazy").setup({
  cmp_spec,
  lspconfig_spec,
  luasnip_spec,
  mason_spec,
  mason_lspconfig_spec,
})