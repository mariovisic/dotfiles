-- Setup language server support with lsp-zero
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })

  PluginKeyMappings.lsp_formatting()
end)

-- Setup specific language servers (manually installed) :)

-- Typescript
require("lspconfig").tsserver.setup({})

-- Ruby
require("lspconfig").sorbet.setup({})
require("lspconfig").syntax_tree.setup({})

-- Swift
require("lspconfig").sourcekit.setup({})

-- Lua
require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {},
  },
  on_init = function(client)
    local uv = vim.uv or vim.loop
    local path = client.workspace_folders[1].name

    -- Don't do anything if there is a project local config
    if uv.fs_stat(path .. "/.luarc.json") or uv.fs_stat(path .. "/.luarc.jsonc") then
      return
    end

    -- Apply neovim specific settings
    local lua_opts = lsp_zero.nvim_lua_ls()

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, lua_opts.settings.Lua)
  end,
})

-- Setup tab autocomplete for lsp
lsp_zero.omnifunc.setup({
  tabcomplete = true,
  use_fallback = true,
  select_behavior = "insert",
})
