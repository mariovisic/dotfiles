-- Fuzzy finding files (and searching contents of files)
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local telescope_config = require("telescope.builtin")
    local action_state = require("telescope.actions.state")
    local state = require("telescope.state")
    local actions = require("telescope.actions")

    local resume_function = function()
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
    end

    PluginKeyMappings.telescope(telescope_config, resume_function)

    telescope.setup({
      defaults = {
        mappings = PluginKeyMappings.telescope_defaults(),
      },
      pickers = {
        live_grep = {
          file_ignore_patterns = { "node_modules", ".git", ".venv" },
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
        find_files = {
          file_ignore_patterns = { "node_modules", ".git", ".venv" },
          hidden = true,
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
