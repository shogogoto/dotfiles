return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local diagnostics = null_ls.builtins.diagnostics

    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- 診断情報の前に表示する記号
        source = "if_many", -- 複数のソースがある場合にのみソースを表示
        spacing = 4, -- テキストとの間隔
      },
      float = {
        source = "always", -- フロートウィンドウには常にソースを表示
        border = "rounded", -- 境界線のスタイル
        header = "", -- ヘッダーテキスト
        prefix = "", -- プレフィックス
      },
      signs = true, -- サイン列にアイコンを表示
      underline = true, -- エラー箇所に下線を表示
      update_in_insert = false, -- インサートモード中は更新しない
      severity_sort = true, -- 重要度でソート
    })

    -- -- ホバー時に診断情報を表示するキーマッピング
    -- vim.keymap.set(
    --   "n",
    --   "<Leader>e",
    --   vim.diagnostic.open_float,
    --   { noremap = true, silent = true, desc = "Show diagnostic" }
    -- )
    -- -- 診断リストを表示するキーマッピング
    -- vim.keymap.set(
    --   "n",
    --   "<Leader>q",
    --   vim.diagnostic.setloclist,
    --   { noremap = true, silent = true, desc = "Diagnostic list" }
    -- )

    null_ls.setup({
      diagnostics_format = "#{m} (#{s}: #{c})",
      sources = {
        null_ls.builtins.formatting.stylua,
        diagnostics.lua_ls, -- lua_lsの診断を有効化
        null_ls.builtins.completion.spell,
        -- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
      },
      on_attach = function(client, bufnr)
        -- LSPアタッチ時の処理
        if client.supports_method("textDocument/publishDiagnostics") then
          -- 診断情報をサポートしている場合の処理
          vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        end
      end,
    })
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- { "jay-babu/mason.nvim" },
    -- { "jay-babu/mason-lspconfig.nvim" },
  },
}
