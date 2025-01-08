-- Mini: A collection of small plugins
--

return {
  "echasnovski/mini.nvim",
  config = function()
    -- Show a status line down the bottom
    require("mini.statusline").setup()

    -- Show indentation scope for current line
    require("mini.indentscope").setup({
      draw = {
        -- Use a little delay with no animations to make it seem seemless
        delay = 30,
        animation = require("mini.indentscope").gen_animation.none(),
      },
      options = {
        indent_at_cursor = false,
      },
      symbol = "|",
    })

    require("mini.comment").setup({
      mappings = PluginKeyMappings.mini(),
    })
  end,
}
