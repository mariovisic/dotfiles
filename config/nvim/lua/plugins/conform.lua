-- Format files on save.

-- TODO: can this go somewhere else? maybe a command config ???
vim.api.nvim_create_user_command("FormatDisable", function()
  vim.g.disable_autoformat = true
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      css = { "oxfmt" }, -- npm install -g oxfmt
      html = { "oxfmt" },
      javascript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
      json = { "oxfmt" },
      jsonc = { "oxfmt" },
      less = { "oxfmt" },
      lua = { "stylua" },
      markdown = { "oxfmt" },
      ["markdown.mdx"] = { "oxfmt" },
      ruby = { "syntax_tree" },
      scss = { "oxfmt" },
      typescript = { "oxfmt" },
      typescriptreact = { "oxfmt" },
    },
    default_format_opts = {
      lsp_format = "never",
    },
    format_on_save = function(bufnr)
      -- Disable formatting if vim global disable_autoformat is set :)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "never" }
    end,
  },
}
