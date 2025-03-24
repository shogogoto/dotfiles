return {
  {
    "ethanholz/nvim-lastplace", -- カーソルの位置を記憶する
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true,
      })
    end,
  },
  { "rhysd/clever-f.vim" }, -- f/F/t/T 移動の強化
  {
    "skanehira/jumpcursor.vim",
    keys = {
      { "<leader>j", "<Plug>(jumpcursor-jump)", mode = "n", desc = "jump cursor by Gorilla" },
    },
  },
}
