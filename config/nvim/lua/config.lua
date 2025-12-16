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
		{ "folke/snacks.nvim" },
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

-- Sync clipboard between OS and Neovim.
-- Function to set OSC 52 clipboard
local function set_osc52_clipboard()
	local function my_paste()
		local content = vim.fn.getreg('"')
		return vim.split(content, "\n")
	end

	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = my_paste,
			["*"] = my_paste,
			-- ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			-- ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end

-- Check if the current session is a remote WezTerm session based on the WezTerm executable
local function check_wezterm_remote_clipboard(callback)
	local wezterm_executable = vim.uv.os_getenv("WEZTERM_EXECUTABLE")

	if wezterm_executable and wezterm_executable:find("wezterm-mux-server", 1, true) then
		callback(true) -- Remote WezTerm session found
	else
		callback(false) -- No remote WezTerm session
	end
end

-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard:append("unnamedplus")

	-- Standard SSH session handling
	if vim.uv.os_getenv("SSH_CLIENT") ~= nil or vim.uv.os_getenv("SSH_TTY") ~= nil then
		set_osc52_clipboard()
	else
		check_wezterm_remote_clipboard(function(is_remote_wezterm)
			if is_remote_wezterm then
				set_osc52_clipboard()
			end
		end)
	end
end)
