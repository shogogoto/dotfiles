-- with lazy.nvim
return {
	"LintaoAmons/bookmarks.nvim",
	-- pin the plugin at specific version for stability
	-- backup your bookmark sqlite db when there are breaking changes (major version change)
	tag = "3.2.0",
	dependencies = {
		{ "kkharji/sqlite.lua" },
		{ "nvim-telescope/telescope.nvim" }, -- currently has only telescopes supported, but PRs for other pickers are welcome
		{ "stevearc/dressing.nvim" }, -- optional: better UI
		{ "GeorgesAlkhouri/nvim-aider" }, -- optional: for Aider integration
		{ "anuvyklack/hydra.nvim" },
	},
	config = function()
		local opts = {} -- check the "./lua/bookmarks/default-config.lua" file for all the options
		require("bookmarks").setup(opts) -- you must call setup to init sqlite db
		vim.keymap.set(
			{ "n", "v" },
			"mm",
			"<cmd>BookmarksMark<cr>",
			{ desc = "Mark current line into active BookmarkList." }
		)
		vim.keymap.set(
			{ "n", "v" },
			"mo",
			"<cmd>BookmarksGoto<cr>",
			{ desc = "Go to bookmark at current active BookmarkList" }
		)
		vim.keymap.set(
			{ "n", "v" },
			"ma",
			"<cmd>BookmarksCommands<cr>",
			{ desc = "Find and trigger a bookmark command." }
		)
		vim.keymap.set({ "n", "v" }, "mt", "<cmd>BookmarksTree<cr>", { desc = "Find and trigger a bookmark command." })

		local Hydra = require("hydra")
		Hydra({
			name = "Bookmarks",
			mode = "n",
			body = "<leader>m",
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
}

-- run :BookmarksInfo to see the running status of the plugin
