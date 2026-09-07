--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Use fish as default shell
--config.default_prog = { '/opt/homebrew/bin/fish', '-l' }

-- Config font
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })

config.harfbuzz_features = {
  "ss02",
  "zero",
  "cv03",
  "cv04",
  "cv14",
  "cv15",
  "cv18",
  "cv19",
  "cv20"
}

config.font_size = 12
config.freetype_load_flags = 'NO_HINTING'

config.default_cursor_style = "SteadyBar"

-- Customize theme
config.color_scheme = "Catppuccin Latte"
-- config.color_scheme = "Tokyo Night Storm"

-- Customize window layout and style
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.window_frame = {
  active_titlebar_bg = '#eff1f5',
  inactive_titlebar_bg = '#eff1f5',
}
config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#575757',
  },
}
--config.window_background_opacity = 0.95
--config.macos_window_background_blur = 50

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

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#7287fd'
    local background = '#7287fd'
    local foreground = '#eff1f5'

    if tab.is_active then
      edge_background = '#8839ef'
      background = '#8839ef'
      foreground = '#eff1f5'
    elseif hover then
      background = '#8839ef'
      foreground = '#eff1f5'
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
  end
)

-- Config keybindings
local action = wezterm.action
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
    {
        key = "-",
        mods = "LEADER",
        action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "\\",
        mods = "LEADER",
        action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "c",
        mods = "LEADER",
        action = action.SpawnTab("CurrentPaneDomain"),
    },

    {
        key = "p",
        mods = "LEADER",
        action = action.ActivateTabRelative(-1),
    },
    {
        key = "n",
        mods = "LEADER",
        action = action.ActivateTabRelative(1),
    },

    -- Pane navigation
    { key = "h", mods = "LEADER", action = action.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = action.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = action.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = action.ActivatePaneDirection("Right") },

    -- Pane resizing
    { key = "H", mods = "LEADER", action = action.AdjustPaneSize({ "Left", 5 }) },
    { key = "J", mods = "LEADER", action = action.AdjustPaneSize({ "Down", 5 }) },
    { key = "K", mods = "LEADER", action = action.AdjustPaneSize({ "Up", 5 }) },
    { key = "L", mods = "LEADER", action = action.AdjustPaneSize({ "Right", 5 }) },

    -- Pane management
    { key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
    {
        key = "x",
        mods = "LEADER",
        action = action.CloseCurrentPane({ confirm = true }),
    },
    {
        key = "s",
        mods = "LEADER",
        action = action.PaneSelect({
            alphabet = "123456789",
        }),
    },

    -- Scrollback/search
    {
        key = "/",
        mods = "LEADER",
        action = action.Search("CurrentSelectionOrEmptyString"),
    },
    {
        key = "q",
        mods = "LEADER",
        action = action.QuickSelect,
    },
}

-- Overrides the default of 3500 lines
config.scrollback_lines = 20000

-- Disable audio bell
config.audible_bell = "Disabled"

-- Show when leader is active
wezterm.on("update-status", function(window, pane)
    local status = ""

    if window:leader_is_active() then
        status = " LEADER "
    end

    window:set_right_status(status)
end)

return config

