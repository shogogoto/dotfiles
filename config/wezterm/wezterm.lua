local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- タイピング中にマウスカーソルを隠す機能を無効化
config.hide_mouse_cursor_when_typing = false

return config
