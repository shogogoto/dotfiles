return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		priority = 1000, -- 💡 全プラグインの中で最も高い優先度を設定
		lazy = false,
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>ti", "<cmd>TSConfigInfo<cr>", desc = "Treesitter Info" },
			{ "<leader>tu", "<cmd>TSUpdate<cr>", desc = "Update Parsers" },
			{ "<leader>tU", "<cmd>TSUpdateSync<cr>", desc = "Update Parsers (Sync)" },
		},
		-- opts = {
		-- 	sync_install = true,
		-- 	auto_install = true,
		-- 	highlight = {
		-- 		enable = true, -- 基本的なハイライトは有効に
		-- 		additional_vim_regex_highlighting = false,
		-- 		disable = function(lang, buf)
		-- 			local max_filesize = 50 * 1024 -- より小さいファイルサイズ制限 (50KB)
		-- 			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
		-- 			if ok and stats and stats.size > max_filesize then
		-- 				return true
		-- 			end
		-- 		end,
		-- 	},
		-- 	indent = { enable = true },
		-- 	folds = { enable = true },
		-- 	incremental_selection = {
		-- 		enable = false,
		-- 	},
		-- 	textobjects = {
		-- 		select = {
		-- 			enable = false,
		-- 			lookahead = true,
		-- 			include_surrounding_whitespace = true,
		-- 		},
		-- 		move = { enable = false },
		-- 		swap = { enable = false },
		-- 		lsp_interop = { enable = false },
		-- 	},
		-- 	matchup = {
		-- 		enable = true,
		-- 		disable_virtual_text = true,
		-- 		include_match_words = false,
		-- 	},
		-- },
		config = function(_, opts)
			require("nvim-treesitter").setup({
				-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			require("nvim-treesitter").install({
				"lua",
				"vim",
				"vimdoc",
				"query",
				"bash",
				"c",
				"cpp",
				"css",
				"dockerfile",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"python",
				"regex",
				"rust",
				"toml",
				"tsx",
				"typescript",
				"yaml",
				"markdown",
				"markdown_inline",
				"comment",
				"gitignore",
				"gitcommit",
				"diff",
				"git_rebase",
				"make",
				"sql",
				"php",
				"svelte",
				"vue",
				"graphql",
				"hcl",
				"java",
				"kotlin",
				"http",
				"ini",
				"terraform",
				"zig",
				"r",
				"ruby",
				"scala",
				"scss",
				"solidity",
			})
			-- 追加のハイライト用のグループを設定
			vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })

			-- Treesitterモジュールの設定
			-- require("nvim-treesitter").setup(opts)
			-- z から始まるkeybind で foldの開閉可能
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = true -- 初期状態では折りたたみを無効化
			vim.opt.foldlevel = 5

			-- -- 依存プラグインのrefactorとの連携
			-- if vim.o.ft == "tsx" or vim.o.ft == "jsx" or vim.o.ft == "typescript" or vim.o.ft == "javascript" then
			--   local refactor_opts = require("nvim-treesitter.configs").get_module("refactor")
			--   refactor_opts.navigation.keymaps.goto_next_usage = "<a-]>"
			--   refactor_opts.navigation.keymaps.goto_previous_usage = "<a-[>"
			--   require("nvim-treesitter.configs").setup({ refactor = refactor_opts })
			-- end

			-- matchup プラグインとの連携 (matchupがインストールされている場合)
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
		dependencies = {
			{
				-- コンテキスト表示
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					enable = true,
					max_lines = 3,
					min_window_height = 10,
					line_numbers = true,
					multiline_threshold = 5,
					trim_scope = "outer",
					patterns = {
						default = {
							"class",
							"function",
							"method",
							"for",
							"while",
							"if",
							"switch",
							"case",
							"interface",
							"struct",
							"enum",
							"module",
							"namespace",
						},
						rust = {
							"impl_item",
							"struct",
							"enum",
							"function",
							"match",
							"loop",
							"for",
							"while",
							"if",
						},
						typescript = {
							"class_declaration",
							"abstract_class_declaration",
							"class_expression",
							"interface_declaration",
							"type_alias_declaration",
							"enum_declaration",
							"method_definition",
							"function_declaration",
							"function_expression",
							"arrow_function",
							"for_statement",
							"while_statement",
							"if_statement",
						},
					},
				},
			},
			{
				-- rainbow 括弧
				"HiPhish/rainbow-delimiters.nvim",
				event = { "BufReadPost", "BufNewFile" },
				config = function()
					local rainbow_delimiters = require("rainbow-delimiters")
					vim.g.rainbow_delimiters = {
						strategy = {
							[""] = rainbow_delimiters.strategy["global"],
							vim = rainbow_delimiters.strategy["local"],
						},
						query = {
							[""] = "rainbow-delimiters",
							lua = "rainbow-blocks",
							javascript = "rainbow-delimiters-react",
							typescript = "rainbow-delimiters-react",
							tsx = "rainbow-delimiters-react",
							jsx = "rainbow-delimiters-react",
						},
						max_file_lines = 1000, -- パフォーマンス向上のための設定
					}
				end,
			},
		},
	},

	-- Treesitterと連携するautopairsプラグイン
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
		},
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "template_string", "string" },
				typescript = { "template_string", "string" },
				jsx = { "jsx_element", "jsx_fragment" },
				tsx = { "tsx_element", "tsx_fragment" },
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
			disable_in_macro = false,
			ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
			enable_moveright = true,
			enable_afterquote = true,
			enable_check_bracket_line = true,
			enable_bracket_in_quote = true,
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)

			-- nvim-cmpとの連携（cmpがインストールされている場合）
			local cmp_ok, cmp = pcall(require, "cmp")
			if cmp_ok then
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end

			-- ルールのカスタマイズ
			local Rule = require("nvim-autopairs.rule")
			local ts_conds = require("nvim-autopairs.ts-conds")

			-- スペースの追加
			npairs.add_rules({
				Rule(" ", " ")
					:with_pair(function(opts)
						local pair = opts.line:sub(opts.col - 1, opts.col)
						return vim.tbl_contains({ "()", "[]", "{}" }, pair)
					end)
					:with_move(function(opts)
						return opts.char == ")"
					end)
					:with_cr(function(opts)
						return false
					end)
					:with_del(function(opts)
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local context = opts.line:sub(col - 1, col + 2)
						return context:match("%( %)") or context:match("%{ %}") or context:match("%[ %]")
					end),
			})

			-- Treesitterを使った条件付きルール
			npairs.add_rules({
				-- コメント内では$を無視
				Rule("$", "$", { "tex", "latex", "markdown" }):with_pair(ts_conds.is_not_ts_node({ "comment" })),

				-- バッククォート内では式展開{}を追加
				Rule("${", "}", { "javascript", "typescript", "javascriptreact", "typescriptreact" }):with_pair(
					ts_conds.is_ts_node({ "template_string" })
				),

				-- JSX/TSXの属性値の引用符重複を防止 (className=""" の問題修正)
				Rule('="', '"', { "typescriptreact", "javascriptreact" }):with_pair(function(opts)
					-- この特殊ケースでは自動ペアリングを無効にする
					return false
				end),

				-- JSX/TSXの特別ルール
				-- Rule("<", ">", { "javascriptreact", "typescriptreact" }):with_pair(
				-- 					ts_conds.is_not_ts_node({ "comment", "string" })
				-- 				),
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = true, -- Auto close on trailing </
				},
				-- Also override individual filetype configs, these take priority.
				-- Empty by default, useful if one of the "opts" global settings
				-- doesn't work well in a specific filetype
				per_filetype = {
					["html"] = {
						enable_close = false,
					},
				},
			})
		end,
	},
}
