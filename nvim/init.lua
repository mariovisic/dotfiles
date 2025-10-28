-- load legacy vim config --
-- TODO: Start moving this old config to this init file!
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

-- Set Neovim options before loading plugins.
require("config.options")

-- Setup Global key mappings
require("config.key_mappings")

-- Setup lazy to install and import packages
require("config.lazy_package_manager")

-- Setup Language Server Protocol (LSP) support
require("config.language_server_protocol")
