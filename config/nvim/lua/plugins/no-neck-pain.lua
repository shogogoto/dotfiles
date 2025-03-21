-- https://qiita.com/ysmb-wtsg/items/a63344d5acae52d53af9
-- return {
--   "shortcuts/no-neck-pain.nvim",
--   -- version = "*",
--   config = function()
--     require("no-neck-pain").setup({
--       buffers = {
--         right = {
--           enabled = true,  -- 右側の分割画面を有効化
--           location = "center",
--         },
--         left = {
--           enabled = true,  -- 左側の分割画面を明示的に有効化
--         },
--         scratchPad = {
--           enabled = true,
--           location = "~/notes",
--         },
--         bo = {
--           filetype = "md",
--         },
--       },
--       autocmds = {
--         enableOnVimEnter = true,
--         enableOnTabEnter = true,
--         reloadOnColorSchemeChange = true,
--       },
--     })
--   end,
--   keys = {
--     { "<Leader>c", "<cmd>NoNeckPain<CR>", mode = "n", desc = "no neck pain"}, -- center zだとスペースから指遠い
--   }
-- }
return {
  "shortcuts/no-neck-pain.nvim",
  opts = {
    -- 基本設定
    width = 120,  -- 中央カラムの幅を指定
    
    -- 右側の分割画面用の設定
    mappings = {
      enabled = true,  -- キーマッピングを有効化
    },
    
    -- 右側の分割画面が中央に表示されるように設定
    buffers = {
      -- 右側のウィンドウ設定
      right = {
        enabled = true,  -- 右側のバッファを有効化
      },
      -- 中央のメインバッファに分割画面を含める
      scratchPad = {
        -- スクラッチパッドでファイルを自動的に保存
        -- enabled = true,
        -- fileName = "scratchpad",
      },
    },
    
    -- 見た目の設定
    appearance = {
      -- パディングカラムの背景色を設定
      -- Neovimのカラースキームに合わせて変更可能
      backgroundColor = "#1E1E2E", -- お使いのテーマに合わせて調整してください
      
      -- スクロールバーを非表示に
      scrolloff = {
        -- 上下の余白を調整
        padding = 10,
      },
    },
    
    -- 統合設定
    integrations = {
      -- NeoTreeと統合
      neoTree = {
        -- NeoTreeが開いている場合の処理方法
        reopen = true,
        -- NeoTreeのパディング調整
        -- padding = 4,
      },
    },
  },
  
  -- キーマッピング設定
  keys = {
    -- トグルコマンド用のキーマップ
    { "<Leader>np", "<cmd>NoNeckPain<CR>", desc = "Toggle No Neck Pain" },
    -- 幅を調整するためのキーマップ
    { "<Leader>n+", "<cmd>NoNeckPainWidthUp<CR>", desc = "Increase No Neck Pain width" },
    { "<Leader>n-", "<cmd>NoNeckPainWidthDown<CR>", desc = "Decrease No Neck Pain width" },
  },
}
