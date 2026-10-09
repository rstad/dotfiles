-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Solarized (dark) (terminal.sexy)'
local scheme_name = 'idleToes'
local scheme = wezterm.color.get_builtin_schemes()[scheme_name]
config.color_scheme = scheme_name
-- scheme.ansi[5] = "#e21212"
-- scheme.brights[5] = "#e21212"
config.colors = scheme
-- config.send_composed_key_when_left_alt_is_pressed = false
config.font_size = 14
-- config.font_size = 20

-- and finally, return the configuration to wezterm
return config
