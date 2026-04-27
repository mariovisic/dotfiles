-- nvim-treesitter provides fast, fancy syntax highlighting.
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true, -- Install language parsers as we need them.

      -- Pre-install language parsers we use often.
      ensure_installed = {
        "bash",
        "css",
        "gitcommit",
        "graphql",
        "html",
        "javascript",
        "json",
        "jsonc",
        "markdown",
        "markdown_inline",
        "ruby",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      },
      highlight = { enable = true },
    })
  end,
}
