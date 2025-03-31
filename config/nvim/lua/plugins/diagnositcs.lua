return {
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		-- diagnosticを折りたたんで表示
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					multilines = {
						always_show = true,
					},
					show_all_diags_on_cursorline = true,
					format = function(diagnostic)
						local msg = diagnostic.message
						local code = diagnostic.code or ""
						local src = diagnostic.source or ""
						if src:lower() == "ruff" and code ~= "" then
							local url = string.format("https://docs.astral.sh/ruff/rules/%s", code)
							return string.format("[%s] %s: %s\nRef: %s", src, code, msg, url)
						end
						if code ~= "" then
							return string.format("[%s] %s: %s", src, code, msg)
						else
							return string.format("[%s]: %s", src, msg)
						end
					end,
				},
			})
			-- vim の pureな設定
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
				virtual_text = false,
			}) -- Only if needed in your configuration, if you already have native LSP diagnostics
			vim.keymap.set("n", "gK", function()
				local new_config = not vim.diagnostic.config().virtual_lines
				vim.diagnostic.config({ virtual_lines = new_config })
			end, { desc = "Toggle diagnostic virtual_lines" })
			vim.opt.updatetime = 1000 -- ホバー表示の遅延時間を設定（ミリ秒）
			-- カーソルがホバーした時に自動的に診断情報を表示する うぜーかも gKでトグルするだけでよい
			-- vim.api.nvim_create_autocmd("CursorHold", {
			--   callback = function()
			--     vim.diagnostic.open_float({
			--       focusable = false,
			--       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			--     })
			--   end,
			-- })
		end,
	},
}
