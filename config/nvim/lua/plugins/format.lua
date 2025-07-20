local js_formatters = { "biome-check", "biome" }

return {
	{
		"stevearc/conform.nvim",
		-- events = "VeryLazy",
		config = function()
			local util = require("conform.util")
			local conform = require("conform").setup({
				-- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
					html = js_formatters,
					css = js_formatters,
					json = js_formatters,
					python = { "ruff_fix", "ruff_format" },
					-- ["*"] = { "codespell" }, TypeScriptで意図しないフォーマット afterAll -> after all
					["_"] = { "trim_whitespace" },
				},
				formatters = {
					["biome-check"] = {
						args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
					},
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
	{
		"ntpeters/vim-better-whitespace",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.g.better_whitespace_enabled = 1 -- 空白文字のハイライトを有効にする
			vim.g.strip_whitespace_on_save = 1 -- 保存時に自動的に空白を削除する
			vim.g.strip_whitespace_confirm = 0 -- 確認なしで空白を削除する
			-- 無視するファイルタイプ
			vim.g.better_whitespace_filetypes_blacklist = {
				"diff",
				"git",
				"gitcommit",
				"unite",
				"qf",
				"help",
				"markdown",
				"fugitive",
				"TelescopePrompt",
			}
			vim.g.better_whitespace_ctermcolor = "red"
			vim.g.better_whitespace_guicolor = "#FF5555"
		end,
		keys = {
			{ "<leader>ws", "<cmd>StripWhitespace<CR>", desc = "空白文字を削除" },
			{ "<leader>wt", "<cmd>ToggleWhitespace<CR>", desc = "空白文字のハイライト表示を切り替え" },
		},
	},
}
