return {
  "nvimtools/none-ls.nvim",
  config = function()
    -- vim.keymap.set("n", "gK", function()
    --   local new_config = not vim.diagnostic.config().virtual_lines
    --   vim.diagnostic.config({ virtual_lines = new_config })
    -- end, { desc = "Toggle diagnostic virtual_lines" })

    local symbols = require("user.symbols")
    local sev = vim.diagnostic.severity
    vim.diagnostic.config({
      underline = true, -- エラー箇所に下線を表示
      update_in_insert = false, -- インサートモード中は更新しない
      severity_sort = true, -- 重要度でソート
      signs = {
        text = {
          [sev.ERROR] = symbols.error,
          [sev.WARN] = symbols.warn,
          [sev.INFO] = symbols.info,
          [sev.HINT] = symbols.hint,
        },
      },

      loclist = { open = true },
      virtual_text = {
        prefix = "●", -- 診断情報の前に表示する記号
        source = "if_many", -- 複数のソースがある場合にのみソースを表示
        spacing = 0, -- テキストとの間隔
        header = "Diagnostic Details", -- ヘッダーテキスト
        format = function(diagnostic)
          local msg = diagnostic.message
          local code = diagnostic.code or ""
          local src = diagnostic.source
          local line = string.format("%s: %s %s", src, code, msg)
          if src == "Ruff" and code ~= "" then
            local url = string.format("https://docs.astral.sh/ruff/rules/%s", code)
            -- return {
            --   { line, "DiagnosticVirtualTextError" },
            --   -- { url, "DiagnosticVirtualTextHint" },
            -- }
            -- end
          end
          return line
        end,

        -- hl_mode = "replace",
        -- suffix = function(diagnostic)
        --   local code = diagnostic.code or ""
        --   return string.format(code)
        -- end,
      },
      float = {
        -- source = "if_many", -- フロートウィンドウには常にソースを表示
        -- border = "rounded", -- 境界線のスタイル
        -- focusable = true, -- Allow interaction with floating window
        -- max_width = 80, -- Maximum width of floating window
        -- max_height = 20, -- Maximum height of floating window
      },
      -- jump = {
      --   float = true,
      -- },
    })

    local null_ls = require("null-ls")
    null_ls.setup({
      -- debug = true,
      -- diagnostics_format = "%[%l:%c%] #{m} (#{s}: #{c})",
      sources = {
        null_ls.builtins.diagnostics.cspell,
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.code_actions.markdownlint,
        null_ls.builtins.code_actions.ruff,
        null_ls.builtins.diagnostics.lua_ls,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.completion.require,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.completion.luasnip,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.prettier,
      },
    })
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "jay-babu/mason.nvim" },
    { "jay-babu/mason-lspconfig.nvim" },
  },
}
