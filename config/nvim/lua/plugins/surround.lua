return {
	{
		"andymass/vim-matchup", -- 対へジャンプ
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			matchup = {
				enable = true, -- プラグインを有効化
				disable = {}, -- 無効にする言語を指定
				disable_virtual_text = false, -- 仮想テキストを有効化
				include_match_words = true, -- vim の matchit 互換機能を含める
				treesitter = {
					enable = true, -- Treesitter統合を有効化
					disable = {}, -- Treesitter統合を無効にする言語を指定
				},
			},
		},
		keys = {
			{ "%", desc = "Jump to matching pair" },
			{ "[%", desc = "Jump to previous matching pair" },
			{ "]%", desc = "Jump to next matching pair" },
			{ "g%", desc = "Jump to inside of matching pair" },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"ysmb-wtsg/in-and-out.nvim",
		keys = {
			{
				"<M-j>",
				function()
					require("in-and-out").in_and_out()
				end,
				mode = { "i", "n" },
				desc = "対から出る/次の対に入る",
			},
		},
		opts = { additional_targets = { "“", "”" } },
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
}
