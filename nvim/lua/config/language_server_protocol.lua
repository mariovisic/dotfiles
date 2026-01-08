-- Setup language server support with lsp-zero
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- ================================ --
-- Custom LSP server configurations --
-- ================================ --

-- Setup lua to be able to work on neovim config!
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

-- Enable our LSPs, we don't automatically install anything, so will need to manually install all language servers!

vim.lsp.enable({
  -- Typescript
  -- install: npm install -g typescript typescript-language-server
  "ts_ls",

  -- Ruby
  "sorbet",
  "syntax_tree",

  -- Swift
  "sourcekit",

  -- Lua
  "lua_ls",
})

-- Setup tab autocomplete for lsp
lsp_zero.omnifunc.setup({
  tabcomplete = true,
  use_fallback = true,
  select_behavior = "insert",
})
