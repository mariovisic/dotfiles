-- When treesitter is enabled, finding matching braces with % breaks as the neovim built in regexp language parser is disabled.
-- This plugin allows the built in matchers to use treesitter. It also adds motions like g%, [%, ]%, and z%.
return { "andymass/vim-matchup" }
