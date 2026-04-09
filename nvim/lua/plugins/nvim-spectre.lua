return {
  "nvim-pack/nvim-spectre",
  pin = true,
  config = function()
    require('spectre').setup({ is_block_ui_break = true })
  end,
}
