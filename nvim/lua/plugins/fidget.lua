-- Show notications and progress messages (useful for format on save and LSP messages)
return {
  "j-hui/fidget.nvim",
  opts = {
    notification = { override_vim_notify = true }, -- Messages going to vim.notify() will be displayed by fidget
  },
}
