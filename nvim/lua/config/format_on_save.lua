local filter_formatters = function(client)
  if client.name == "null-ls" then
    return true
  elseif client.name == "syntax_tree" then
    vim.notify("Formatting with syntax_tree")
    return true
  else
    return false
  end
end

-- Install the hook that does the formatting.
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    vim.lsp.buf.format({ filter = filter_formatters })
  end,
})
