-- *   `0`: ステータスラインは表示されません。
-- *   `1`: 複数のウィンドウがある場合にのみステータスラインが表示されます。
-- *   `2`: カレントウィンドウにステータスラインが表示されます。
-- *   `3`: 常にグローバルステータスラインが表示されます。
vim.opt.laststatus = 3 -- avanteで推奨

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    priority = 1000, -- GitHub Copilotと共存させたい
    version = false, -- Never set this value to "*"! Never!
    keys = {
      { "<Leader>aC", "<cmd>AvanteClear<CR>", mode = "n", desc = "Avante: clear" },
    },
    opts = {
      provider = "gemini", -- プロバイダーをgeminiに変更
      gemini = {
        model = "gemini-2.0-flash", --　既存では1.5-flashしか用意されていない
      },
      web_search_engine = {
        proivder = "google",
      },
      -- ファイル操作ツールを設定
      tools = {
        create_file = true, -- ファイル作成ツール
        write_file = true, -- ファイル書き込みツール - 既存ファイルへの変更が新規バッファに書き込まれる問題を修正
        rename_file = true, -- ファイル名変更ツール
        delete_file = true, -- ファイル削除ツール
        list_files = true, -- ファイル一覧ツール
        glob = true, -- ファイルパターンマッチングツール
        git_diff = true, -- Gitの差分表示ツール
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim", -- Make sure to set this up properly if you have lazy=true
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
      {
        "zbirenbaum/copilot.lua", -- for providers='copilot' -- cmd = "Copilot",
        lazy = false, -- Copilotはすぐに読み込む必要があります
        -- opts = {
        --   auto_trigger = true,
        --   suggestion = {
        --     enabled = true,
        --     auto_trigger = true,
        --     keymap = {
        --       accept = "<C-j>",
        --       accept_line = "<C-k>",
        --       accept_word = "<c-l>",
        --       refresh = "<C-r>",
        --       open = "<M-CR>"
        --     },
        --   },
        -- filetypes = { ["*"] = true, }
        -- panel = { enabled = false },
        -- },

        config = function(_, opts)
          require("copilot").setup(opts)
          -- require("copilot_cmp").setup()
        end,
        dependencies = {
          { "AndreM222/copilot-lualine" },
          { "zbirenbaum/copilot-cmp", opts = {} }, -- 効いてるのか不明
          {
            "github/copilot.vim", -- copilot.luaに含めないとaskで補間が効かない
            config = function(_, opts)
              vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
              })
              vim.g.copilot_no_tab_map = true -- デフォルトのタブキーマッピングを無効化
              vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
              vim.keymap.set("i", "<C-K>", "<Plug>(copilot-accept-line)")
            end,
          },
        },
      },
    },
  },
}
