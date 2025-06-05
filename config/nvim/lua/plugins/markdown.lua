vim.treesitter.language.register("markdown", "mdx")
vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})

return {
	{
		"MeanderingProgrammer/render-markdown.nvim", -- Make sure to set this up properly if you have lazy=true
		lazy = true,
		opts = {
			file_types = { "markdown", "Avante", "mdx" },
			indent = {
				enabled = true,
				skip_heading = true,
				icon = "▎",
			},
			-- strikethrough = { enabled = true },
		},
		ft = { "markdown", "Avante", "mdx" },
		keys = {
			{ "<Space>rm", ":RenderMarkdown toggle<CR>" },
		},
	},
	{
		"nfrid/markdown-togglecheck",
		dependencies = { "nfrid/treesitter-utils" }, -- 依存プラグイン
		ft = { "markdown" }, -- markdownファイルでのみ有効にする
		config = function()
			require("markdown-togglecheck").setup({
				create = true, -- チェックボックスがない行でトグルコマンドを実行すると新しいチェックボックスを作成する
				remove = false, -- チェック済みのチェックボックスを削除する代わりにチェックを外す
			})

			-- キーバインドを設定 (例: <leader>tc でトグル)
			vim.keymap.set("n", "<leader>tc", require("markdown-togglecheck").toggle, { desc = "Toggle Checkmark" })
		end,
	},
}
