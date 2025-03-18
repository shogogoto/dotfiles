--画面表示の設定
local opts = {
  wrap=false,         --    ウィンドウの幅より長い行は折り返され、次の行に続けて表示
  wildmenu=true,
  list=true,
  listchars={
    tab=">.",
    trail="_",
    extends=">",
    precedes="<",
    nbsp="%",
  },
  number=true,
  -- 行番号を表示する
  cursorline=true,   -- カーソル行の背景色を変える
  -- cursorcolumn=true   -- カーソル位置のカラムの背景色を変える
  laststatus=2,   -- ステータス行を常に表示
  cmdheight=2,    -- メッセージ表示欄を2行確保
  showmatch=true,      -- 対応する括弧を強調表示
  helpheight=999, -- ヘルプを画面いっぱいに開く
  colorcolumn= "80" --80列目の背景色変更
}


-- vim.opt
