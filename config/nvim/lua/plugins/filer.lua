

return {
  'lambdalisue/fern.vim',
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
      -- 'lambdalisue/fern-renderer-nerdfont.vim',
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
        vim.g["fern#default_hidden"] = 0 -- Show hidden files
        vim.g["fern#default_exclude"] = "^%(.git|.byebug|__pycache__)$"

        -- -- アイコンに色をつける
        -- vim.cmd([[
        --   augroup my-glyph-palette
        --     autocmd! *
        --     autocmd FileType fern call glyph_palette#apply()
        --     autocmd FileType nerdtree,startify call glyph_palette#apply()
        --   augroup END
        -- ]])


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

