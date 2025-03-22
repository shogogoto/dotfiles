-- 整形
return {
  { 'Wansmer/treesj', -- コードブロックを分割したり結合する
    keys = {
      { "<leader>sj", "<cmd>TreesjSplit<cr>", desc = "Split code block" },
      { "<leader>sk", "<cmd>TreesjJoin<cr>", desc = "Join code block" },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({--[[ your config ]]})
    end,
  }
}
