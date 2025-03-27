return {
  "nvimtools/none-ls.nvim",
  config = function()
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
