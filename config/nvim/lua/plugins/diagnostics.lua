return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local diagnostics = null_ls.builtins.diagnostics
    local symbols = require("user.symbols")
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- 診断情報の前に表示する記号
        source = "if_many", -- 複数のソースがある場合にのみソースを表示
        spacing = 4, -- テキストとの間隔
      },
      float = {
        source = true, -- フロートウィンドウには常にソースを表示
        border = "rounded", -- 境界線のスタイル
        header = "", -- ヘッダーテキスト
        prefix = "", -- プレフィックス
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = symbols.error,
          [vim.diagnostic.severity.WARN] = symbols.warn,
          [vim.diagnostic.severity.INFO] = symbols.info,
          [vim.diagnostic.severity.HINT] = symbols.hint,
        },
      },

      underline = true, -- エラー箇所に下線を表示
      update_in_insert = false, -- インサートモード中は更新しない
      severity_sort = true, -- 重要度でソート
    })

    null_ls.setup({
      -- diagnostics_format = "#{m} (#{s}: #{c})",
      diagnostics_format = "%[%l:%c%] #{m} (#{s}: #{c})",
      sources = {
        -- null_ls.builtins.diagnostics.cspell,
        -- null_ls.builtins.code_actions.cspell,
        -- null_ls.builtins.code_actions.eslint_d,
        -- diagnostics.lua_ls, -- lua_lsの診断を有効化
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.completion.luasnip,
        null_ls.builtins.completion.spell,

        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.diagnostics.ruff,
        -- null_ls.builtins.formatting.ruff,
        -- null_ls.builtins.formatting.prettier
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
