local symbols = require("user.symbols")
return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local prose = require("nvim-prose")
			local function get_char_count()
				local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
				local text = table.concat(lines, "\n")
				return vim.fn.strchars(text) .. " chars"
			end
			require("lualine").setup({
				theme = "evil_lualine",
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {},
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						"branch",
						"diff",
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = symbols,
						},
					},
					lualine_c = { "filename" },
					lualine_x = {
						"copilot",
						"encoding",
						"fileformat",
						"filetype",
						{ get_char_count },
						-- { prose.word_count, cond = prose.is_available },
						-- { prose.reading_time, cond = prose.is_available },
					}, -- I added copilot here
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{
				"arkav/lualine-lsp-progress", -- どのLSPを使っているか表示
				opts = {
					sections = {
						lualine_c = {
							"filename",
							{
								"lsp_progress",
								separators = {
									component = " ",
									progress = " | ",
									-- message = { pre = "(", post = ")" },
									percentage = { pre = "", post = "%% " },
									title = { pre = "", post = ": " },
									lsp_client_name = { pre = "[", post = "]" },
									spinner = { pre = "", post = "" },
									message = { commenced = "In Progress", completed = "Completed" },
								},
								display_components = {
									"lsp_client_name",
									"spinner",
									{ "title", "percentage", "message" },
								},
								timer = {
									progress_enddelay = 500,
									spinner = 1000,
									lsp_client_name_enddelay = -1, -- 常に表示
								},
								spinner_symbols = {
									"🌑 ",
									"🌒 ",
									"🌓 ",
									"🌔 ",
									"🌕 ",
									"🌖 ",
									"🌗 ",
									"🌘 ",
								},
							},
						},
					},
				},
			},
			-- { "j-hui/fidget.nvim", opts = {} },
			{
				"skwee357/nvim-prose",
				opts = {
					wpm = 200.0,
					filetypes = { "markdown", "asciidoc" },
					placeholders = {
						words = "words",
						minutes = "min",
					},
				},
			},
		},
	},
}
