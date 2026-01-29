return {
	-- 執筆に集中するモード
	{
		"junegunn/goyo.vim",
		cmd = "Goyo", -- 'Goyo' コマンドを叩いた時だけロードする（効率的です）
		keys = {
			{ "<leader>gy", "<cmd>Goyo<cr>", desc = "Goyo Mode" },
		},
		config = function()
			-- 必要であればここにオプションを書けます
			vim.g.goyo_width = 120
			-- Goyo起動時
			vim.api.nvim_create_autocmd("User", {
				pattern = "GoyoEnter",
				command = "Limelight",
			})

			-- Goyo終了時
			vim.api.nvim_create_autocmd("User", {
				pattern = "GoyoLeave",
				command = "Limelight!",
			})
		end,
	},
	-- activeでない場所をグレーにする
	{
		"junegunn/limelight.vim",
		cmd = "Limelight",
		keys = {
			{ "<leader>L", "<cmd>Limelight!!<cr>", desc = "Toggle Limelight" },
		},
		config = function()
			-- 減光の度合い (0.0 〜 1.0)
			-- 0に近いほど、周囲が暗くなります
			vim.g.limelight_default_coefficient = 0.5
			-- 段落の境界を設定（任意）
			-- vim.g.limelight_paragraph_span = 1
		end,
	},
}
