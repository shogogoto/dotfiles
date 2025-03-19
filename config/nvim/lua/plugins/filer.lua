--return {
--  'stevearc/oil.nvim',
--  ---@module 'oil'
--  ---@type oil.SetupOpts
--  opts = {},
--  -- Optional dependencies
--  dependencies = { { "echasnovski/mini.icons", opts = {} } },
--  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
--  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
--  lazy = false,
--}

return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    { "<Leader>ee", "<cmd>Neotree position=float<CR>", mode = "n", desc = "開く" },
    { "<Leader>eb", "<cmd>Neotree buffers position=float<CR>", mode = "n" },
  },
  opts = {
    filesystem = {
      -- hijack_netrw_behavior = "open_current",
      window = {
        position = "float",

        mappings = {
          ["l"] = "open", -- override "focus_preview" to similar to fern.vim
          ["h"] = "close_node"
        }
      },
    },
  },
  init = function()
    -- netrwを無効化
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
