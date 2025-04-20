local js_formatters = { "biome-check", "biome" }

return {
	{
		"stevearc/conform.nvim",
		-- events = "VeryLazy",
		config = function()
			local conform = require("conform").setup({
				-- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
					html = js_formatters,
					css = js_formatters,
					json = js_formatters,
					python = { "ruff_fix", "ruff_format" },
					["*"] = { "codespell" },
					["_"] = { "trim_whitespace" },
				},
				formatters = {
					["biome-check"] = {
						prepend_args = { "--unsafe" },
					},
				},
				-- stop_after_first = false,
				-- default_format_opts = {
				--   lsp_format = "fallback",
				-- },

				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = {
					lsp_format = "fallback",
					timeout_ms = 500,
				},
			})

			vim.keymap.set("n", "<leader>fm", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format" })
		end,
	},
	{
		"ntpeters/vim-better-whitespace",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.g.better_whitespace_enabled = 1 -- 空白文字のハイライトを有効にする
			vim.g.strip_whitespace_on_save = 1 -- 保存時に自動的に空白を削除する
			vim.g.strip_whitespace_confirm = 0 -- 確認なしで空白を削除する
			-- 無視するファイルタイプ
			vim.g.better_whitespace_filetypes_blacklist = {
				"diff",
				"git",
				"gitcommit",
				"unite",
				"qf",
				"help",
				"markdown",
				"fugitive",
				"TelescopePrompt",
			}
			vim.g.better_whitespace_ctermcolor = "red"
			vim.g.better_whitespace_guicolor = "#FF5555"
		end,
		keys = {
			{ "<leader>ws", "<cmd>StripWhitespace<CR>", desc = "空白文字を削除" },
			{ "<leader>wt", "<cmd>ToggleWhitespace<CR>", desc = "空白文字のハイライト表示を切り替え" },
		},
	},
	{
		"williamboman/mason.nvim", -- LSPのインストール管理
		opts = {
			ui = {
				icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
			},
		},
		keys = { { "<leader>m", "<cmd>Mason<CR>", desc = "Mason Package Manager Menu" } },
		dependencies = {},
	},
	{ -- masonのdepsに入れたかったけどauto install 走らなくなった
		-- 自動インストールどっちもできる
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- "williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				--lua
				"stylua",
				-- "lua-language-server", --"lua_ls",
				"luacheck",
				-- python
				"pyright",
				"ruff", -- formatter
				"pyproject-flake8",
				-- typescript
				"typescript-language-server", --"ts_ls",
				"biome",
				-- "eslint-lsp",
				-- "eslint_d",
				-- "prettier",
				"bash-language-server", --"bashls",
				"dockerfile-language-server", --"dockerls",
				"docker-compose-language-service", -- "docker_compose_language_service",
				"cypher-language-server", --"cypher_ls",
				"vim-language-server", --"vimls",
				-- text
				"json-lsp", -- "jsonls",
				"yaml-language-server", --"yamlls",
				-- markdown
				-- "markdown-toc",
				-- "markdownlint",

				"cspell",
				"copilot-language-server",
			},
			auto_update = true,
			run_on_start = true,
			-- automatic_installation = true,
		},
	},
}
