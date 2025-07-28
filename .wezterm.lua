-- Pull in the wezterm API
local wezterm = require 'wezterm'

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

-- Finally, return the configuration to wezterm:
return config
