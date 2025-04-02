local symbols = require("user.symbols")

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
		branch = "v3.x",
		keys = {
			{
				"<Leader>e",
				"<cmd>Neotree position=left toggle reveal dir=%:p:h:h<CR>",
				mode = "n",
				desc = "ファイラー開く",
			},
			{
				"<Leader>fe", -- efだとeコマンドと衝突
				"<cmd>Neotree position=float toggle reveal dir=<CR>",
				mode = "n",
				desc = "フロートでファイラー開く",
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			-- Vimの起動時にneo-treeを自動的に開く
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					-- ネステッドな Neovim セッションでない場合のみ実行 tig対策
					if not vim.env.NVIM and not vim.env.NVIM_TIG and not vim.env.GIT_EDITOR then
						vim.cmd("Neotree show reveal dir=%:p:h:h")
					end
				end,
			})
		end,
		opts = {
			sources = { "filesystem", "buffers", "git_status", "document_symbols" },
			filesystem = {
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				expand_root = true,
				-- hijack_netrw_behavior = "open_current",
				window = {
					position = "left",
					width = 30,
					mappings = {
						["<cr>"] = "open_with_window_picker",
						["l"] = "open_with_window_picker", -- override "focus_preview" to similar to fern.vim
						["s"] = "split_with_window_picker",
						["v"] = "vsplit_with_window_picker",
						["h"] = "close_node",
						["oa"] = "avante_add_files",
					},
				},
				commands = {
					avante_add_files = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local relative_path = require("avante.utils").relative_path(filepath)
						local sidebar = require("avante").get()
						local open = sidebar:is_open()
						-- ensure avante sidebar is open
						if not open then
							require("avante.api").ask()
							sidebar = require("avante").get()
						end
						sidebar.file_selector:add_selected_file(relative_path)
						-- remove neo tree buffer
						if not open then
							sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
						end
					end,
				},
			},
			default_component_configs = { diagnostics = { symbols = symbols } },
		},
		init = function() -- netrwを無効化
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker", -- 既存の分割ウィンドウを指定してopen
				opts = {
					autoselect_one = true,
					include_current = true,
					filter_rules = {
						bo = {
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							buftype = { "terminal", "quickfix" },
						},
					},
					other_win_hl_color = "#e35e4f",
				},
			},
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
			-- {
			-- 	"ahmedkhalf/project.nvim", -- 自動でprojct rootへcd
			-- 	lazy = false,
			-- },
		},
	},
	{
		"goolord/alpha-nvim", -- vi 単体で開く画面
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			-- { 'echasnovski/mini.icons' },
		},
		config = function()
			-- local name = "alpha.themes.startify"
			-- local name = "alpha.themes.dashboard"
			local name = "alpha.themes.theta"
			local theme = require(name)
			-- theme.file_icons.provider = "devicons" -- available: devicons, mini, default is mini
			require("alpha").setup(theme.config)
		end,
	},
	{
		"b0o/incline.nvim", -- 右上にファイル名表示
		config = function()
			require("incline").setup()
		end,
		-- Optional: Lazy load Incline
		event = "VeryLazy",
	},
}
