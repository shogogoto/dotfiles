-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
		{ "nacro90/numb.nvim", opts = {} }, -- :行番号で行き先を表示
		{ "jghauser/mkdir.nvim" }, -- Vim起動時や:editしたときに存在しないディレクトリを指定すると勝手にmkdir
		-- { "tpope/vim-commentary" },
		-- japanese
		{ "vim-jp/vimdoc-ja", lazy = true, keys = { { "h", mode = "c" } } },
		{
			"sei40kr/migemo-search.nvim", -- 日本語検索
			event = "CmdlineEnter",
			config = function()
				local ms = require("migemo-search")
				ms.setup({
					cmigemo_exec_path = "/usr/bin/cmigemo",
					migemo_dict_path = "/usr/share/cmigemo/utf-8/migemo-dict",
				})
				vim.keymap.set("c", "<CR>", ms.cr) -- ここのせいでkeys使えない
			end,
		},
		-- text object
		{ "tpope/vim-surround" },
		{ "machakann/vim-sandwich" },
		-- colorscheme
		{ "ntk148v/habamax.nvim", dependencies = { "rktjmp/lush.nvim" } },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = {
		missing = true,
		colorscheme = { "habamax" },
	},
	-- automatically check for plugin updates
	checker = { enabled = true },
})

vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
