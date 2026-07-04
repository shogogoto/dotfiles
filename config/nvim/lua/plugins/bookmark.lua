return {
	{
		"LintaoAmons/bookmarks.nvim",
		-- pin the plugin at specific version for stability
		-- backup your bookmark sqlite db when there are breaking changes (major version change)
		tag = "v4.0.0",
		dependencies = {
			{ "kkharji/sqlite.lua" },
			-- picker backend (choose one):
			-- { "folke/snacks.nvim" }, -- default picker backend
			{ "nvim-telescope/telescope.nvim" }, -- set picker.picker_backend = "telescope" to use
			{ "anuvyklack/hydra.nvim" },
		},
		config = function()
			-- check the "./lua/bookmarks/default-config.lua" file for all the options
			local opts = {
				picker = {
					picker_backend = "telescope", -- "snacks" (default) or "telescope"
				},
			}

			require("bookmarks").setup(opts) -- you must call setup to init sqlite db
      -- stylua: ignore start
			vim.keymap.set({ "n", "v" }, "mm", "<cmd>BookmarksMark<cr>", { desc = "Mark current line into active BookmarkList." })
			vim.keymap.set({ "n", "v" }, "mo", "<cmd>BookmarksGoto<cr>", { desc = "Go to bookmark at current active BookmarkList" })
			vim.keymap.set({ "n", "v" }, "ma", "<cmd>BookmarksCommands<cr>", { desc = "Find and trigger a bookmark command." })
			vim.keymap.set({ "n", "v" }, "md", "<cmd>BookmarksDesc<cr>", { desc = "Add description to bookmark under cursor." })
			vim.keymap.set({ "n", "v" }, "ml", "<cmd>BookmarksLists<cr>", { desc = "Pick a bookmark list." })
			vim.keymap.set({ "n", "v" }, "mt", "<cmd>BookmarksTree<cr>", { desc = "Browse bookmarks in tree view." })
			-- stylua: ignore end
			-- use `nvimtools/hydra.nvim`: https://github.com/anuvyklack/hydra.nvim/issues/104
			local Hydra = require("hydra")
			Hydra({
				name = "Bookmarks",
				mode = "n",
				body = "<leader>bm",
				hint = [[
  Bookmark Navigation

  ^  _j_: Next in List     _J_: Next Bookmark
  ^  _k_: Prev in List     _K_: Prev Bookmark
  ^
  ^ _<Esc>_: Exit
  ]],
				heads = {
					{ "j", "<cmd>BookmarksGotoNextInList<cr>" },
					{ "k", "<cmd>BookmarksGotoPrevInList<cr>" },
					{ "J", "<cmd>BookmarksGotoNext<cr>" },
					{ "K", "<cmd>BookmarksGotoPrev<cr>" },
				},
			})
		end,
	},
}
