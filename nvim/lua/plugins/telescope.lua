-- Fuzzy finding files (and searching contents of files)
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope_config = require("telescope.builtin")
    local action_state = require("telescope.actions.state")
    local state = require("telescope.state")
    local actions = require("telescope.actions")

    vim.keymap.set("n", "<C-P>", telescope_config.find_files, {})
    vim.keymap.set("n", "<C-F>", telescope_config.live_grep, {})
    vim.keymap.set("n", "<leader>fb", telescope_config.buffers, {})
    vim.keymap.set("n", "<leader>fh", telescope_config.help_tags, {})

    vim.keymap.set("n", "<leader>t", function()
      local prompt_bufnr = vim.api.nvim_get_current_buf()
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local cached_pickers = state.get_global_key("cached_pickers")

      -- Check if there is an open telescope window
      if current_picker then
        -- and close it if it's open
        actions.close(prompt_bufnr)
      else
        -- check if telescope has been open before!
        if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
          -- if it hasn't then open a new fuzzy file finder
          telescope_config.find_files()
        else
          -- if it has then resume the last window (in normal mode, it wants to open in insert by default)
          telescope_config.resume()
          local key = vim.api.nvim_replace_termcodes("<C-c>", true, false, true)
          vim.api.nvim_feedkeys(key, "n", false)
        end
      end
    end)

    require("telescope").setup({
      defaults = {
        mappings = {
          -- I don't use the esc key as it's far away (I use ctrl+c instead).
          -- So remap ctrl+c inside of telescope to exit insert mode. In
          -- normal mode ctrl+c closes telescope
          i = { ["<C-c>"] = { "<esc>", type = "command" } },
          n = { ["<C-c>"] = "close" },
        },
      },
    })
  end,
}
