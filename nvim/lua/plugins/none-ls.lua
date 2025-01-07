-- Allow non LSPs to use the LSP interface (eg: add support for language formatters)
return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting

    null_ls.setup({
      sources = {
        formatting.prettierd.with({ disabled_filetypes = { "yaml" } }), -- format JS with prettier
        formatting.stylua, -- Format lua with stylua
      },
    })
  end,
}
