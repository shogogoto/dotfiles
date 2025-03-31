local js_formatters = { "prettier", "eslint_d" }

return {
	{
		"stevearc/conform.nvim",
		-- events = "VeryLazy",
		config = function()
			local conform = require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
					markdown = js_formatters,
					html = js_formatters,
					css = js_formatters,
					json = js_formatters,
					python = { "ruff_fix", "ruff_format" },
					["*"] = { "codespell" },
					["_"] = { "trim_whitespace" },
				},
				-- stop_after_first = false,
				-- default_format_opts = {
				--   lsp_format = "fallback",
				-- },

				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = {
					lsp_format = "fallback",
					timeout_ms = 500,
				},
			})

			vim.keymap.set("n", "<leader>fm", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format" })
		end,
	},
}
