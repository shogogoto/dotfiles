return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		
		npairs.setup({
			check_ts = true,
			ts_config = {
				javascript = { "template_string" },
				typescript = { "template_string" },
				typescriptreact = { "template_string" }
			}
		})

		-- cmpとの連携
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end
}
