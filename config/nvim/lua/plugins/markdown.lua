vim.treesitter.language.register("markdown", "mdx")
vim.filetype.add({
	extension = {
		mdx = "mdx",
		-- kn = "markdown",
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
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_markdown_renderer = "katex"
			vim.g.mkdp_echo_preview_url = 1
		end,
		ft = { "markdown" },
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
			{ "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Preview" },
		},
	},
}
