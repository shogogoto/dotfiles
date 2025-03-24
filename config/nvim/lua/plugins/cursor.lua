return {
  { "ethanholz/nvim-lastplace", -- カーソルの位置を記憶する
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
      })
    end,
  }
}
