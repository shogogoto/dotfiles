return {
	{
		"MeanderingProgrammer/render-markdown.nvim", -- Make sure to set this up properly if you have lazy=true
		opts = {
			file_types = { "markdown", "Avante" },
			indent = {
				enabled = true,
				skip_heading = true,
				icon = "▎",
			},
			-- strikethrough = { enabled = true },
		},
		ft = { "markdown", "Avante" },
		keys = {
			{ "<Space>rm", ":RenderMarkdown toggle<CR>" },
		},
	},
}
