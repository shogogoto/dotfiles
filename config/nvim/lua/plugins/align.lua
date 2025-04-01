--a 整形
return {
	{
		"Wansmer/treesj", -- コードブロックを分割したり結合する
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{ "<leader>sj", "<cmd>TSJToggle<cr>", desc = "Toggle split/join" },
		},
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		opts = { use_default_keymaps = false },
	},
	-- conform.nvim: コードフォーマッタープラグイン
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format buffer",
			},
		},
		opts = {
			-- フォーマッタ設定
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				scss = { { "prettierd", "prettier" } },
				-- markdown = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
				go = { "gofmt", "goimports" },
				rust = { "rustfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
			},
			-- 保存時に自動フォーマット
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			-- フォーマッタ実行コマンドの設定
			formatters = {
				stylua = {
					prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
				},
			},
		},
	},

	-- 別の選択肢: null-ls.nvim
	-- {
	--   "jose-elias-alvarez/null-ls.nvim",
	--   -- event = { "BufReadPre", "BufNewFile" },
	--   dependencies = { "nvim-lua/plenary.nvim" },
	--   opts = function()
	--     local null_ls = require("null-ls")
	--     return {
	--       sources = {
	--         -- Lua
	--         null_ls.builtins.formatting.stylua,
	--         -- Python
	--         null_ls.builtins.formatting.black,
	--         null_ls.builtins.formatting.isort,
	--         -- JavaScript/TypeScript
	--         null_ls.builtins.formatting.prettier.with({
	--           extra_filetypes = { "svelte" },
	--         }),
	--         -- Go
	--         null_ls.builtins.formatting.gofmt,
	--         null_ls.builtins.formatting.goimports,
	--         -- Rust
	--         null_ls.builtins.formatting.rustfmt,
	--         -- C/C++
	--         null_ls.builtins.formatting.clang_format,
	--       },
	--       -- 保存時に自動フォーマット
	--       on_attach = function(client, bufnr)
	--         if client.supports_method("textDocument/formatting") then
	--           vim.api.nvim_create_autocmd("BufWritePre", {
	--             buffer = bufnr,
	--             callback = function()
	--               vim.lsp.buf.format({
	--                 bufnr = bufnr,
	--                 timeout_ms = 2000,
	--               })
	--             end,
	--           })
	--         end
	--       end,
	--     }
	--   end,
	-- },

	-- -- より軽量な選択肢: indent-blankline.nvim (インデントガイド表示)
	-- {
	--   "lukas-reineke/indent-blankline.nvim",
	--   main = "ibl",
	--   -- event = { "BufReadPost", "BufNewFile" },
	--   opts = {
	--     indent = {
	--       char = "│",
	--       tab_char = "│",
	--     },
	--     scope = { enabled = true },
	--     exclude = {
	--       filetypes = {
	--         "help",
	--         "alpha",
	--         "dashboard",
	--         "neo-tree",
	--         "Trouble",
	--         "trouble",
	--         "lazy",
	--         "mason",
	--         "notify",
	--         "toggleterm",
	--         "lazyterm",
	--       },
	--     },
	--   },
	-- },
}
