return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	-- or                              , branch = '0.1.x',
	dependencies = {
		"nvim-lua/plenary.nvim",
		"s1n7ax/nvim-window-picker", -- 既存の分割ウィンドウを指定してopen
	},
	config = function()
		vim.api.nvim_create_user_command("Pick", function(e)
			local success, picked = pcall(function()
				return require("window-picker").pick_window({
					autoselect_one = true,
					include_current_win = true,
					current_win_hl_color = "#89b4fa",
					other_win_hl_color = "#89b4fa",
				})
			end)
			if not success then
				return
			end

			vim.api.nvim_set_current_win(picked)
			if e.fargs[1] ~= nil then
				vim.cmd("e " .. e.fargs[1])
			end
		end, { nargs = "?", complete = "file" })
		local action_set = require("telescope.actions.set")
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next", -- <C-n> と同じだが馴染みやすい方へ
						["<C-k>"] = "move_selection_previous", -- 同上
						["<C-l>"] = function(prompt_bufnr)
							action_set.edit(prompt_bufnr, "Pick")
						end,
					},
				},
			},
		})
	end,
	-- opts = {
	-- 	defaults = {
	-- 		mappings = {
	-- 			i = {
	-- 				["<C-j>"] = "move_selection_next", -- <C-n> と同じだが馴染みやすい方へ
	-- 				["<C-k>"] = "move_selection_previous", -- 同上
	-- 				["<C-l>"] = "open_with_window_picker",
	-- 			},
	-- 		},
	-- 	},
	-- },
	keys = {
		{
			"<leader>ff",
			"<cmd>Telescope find_files<CR>",
			desc = "Telescope find files",
		},
		{
			"<leader>fg",
			"<cmd>Telescope live_grep<CR>",
			desc = "Telescope live grep",
		},
		{
			"<leader>fb",
			"<cmd>Telescope buffers<CR>",
			desc = "Telescope buffers",
		},
		{
			"<leader>fh",
			"<cmd>Telescope help_tags<CR>",
			desc = "Telescope help tags",
		},
		{ "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Telescope diagnostics" },
		{
			"<leader>h",
			"<cmd>Telescope oldfiles<CR>",
			desc = "Telescope recently files",
		},
		{
			"gr",
			"<cmd>Telescope lsp_references<CR>",
			desc = "カーソルで現在ホーバーしている変数やメソッドなどのキーワードが参照されている箇所を検索",
		},
	},
}
