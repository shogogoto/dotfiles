return {
  -- nvim-matchup: 括弧や対応するキーワードの間をジャンプするためのプラグイン
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      matchup = {
        enable = true,              -- プラグインを有効化
        disable = {},               -- 無効にする言語を指定
        disable_virtual_text = false, -- 仮想テキストを有効化
        include_match_words = true,  -- vim の matchit 互換機能を含める
        treesitter = {
          enable = true,           -- Treesitter統合を有効化
          disable = {},            -- Treesitter統合を無効にする言語を指定
        },
      }
    },
    keys = {
      { "%", desc = "Jump to matching pair" },
      { "[%", desc = "Jump to previous matching pair" },
      { "]%", desc = "Jump to next matching pair" },
      { "g%", desc = "Jump to inside of matching pair" },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "ysmb-wtsg/in-and-out.nvim",
    keys = {
      { "<M-j>", function() require("in-and-out").in_and_out() end, mode = {"i", "n"} },
    },
    opts = { additional_targets = { "“", "”" } },
  }
}
