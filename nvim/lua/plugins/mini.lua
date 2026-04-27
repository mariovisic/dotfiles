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

    -- Adds icons which are used by mini.completion
    require("mini.icons").setup()

    -- Enable icons in the LSP autocomplete window!
    require("mini.icons").tweak_lsp_kind()

    require("mini.comment").setup({
      mappings = PluginKeyMappings.mini(),
    })

    -- Autocomplete command line
    require("mini.cmdline").setup()

    -- Autocomplete with LSP and fallback! Set a very high completion value to
    -- effectively disable autocomplete on typing instead: ctrl+n opens the
    -- autocomplete dialog!
    require("mini.completion").setup({
      delay = { completion = 9999999999, info = 0, signature = 0 },
    })
  end,
}
