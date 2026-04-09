-- Setup language server support with built in neovim lsp + nvim-lspconfig

-- ================================ --
-- Custom LSP server configurations --
-- ================================ --

-- Setup lua to be able to work on neovim config!
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {

      diagnostics = { globals = { "vim" } },
    },
  },
  on_init = function(client)
    local uv = vim.uv or vim.loop
    local path = client.workspace_folders[1].name

    -- Don't do anything if there is a project local config
    if uv.fs_stat(path .. "/.luarc.json") or uv.fs_stat(path .. "/.luarc.jsonc") then
      return
    end
  end,
})


-- Tell sorbet to look for a 'sorbet' folder to find the root of the project!
vim.lsp.config("sorbet", {
  root_markers = { "sorbet" }
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
