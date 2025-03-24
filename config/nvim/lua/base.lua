--画面表示の設定
local opts = {
  -------------------------------------------------- buffer
  hidden=true,
  -------------------------------------------------- commandline
  wildmenu = true,
  wildmode = "list,longest,full",-- コマンドラインモードでTABキーによるファイル名補完を有効に
  history = 10000,               -- コマンド履歴を10000件保存する
  -------------------------------------------------- cursor
  backspace     = 'indent,eol,start', -- Backspaceキーの影響範囲に制限を設けない
  whichwrap     = 'b,s,h,l,<,>,[,]',  -- 行頭行末の左右移動で行をまたぐ
  scrolloff     = 8, -- 上下8行の視界を確保
  sidescrolloff = 16, -- 左右スクロール時の視界を確保
  sidescroll    = 1, -- 左右スクロールは一文字づつ行う
  ruler         = true, --カーソルが何行目の何列目に置かれているかを表示する
  -------------------------------------------------- display
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
  number=true, -- 行番号を表示する
  cursorline=true,   -- カーソル行の背景色を変える
  cursorcolumn=true,   -- カーソル位置のカラムの背景色を変える
  laststatus=2,   -- ステータス行を常に表示
  cmdheight=2,    -- メッセージ表示欄を2行確保
  showmatch=true,      -- 対応する括弧を強調表示
  helpheight=999, -- ヘルプを画面いっぱいに開く
  colorcolumn= "80", --80列目の背景色変更
  -------------------------------------------------- windows
  clipboard = 'unnamed,unnamedplus', -- OSのクリップボードをレジスタ指定無しで Yank, Put>
  -- vim.o.mouse = 'a'  -- マウスの入力を受け付ける (コメントアウト)
  shellslash = true, -- Windows でもパスの区切り文字を / にする

  -------------------------------------------------- file io
  confirm = true, -- 保存されていないファイルがあるときは終了前に保存確認
  hidden = true, -- 保存されていないファイルがあるときでも別のファイルを開くことが出来る
  autoread = true, -- 外部でファイルに変更がされた場合は読みなおす
  backup = false, -- ファイル保存時にバックアップファイルを作らない
  swapfile = false, -- ファイル編集中にスワップファイルを作らない

  -------------------------------------------------- language
  helplang = 'ja,en',
  -------------------------------------------------- mouse
  mousemodel = 'extend', -- 範囲選択などマウス操作有効化
  -------------------------------------------------- search
  smartcase = true, -- 検索パターンに大文字が含まれている場合は区別して検索する
  hlsearch = true, -- 検索文字列をハイライトする
  incsearch = true, -- インクリメンタルサーチを行う
  ignorecase = true, -- 大文字と小文字を区別しない
  wrapscan = true, -- 最後尾まで検索を終えたら次の検索で先頭に移る
  gdefault = true, -- 置換の時 g オプションをデフォルトで有効にする
  -------------------------------------------------- sound
  visualbell = true, -- ビープ音すべてを無効にする
  errorbells = false,    -- エラーメッセージの表示時にビープを鳴らさない
  -------------------------------------------------- tab-indent
  expandtab = true, -- タブ入力を複数の空白入力に置き換える
  tabstop = 2, -- 画面上でタブ文字が占める幅
  shiftwidth = 2, -- 自動インデントでずれる幅
  softtabstop = 4, -- 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
  autoindent = true, -- 改行時に前の行のインデントを継続する
  -- 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
  smartindent = true,
  smarttab = true,
  -------------------------------------------------- spell
  spell = true,
  spelllang = { "en_us" },
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end

-------------------------------------------------- keymap
-- バッファ移動のキーマップ !でnobuflistedでも移動できる
vim.keymap.set('n', '[b', '<cmd>bprevious!<cr>', { silent = true })
vim.keymap.set('n', ']b', '<cmd>bnext!<cr>', { silent = true })
vim.keymap.set('n', '[B', '<cmd>bfirst!<cr>', { silent = true })
vim.keymap.set('n', ']B', '<cmd>blast!<cr>', { silent = true })
-- タグ移動のキーマップ
-- vim.keymap.set('n', '[t', '<cmd>tprevious<cr>', { silent = true })
-- vim.keymap.set('n', ']t', '<cmd>tnext<cr>', { silent = true })
-- vim.keymap.set('n', '[T', '<cmd>tfirst<cr>', { silent = true })
-- vim.keymap.set('n', ']T', '<cmd>tlast<cr>', { silent = true })
-- タブ移動のキーマップ
vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { silent = true })
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { silent = true })
vim.keymap.set('n', '[T', '<cmd>tabfirst<cr>', { silent = true })
vim.keymap.set('n', ']T', '<cmd>tablast<cr>', { silent = true })
-- クイックフィックスリスト移動のキーマップ
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>', { silent = true })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { silent = true })
vim.keymap.set('n', '[Q', '<cmd>cfirst<cr>', { silent = true })
vim.keymap.set('n', ']Q', '<cmd>clast<cr>', { silent = true })
-- 矢印キーではなくhjklを使うよう習慣を矯正するための設定
vim.keymap.set('n', '<Up>', '<nop>')
vim.keymap.set('n', '<Down>', '<nop>')
vim.keymap.set('n', '<Right>', '<nop>')
vim.keymap.set('n', '<Left>', '<nop>')

  -------------------------------------------------- tab-indent
if vim.fn.has("autocmd") == 1 then
  vim.cmd("filetype plugin on") -- ファイルタイプの検索を有効にする
  vim.cmd("filetype indent on") -- ファイルタイプに合わせたインデントを利用

  -- sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtabの略
  vim.api.nvim_create_autocmd("FileType", { pattern = "c", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "html", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "ruby", command = "setlocal sw=2 sts=2 ts=2 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "js", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "zsh", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "python", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "scala", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "json", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "html", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "css", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "scss", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "sass", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "javascript", command = "setlocal sw=4 sts=4 ts=4 et" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "setlocal sw=2 sts=2 ts=2 et" })
end







