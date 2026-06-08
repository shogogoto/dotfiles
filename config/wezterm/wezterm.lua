local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- タイピング中にマウスカーソルを隠す機能を無効化
config.hide_mouse_cursor_when_typing = false
-- パディングをすべて0にする
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
-- config.hide_tab_bar_if_only_one_tab = true -- タブ1つの時にタブバーを隠す
config.window_decorations = "NONE" -- タイトルバー削除
-- config.enable_tab_bar = false -- 2. タブバーを有効にする (統合先として必要)
return config
