return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next", -- <C-n> と同じだが馴染みやすい方へ
          ["<C-k>"] = "move_selection_previous", -- 同上
        },
      },
    },
  },
  keys = {
    {
      "<leader>ff",
      "<cmd>Telescope find_files<CR>",
      desc = "Telescope find files",
    },
    {
      "<leader>fg",
      "<cmd>Telescope live_grep<CR>",
      desc = "Telescope live grep",
    },
    {
      "<leader>fb",
      "<cmd>Telescope buffers<CR>",
      desc = "Telescope buffers",
    },
    {
      "<leader>fh",
      "<cmd>Telescope help_tags<CR>",
      desc = "Telescope help tags",
    },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Telescope diagnostics" },
    {
      "<leader>h",
      "<cmd>Telescope oldfiles<CR>",
      desc = "Telescope recently files",
    },
    {
      "gr",
      "<cmd>Telescope lsp_references<CR>",
      desc = "カーソルで現在ホーバーしている変数やメソッドなどのキーワードが参照されている箇所を検索",
    },
  },
}
