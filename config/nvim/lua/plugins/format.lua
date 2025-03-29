local js_formatters = { "prettier", "eslint_d" }

return {
  {
    "stevearc/conform.nvim",
    events = "VeryLazy",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = js_formatters,
        typescript = js_formatters,
        markdown = js_formatters,
        html = js_formatters,
        css = js_formatters,
        json = js_formatters,
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
      stop_after_first = true,
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
        quiet = false,
      },
    },
    keys = {
      {
        "<leader>fm",
        function()
          vim.lsp.buf.format({ async = true })
        end,
        desc = "Format",
      },
    },
  },
}
