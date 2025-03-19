return {
  {
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
      { "<Leader>ef", "<cmd>Neotree position=float<CR>", mode = "n", desc = "開く" },
      { "<Leader>ee", "<cmd>Neotree position=left<CR>", mode = "n", desc = "開く" },
      { "<Leader>eb", "<cmd>Neotree buffers position=float<CR>", mode = "n" },
    },
    opts = {
      filesystem = {
        -- hijack_netrw_behavior = "open_current",
        window = {
          position = "float",
          width = 30,
          mappings = {
            -- ["l"] = "open", -- override "focus_preview" to similar to fern.vim
            ["<cr>"] = "open_with_window_picker",
            ["l"] = "open_with_window_picker",
            ["s"] = "split_with_window_picker",
            ["v"] = "vsplit_with_window_picker",
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
  },
  {
    -- 既存の分割ウィンドウを指定してopen
    "s1n7ax/nvim-window-picker",
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" }
          }
        },
        other_win_hl_color = "#e35e4f",
      })
    end
  },
}
