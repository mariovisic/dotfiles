-- Enable syntax highlighting
local treesitterLanguages = {
  "bash",
  "css",
  "gitcommit",
  "graphql",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "ruby",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitterLanguages,
  callback = function()
    vim.treesitter.start()
  end,
})

-- Pre-install language parsers we use often.
require("nvim-treesitter").install(treesitterLanguages)
