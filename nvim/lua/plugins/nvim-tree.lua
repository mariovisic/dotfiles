-- Show a file tree explorer
return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      sync_root_with_cwd = true,
    })

    -- On boot: open the file tree if there is no file specified
    if vim.fn.argc(-1) == 0 then
      vim.cmd("NvimTreeOpen")
    end
  end,
}
