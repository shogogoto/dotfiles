vim.opt.laststatus = 3 -- avanteで推奨

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  -- lazy = false,
  priority = 1000, -- GitHub Copilotと共存させたい
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "gemini", -- プロバイダーをgeminiに変更
    gemini = {
      model = "gemini-2.0-flash", 
    },

    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      temperature = 0,
      max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    },
    -- ファイル操作ツールを設定
    tools = {
      create_file = true,  -- ファイル作成ツール
      write_file = true,  -- ファイル書き込みツール - 既存ファイルへの変更が新規バッファに書き込まれる問題を修正
      rename_file = true,  -- ファイル名変更ツール
      delete_file = true,  -- ファイル削除ツール
      list_files = true,   -- ファイル一覧ツール
      glob = true,         -- ファイルパターンマッチングツール
      git_diff = true,     -- Gitの差分表示ツール
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
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
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
    {"zbirenbaum/copilot.lua", -- for providers='copilot'
      lazy = false, -- Copilotはすぐに読み込む必要があります
      cmd = "Copilot",
      event = "InsertEnter",
      dependencies = {
        "zbirenbaum/copilot-cmp", -- オプション: CMP統合が必要な場合
        { "github/copilot.vim",
          config = function()
            -- Copilotの基本設定
            -- vim.g.copilot_no_tab_map = true -- デフォルトのタブキーマッピングを無効化
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_tab_fallback = ""
            
            -- Copilotのフィルタリング設定
            vim.g.copilot_filetypes = {
              ["*"] = true,
              ["markdown"] = true,
              ["help"] = false,
              ["gitcommit"] = false,
            }
          end,
          keys = {
            { "<C-j>", 'copilot#Accept("<CR>")', mode = "i", silent = true, expr = true, desc = "サジェストを受け入れる" },
            { "<C-h>", '<Plug>(copilot-previous)', mode = "i", desc = "前のサジェストに移動" },
            { "<C-l>", '<Plug>(copilot-next)', mode = "i", desc = "次のサジェストに移動" },
            { "<C-d>", '<Plug>(copilot-dismiss)', mode = "i", desc = "サジェストを拒否" },
            { "<M-s>", ':Copilot toggle<CR>', mode = "n", desc = "Copilotのサジェストをトグル" },
            { "<M-p>", ':Copilot panel<CR>', mode = "n", desc = "Copilotパネルを開く" },
          },
        },

      },
    },
  },

}
