local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local config = wezterm.config_builder()

config.keys = {
  -- Clear the scrollback and viewport, then send CTRL-L to redraw prompt
  {
    key = "k",
    mods = "CMD",
    action = act.Multiple({ act.ClearScrollback("ScrollbackAndViewport"), act.SendKey({ key = "L", mods = "CTRL" }) }),
  },
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
  { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },

  -- Scroll up and down pages with Option+Up / Option+Down
  { key = "UpArrow", mods = "OPT", action = wezterm.action.ScrollByPage(-1) },
  { key = "DownArrow", mods = "OPT", action = wezterm.action.ScrollByPage(1) },

  -- Scroll to the top and bottom with Option+Shift+Up / Option+Shift+Down
  { key = "UpArrow", mods = "OPT|SHIFT", action = wezterm.action.ScrollToTop },
  { key = "DownArrow", mods = "OPT|SHIFT", action = wezterm.action.ScrollToBottom },
}

config.enable_scroll_bar = true

config.font_size = 18

-- Use a larger scrollback size for more easily searching output!
config.scrollback_lines = 50000

-- START TAB STYLING !!!

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = "#0b0022"
  local background = "#1b1032"
  local foreground = "#808080"

  if tab.is_active then
    background = "#2b2042"
    foreground = "#c0c0c0"
  elseif hover then
    background = "#3b3052"
    foreground = "#909090"
  end

  local edge_foreground = background

  local title = tab_title(tab)

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  title = wezterm.truncate_right(title, max_width - 2)

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- END Tab Styling !!!

-- START APPEARANCE !!!

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Night Owl (Gogh)"
  else
    return "Paraiso (light) (terminal.sexy)"
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

local color_scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

config.colors = {
  -- git status uses these colors within the 256 pallete, let's update them to match our theme :)
  indexed = {
    -- Green
    [76] = color_scheme.ansi[3],
    -- Yellow
    [178] = color_scheme.ansi[4],
    -- Blue
    [39] = color_scheme.ansi[5],
    -- Red
    [196] = color_scheme.ansi[2],
  },
}

-- END APPEARANCE !!!

return config
