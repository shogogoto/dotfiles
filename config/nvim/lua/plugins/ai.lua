-- vim.opt.laststatus = 3 -- avanteで推奨
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  config = function()
    local avante = require("avante")
    
    avante.setup({
      provider = "claude", -- デフォルトのプロバイダー設定
      openai = {
        -- api_key = vim.env.OPENAI_API_KEY,
        -- model = "gpt-4o", -- 無料枠で最も高性能
        -- temperature = 0.7,
        -- max_tokens = 1000,
        -- frequency_penalty = 0,
        -- presence_penalty = 0,
        -- model = "gpt-4-turbo",
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",  -- your desired model (or use gpt-4o, etc.)
        timeout = 30000,   -- timeout in milliseconds
        temperature = 0.3, -- adjust if needed
        max_tokens = 4096,
      },
      anthropic = {
        api_key = vim.env.ANTHROPIC_API_KEY,
        model = "claude-instant-1", -- 無料枠で最も高性能
        -- model = "claude-3-5-sonnet",
      },
      gemini = {
        api_key = vim.env.GEMINI_API_KEY,
        model = "gemini-1.5-flash", -- 無料枠で最も高性能
        -- model = "gemini-pro",
      },
      
      
      -- UIの設定
      ui = {
        border = "rounded",
        width = 80,
        height = 20,
      },
      
      -- 一般設定
      debug = false,
      auto_insert_mode = true,
      keymaps = {
        submit = "<C-s>", -- Control + sで送信
        cancel = "<C-c>", -- Control + cでキャンセル
        toggle = "<C-a>", -- Control + aでトグル
      },
    })
    
    -- -- プロバイダーを切り替えるためのキーマップ設定
    -- vim.keymap.set("n", "<leader>aqo", function() avante.set_provider("openai") end, { desc = "Switch to OpenAI" })
    -- vim.keymap.set("n", "<leader>aqc", function() avante.set_provider("anthropic") end, { desc = "Switch to Claude" })
    -- vim.keymap.set("n", "<leader>aqg", function() avante.set_provider("gemini") end, { desc = "Switch to Gemini" })
    -- vim.keymap.set("n", "<leader>aqs", function() avante.get_provider() end, { desc = "Show current provider" })
    
    -- -- avante.nvimのコマンド
    -- vim.keymap.set("n", "<leader>at", function() avante.toggle() end, { desc = "Toggle Avante" })
    -- vim.keymap.set("v", "<leader>ap", function() avante.prompt_selection() end, { desc = "Prompt with selection" })
    
    -- -- メイン機能へのショートカット
    -- vim.keymap.set("n", "<leader>ac", function() avante.chat() end, { desc = "Open Avante chat" })
    -- vim.keymap.set("n", "<leader>ae", function() avante.explain_code() end, { desc = "Explain code" })
    -- vim.keymap.set("n", "<leader>af", function() avante.fix_code() end, { desc = "Fix code" })
    -- vim.keymap.set("n", "<leader>ad", function() avante.document_code() end, { desc = "Document code" })
  end,
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "markdown", -- :TSInstall markdown を自動実行したいのにしてくれない
          "lua",
          "vim",
          "vimdoc",
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
      }
    },
    "stevearc/dressing.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
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
  },
}

