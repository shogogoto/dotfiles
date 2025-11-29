local function camelToKebab(str)
	local result = string.gsub(str, "(%u)", function(c)
		return "-" .. string.lower(c)
	end)
	if string.sub(result, 1, 1) == "-" then
		result = string.sub(result, 2)
	end

	return result
end

local function getLastSegment(str)
	if not str or str == "" then
		return ""
	end
	local lastSlashPos = 0
	for i = 1, #str do
		if string.sub(str, i, i) == "/" then
			lastSlashPos = i
		end
	end
	if lastSlashPos == 0 then
		return str -- '/'がない場合は元の文字列を返す
	else
		return string.sub(str, lastSlashPos + 1)
	end
end

return {
	-- {
	-- 	"folke/trouble.nvim",
	-- 	opts = {}, -- for default options, refer to the configuration section for custom setup.
	-- 	cmd = "Trouble",
	-- 	keys = {
	-- 		{
	-- 			"<leader>xx",
	-- 			"<cmd>Trouble diagnostics toggle<cr>",
	-- 			desc = "Diagnostics (Trouble)",
	-- 		},
	-- 		{
	-- 			"<leader>xX",
	-- 			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	-- 			desc = "Buffer Diagnostics (Trouble)",
	-- 		},
	-- 		{
	-- 			"<leader>cs",
	-- 			"<cmd>Trouble symbols toggle focus=false<cr>",
	-- 			desc = "Symbols (Trouble)",
	-- 		},
	-- 		{
	-- 			"<leader>cl",
	-- 			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	-- 			desc = "LSP Definitions / references / ... (Trouble)",
	-- 		},
	-- 		{
	-- 			"<leader>xL",
	-- 			"<cmd>Trouble loclist toggle<cr>",
	-- 			desc = "Location List (Trouble)",
	-- 		},
	-- 		{
	-- 			"<leader>xQ",
	-- 			"<cmd>Trouble qflist toggle<cr>",
	-- 			desc = "Quickfix List (Trouble)",
	-- 		},
	-- 	},
	-- },
	{
		-- diagnosticを折りたたんで表示
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					multilines = {
						enabled = true,
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
						if src:lower() == "biome" and code ~= "" then
							local name = getLastSegment(code)
							local url = string.format("https://biomejs.dev/linter/rules/%s/", camelToKebab(name))
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
			vim.keymap.set("n", "gF", function() -- 診断ウィンドウを開き、そこにフォーカス
				vim.diagnostic.open_float({
					focusable = true, -- 重要: ウィンドウをフォーカス可能にする
					focus = true, -- 重要: 開いたときにカーソルを移動させる
					scope = "line", -- 行単位で表示
					border = "rounded", -- 見やすく枠を丸くする
					source = "if_many", -- 複数のソースがある場合のみソース名を表示
				})
			end, { desc = "Show diagnostic float and focus" })

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
