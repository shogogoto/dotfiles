vim.treesitter.language.register("markdown", "mdx")
vim.filetype.add({
	extension = {
		mdx = "mdx",
		kn = "markdown",
	},
})
-- Markdownファイル（kn, mdx含む）を開いた時に設定を強制する
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown", "mdx" },
	callback = function()
		-- 1. 以前の計算をリセットするために一度 manual にしてから expr に戻す
		vim.opt_local.foldmethod = "manual"

		-- 2. Treesitterの計算式を指定
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt_local.foldmethod = "expr"

		-- 3. 最初はすべて展開した状態にする（お好みで 0 にすれば全部閉じます）
		vim.opt_local.foldlevel = 99
		vim.opt_local.foldenable = true
	end,
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
			strikethrough = { enabled = true },
		},
		ft = { "markdown", "Avante", "mdx" },
		keys = {
			{ "<Space>rm", ":RenderMarkdown toggle<CR>" },
		},
	},
	-- comment out for error avoiding
	-- {
	-- 	"nfrid/markdown-togglecheck",
	-- 	dependencies = { "nfrid/treesitter-utils" }, -- 依存プラグイン
	-- 	ft = { "markdown" }, -- markdownファイルでのみ有効にする
	-- 	config = function()
	-- 		require("markdown-togglecheck").setup({
	-- 			create = true, -- チェックボックスがない行でトグルコマンドを実行すると新しいチェックボックスを作成する
	-- 			remove = false, -- チェック済みのチェックボックスを削除する代わりにチェックを外す
	-- 		})
	-- 		-- キーバインドを設定 (例: <leader>tc でトグル)
	-- 		vim.keymap.set("n", "<leader>tc", require("markdown-togglecheck").toggle, { desc = "Toggle Checkmark" })
	-- 	end,
	-- },
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
			vim.g.mkdp_port = 8904
			vim.g.mkdp_host = "0.0.0.0"
		end,
		ft = { "markdown" },
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
			{ "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Preview" },
		},
	},
	{
		"dbeniamine/todo.txt-vim",
		-- ft = { "todo" }, -- todo.txt ファイルを開いた時だけ読み込む（最適化）
		config = function()
			-- ここにカスタム設定を記述できます
			-- 例: 完了時に日付を自動付与する
			vim.g.TodoTxtForceDate = 1
		end,
	},
}
