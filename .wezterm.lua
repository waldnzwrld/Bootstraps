-- Pull in the wezterm API
local wezterm = require 'wezterm'
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Add hotkey config
require("keys").setup(config)
-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 14
-- config.color_scheme = 'Color Star (terminal.sexy)'
-- config.color_scheme = 'darkmoss (base16)'
-- config.color_scheme = 'Neon'
-- config.color_scheme = 'SeaShells'
-- config.color_scheme = 'VisiBone (terminal.sexy)'
-- config.color_scheme = 'Dotshare (terminal.sexy)'
-- config.color_scheme = 'Twilight (Gogh)'
config.color_scheme = 'SleepyHollow'
config.window_background_opacity = 0.855555
config.font = wezterm.font 'hack'

smart_splits.apply_to_config(config, {
  -- the default config is here, if you'd like to use the default keys,
  -- you can omit this configuration table parameter and just use
  -- smart_splits.apply_to_config(config)

  -- directional keys to use in order of: left, down, up, right
  direction_keys = { 'h', 'j', 'k', 'l' },
  -- if you want to use separate direction keys for move vs. resize, you
  -- can also do this:
  direction_keys = {
    move = { 'h', 'j', 'k', 'l' },
    resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
  -- log level to use: info, warn, error
  log_level = 'info',
})

-- Finally, return the configuration to wezterm:
return config
