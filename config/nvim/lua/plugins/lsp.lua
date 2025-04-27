return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
			{ "gd", vim.lsp.buf.definition, desc = "Go to definition" },
			{ "K", vim.lsp.buf.hover, desc = "Hover information" },
			{ "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
			{ "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },
			{ "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
			{ "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
			{
				"<leader>wl",
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				desc = "List workspace folders",
			},
			{ "<leader>D", vim.lsp.buf.type_definition, desc = "Type definition" },
			{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
			-- { "gr",         vim.lsp.buf.references,      desc = "References" },
		},
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{
				"folke/lazydev.nvim", -- LuaLS簡単セットアップ
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
						"lazy.nvim",
					},
					integrations = { cmp = true, dap = true, lsp = true, treesitter = true },
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities({
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
					fileOperations = {
						dynamicRegistration = true,
						didCreate = true,
						didRename = true,
						didDelete = true,
					},
				},
				dynamicRegistration = true,
			}) -- LSP機能を補完に追加
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = { diagnostics = { globals = { "vim", "require" } } }, -- Neovim変数を認識させる
				},
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				settings = {
					-- ref https://microsoft.github.io/pyright/#/settings
					pyright = {
						-- disableOrganizeImports = true, -- Using Ruff's import organizer
						-- disableTaggedHints = false,
						watchFiles = true,
						watchFileKinds = { "SourceAndConfig" },
					},
					python = {
						analysis = {
							autoImportCompletions = true, -- 追加: 補完時に自動import
							autoSearchPaths = true, -- 追加: パスを自動検索
							diagnosticMode = "workspace", -- openFilesOnly, workspace(これじゃないと補完が効かない)
							diagnosticSeverityOverrides = {
								reportUnknownMemberType = "none",
								reportUnknownVariableType = "none",
								reportUnknownArgumentType = "none",
							},
							useLibraryCodeForTypes = true, -- 追加: ライブラリの型情報を使用
							--unused import, var などをエラーにするのはstrictだけ
							typeCheckingMode = "standard", -- basic, standard, strict, off:vscode_package_collections
							-- ignore = { "*" },
							-- ignore = { "reportUnknownMemberType" },
						},
					},
				},
			})
			lspconfig.ruff.setup({
				capabilities = capabilities,
				-- cmd = { ".venv/bin/ruff", "server" }, -- venvでなくてもpyproject認識する
				init_options = {
					-- https://docs.astral.sh/ruff/editors/settings
					-- configuration
					configurationPreferebce = "filesystemFirst",
					settings = {
						-- logLevel = "ERROR",
						lint = { preview = true }, -- default: null
						format = { preview = true }, -- default: null
					},
				},
			})
			lspconfig.taplo.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				init_options = {
					preferences = {
						unused = {
							disableUnusedMembersForProperties = true,
							ignoreEnums = true,
						},
						watchOptions = {
							watchFile = "useFsEvents",
							watchDirectory = "useFsEvents",
							fallbackPolling = "dynamicPriority",
						},
					},
				},
			})
			lspconfig.biome.setup({
				capabilities = capabilities,
				init_options = {
					format = { enable = true },
					validate = { enable = true },
				},
			})
			-- lspconfig.jsonls.setup({
			-- 	capabilities = capabilities,
			-- 	settings = {
			-- 		json = {
			-- 			schemas = {
			-- 				{
			-- 					fileMatch = { "package.json" },
			-- 					url = "https://json.schemastore.org/package.json",
			-- 				},
			-- 				{
			-- 					fileMatch = { "tsconfig.json", "tsconfig.*.json" },
			-- 					url = "https://json.schemastore.org/tsconfig.json",
			-- 				},
			-- 				-- 他のJSONスキーマも必要に応じて追加
			-- 			},
			-- 			validate = { enable = true },
			-- 			format = { enable = true },
			-- 		},
			-- 	},
			-- })
			----------------------------------------------------------------------------------------------
		end,
	},
	{
		"hrsh7th/nvim-cmp", -- 補完エンジン
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			-- for vsnip
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			-- for lua
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets", -- cocでも使える
			{ "honza/vim-snippets" }, -- スニペット集
			"hrsh7th/cmp-nvim-lsp", -- LSP補完
			"onsails/lspkind-nvim", -- アイコン表示
			--   For mini.snippets users.
			-- "echasnovski/mini.snippets",
			-- "abeldekat/cmp-mini-snippets",

			-- For snippy users.
			-- "dcampos/nvim-snippy",
			-- "dcampos/cmp-snippy",

			-- ultisnips = snipet管理
			{ "quangnguyen30192/cmp-nvim-ultisnips" }, -- cmp と UltiSnips の連携プラグイン
			{ "SirVer/ultisnips" }, -- スニペットエンジン
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
			local lspkind = require("lspkind")
			-- UltiSnips スニペットディレクトリを設定
			vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath("data") .. "/lazy/vim-snippets/UltiSnips" }
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require("snippy").expand_snippet(args.body) -- For `snippy` users.
						vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

						-- For `mini.snippets` users:
						local MiniSnippets = require("mini.snippets")
						local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
						insert({ body = args.body }) -- Insert at cursor
						cmp.resubscribe({ "TextChangedI", "TextChangedP" })
						require("cmp.config").set_onetime({ sources = {} })
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 補完候補のドキュメントを上にスクロール
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- 補完候補のドキュメントを下にスクロール
					["<C-e>"] = cmp.mapping.abort(), -- 補完を中断して閉じる
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- 補完確定 (現在選択中の候補を使用)
					-- ["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping(function(fallback)
						cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						cmp_ultisnips_mappings.jump_backwards(fallback)
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip", priority_weight = 20 }, -- LuaSnip を補完候補に含める
					{ name = "ultisnips", priority_weight = 10 }, -- UltiSnips を補完候補に含める
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "ultisnips" }, -- For ultisnips users.
					-- { name = "vsnip" }, -- For snippy users.
					-- { name = "snippy" }, -- For snippy users.
				}, { -- この区切り意味不明
					{ name = "buffer" },
					{ name = "path" },
				}),
				completion = { completeoht = "menu,menuone,noinsert" },
				formatting = {
					-- expandable_indicato = "▶",
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						menu = { -- 補完候補の由来を表示
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							path = "[Path]",
							vsnip = "[Snippet]",
						},
					}),
				},
			})
			cmp.setup.cmdline(":", { -- コマンドライン補完の設定
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "cmdline" },
				}),
			})
			cmp.setup.cmdline("/", { -- 検索補完の設定
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})
		end,
	},
	{
		-- buffer line下にガイドを表示してくれたり色々LSP強化
		"nvimdev/lspsaga.nvim",
		config = function()
			-- https://nvimdev.github.io/lspsaga/
			require("lspsaga").setup({
				diagnostic = { max_height = 0.8, keys = { quit = { "q", "<ESC>" } } },
				lightbulb = { sign = false }, -- 行番号のところの表示を消す 画面が揺れないように
				outline = {
					win_position = "left",
					cloese_after_jump = true,
					keys = { jump = "<CR>", quit = "q", toggle_or_jump = "l" },
				},
			})
			-- なぜか keys, optsが使えない
			vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
			vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc") -- 関数のdocなどfloatで表示
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
	{
		-- 関数詳細を表示
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
		},
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		opts = {},
		config = function(_, opts)
			vim.keymap.set("x", "<leader>re", ":Refactor extract ")
			vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
			vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
			vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
			vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
			vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
			vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
		end,
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		opts = {}, -- your configuration
	},
}
