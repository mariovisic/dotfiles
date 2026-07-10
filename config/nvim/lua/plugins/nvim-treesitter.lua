-- nvim-treesitter provides fast, fancy syntax highlighting.
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
}
