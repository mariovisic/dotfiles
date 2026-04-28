-- Setup language server support with built in neovim lsp + nvim-lspconfig

-- ================================ --
-- Custom LSP server configurations --
-- ================================ --

-- Check if the current buffer is typed with sorbet containing either
-- typed: true OR typed: strict
local function typed_with_sorbet(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)

  for _, line in ipairs(lines) do
    if line:match("#%s*typed:%s*true") or line:match("#%s*typed:%s*strict") then
      return true
    end
  end

  return false
end

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

vim.lsp.config("sorbet", {
  -- Neovim built in LSP launches sorbet from the editors current directory,
  -- which can be different to the projects root diretory. Sorbet can't
  -- reference other classes when this happens and becomes useless.
  --
  -- This hack sets the current working directory for sorbet to match root_dir!
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd and client.config.name == config.name
  end,

  -- Only load sorbet for ruby files that have typing enabled!
  root_dir = function(bufnr, on_dir)
    if typed_with_sorbet(bufnr) then
      on_dir(vim.fs.root(bufnr, vim.lsp.config.sorbet.root_markers))
    end
  end,
})

vim.lsp.config("ruby_lsp", {
  cmd_env = {
    RUBY_LSP_BYPASS_TYPECHECKER = "yes",
  },

  -- This function is set in nvim-lspconfig with a bug.
  -- It only checks `cmd_cwd` and no other attributes like the name of the LSP.
  -- When this is set for only one language server for ruby then there are no issues.
  --
  -- When using sorbet + ruby-lsp together we end up re-using the sorbet client instead of ruby_lsp and vice-versa!
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd and client.config.name == config.name
  end,

  -- Only load ruby_lsp for ruby files that are not typed with sorbet!
  root_dir = function(bufnr, on_dir)
    if not typed_with_sorbet(bufnr) then
      on_dir(vim.fs.root(bufnr, vim.lsp.config.ruby_lsp.root_markers))
    end
  end,
})

-- Enable our LSPs, we don't automatically install anything, so will need to manually install all language servers!
vim.lsp.enable({
  -- Typescript
  -- install: npm install -g typescript typescript-language-server
  "ts_ls",

  -- Ruby
  "sorbet",
  "ruby_lsp", -- install: gem install ruby-lsp
  "syntax_tree",

  -- Swift
  "sourcekit",

  -- Lua
  "lua_ls",
})
