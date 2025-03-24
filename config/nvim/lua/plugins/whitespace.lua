return {
  "ntpeters/vim-better-whitespace",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.g.better_whitespace_enabled = 1 -- 空白文字のハイライトを有効にする
    vim.g.strip_whitespace_on_save = 1 -- 保存時に自動的に空白を削除する
    vim.g.strip_whitespace_confirm = 0 -- 確認なしで空白を削除する
    -- 無視するファイルタイプ
    vim.g.better_whitespace_filetypes_blacklist = {
      "diff",
      "git",
      "gitcommit",
      "unite",
      "qf",
      "help",
      "markdown",
      "fugitive",
      "TelescopePrompt",
    }
    vim.g.better_whitespace_ctermcolor = "red"
    vim.g.better_whitespace_guicolor = "#FF5555"
  end,
  keys = {
    { "<leader>ws", "<cmd>StripWhitespace<CR>", desc = "空白文字を削除" },
    { "<leader>wt", "<cmd>ToggleWhitespace<CR>", desc = "空白文字のハイライト表示を切り替え" },
  },
}
