

return {
  'lambdalisue/fern.vim',
  opts = {

  },
  keys = {
    { "<leader>e", ":Fern . -reveal=% -drawer<CR>", desc = "toggle fern" },
    { "<leader>b", ":Fern bookmark:///<cr>" }
  },
  dependencies = {
    {
      'lambdalisue/nerdfont.vim',
      'lambdalisue/fern-git-status.vim',
      'lambdalisue/fern-bookmark.vim',
      'lambdalisue/fern-mapping-mark-children.vim',
      'lambdalisue/fern-mapping-project-top.vim',
      'lambdalisue/fern-hijack.vim', -- vi .でファイラー起動
      'yuki-yano/fern-preview.vim',

      'lambdalisue/nerdfont.vim',
      'ryanoasis/vim-devicons',
      'lambdalisue/fern-renderer-nerdfont.vim',
      -- Plug 'lambdalisue/fern-renderer-devicons.vim',
      'lambdalisue/glyph-palette.vim', -- iconに色をつける
      'LumaKernel/fern-mapping-fzf.vim',
      'andykog/fern-search.vim',
      'lambdalisue/fern-comparator-lexical.vim',
    },
    {
      'lambdalisue/fern-renderer-nerdfont.vim',
      config = function()
        vim.g["fern#comparator"] = "lexical"
        -- vim.g["fern#renderer"] = "devicons"
        vim.g["fern#renderer"] = "nerdfont"
        -- help: Fern内で Shift+? or a help
        vim.g["fern#default_hidden"] = 1 -- Show hidden files
        vim.g["fern#default_exclude"] = "^%(.git|.byebug|__pycache__)$"

        vim.g["netrw_liststyle"]=1      -- ファイルツリーの表示形式、1にするとls -laのような表示になります
        vim.g["netrw_banner"]=0         -- ヘッダを非表示にする
        vim.g["netrw_sizestyle"]="H"    -- サイズを(K,M,G)で表示する
        vim.g["netrw_preview"]=1        -- プレビューウィンドウを垂直分割で表示する
        vim.g["netrw_winsize"] = 80     -- 分割で開いたときに80%のサイズで開く
        vim.g["netrw_liststyle"] = 3    -- 表示形式をTreeViewに変更
        vim.g["netrw_browse_split"] = 3 -- Enterで、タブ表示

        -- -- アイコンに色をつける
        vim.cmd([[
          augroup my-glyph-palette
            autocmd! *
            autocmd FileType fern call glyph_palette#apply()
            autocmd FileType nerdtree,startify call glyph_palette#apply()
          augroup END


        ]])
      end


    },
  },
  -- -- Icons
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   config = function()
  --     require("nvim-web-devicons").setup({
  --       default = true,
  --     })
  --   end,
  -- },
}

