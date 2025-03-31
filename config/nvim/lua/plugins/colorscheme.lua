-- lazy.nvim example https://lazy.folke.io/spec/examples
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme tokyonight]])
	end,
}
