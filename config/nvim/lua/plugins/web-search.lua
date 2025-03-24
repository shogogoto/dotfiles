return {
  "voldikss/vim-browser-search",
  lazy = true,
  keys = {
    { "<leader>ws", "<Plug>SearchNormal", desc = "Browser search (normal mode)" },
    { "<leader>ws", "<Plug>SearchVisual", mode = "v", desc = "Browser search (visual mode)" },
  },
  init = function()
    vim.g.browser_search_default_engine = "google"
    
    -- 利用可能な検索エンジンを設定
    vim.g.browser_search_engines = {
      google = "https://www.google.com/search?q=%s",
      github = "https://github.com/search?q=%s",
      stackoverflow = "https://stackoverflow.com/search?q=%s",
      duckduckgo = "https://duckduckgo.com/?q=%s",
    }
    
    -- ブラウザパスを指定（オプション、自動検出される場合は不要）
    -- vim.g.browser_search_browser_path = "/usr/bin/firefox"
  end,
}
