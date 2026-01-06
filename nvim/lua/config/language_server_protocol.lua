-- Setup language server support with lsp-zero
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- Setup specific language servers (manually installed) :)

-- Typescript
vim.lsp.enable("ts_ls")

-- Ruby
vim.lsp.enable("sorbet")
vim.lsp.enable("syntax_tree")

-- Swift
vim.lsp.enable("sourcekit")

-- Lua
vim.lsp.config("lua_ls", {
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
vim.lsp.enable("lua_ls")

-- Setup tab autocomplete for lsp
lsp_zero.omnifunc.setup({
  tabcomplete = true,
  use_fallback = true,
  select_behavior = "insert",
})
