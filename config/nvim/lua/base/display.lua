 --画面表示の設定
 vim.opt.wrap=false         --    ウィンドウの幅より長い行は折り返され、次の行に続けて表示
 vim.opt.wildmenu=true
 vim.opt.list=true
 vim.opt.listchars={
   tab=">.",
   trail="_",
   extends=">",
   precedes="<",
   nbsp="%",
 }
 vim.opt.number=true
 -- 行番号を表示する
 vim.opt.cursorline=true   -- カーソル行の背景色を変える
 vim.opt.cursorcolumn=80   -- カーソル位置のカラムの背景色を変える
 vim.opt.laststatus=2   -- ステータス行を常に表示
 vim.opt.cmdheight=2    -- メッセージ表示欄を2行確保
 vim.opt.showmatch=true      -- 対応する括弧を強調表示
 vim.opt.helpheight=999 -- ヘルプを画面いっぱいに開く
 vim.opt.colorcolumn=80 --80列目の背景色変更

