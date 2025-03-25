local symbols = require("user.symbols")
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      theme = "evil_lualine",
      options = {
        icons_enabled = true,
        theme = cozynight,
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
        lualine_x = { "copilot", "encoding", "fileformat", "filetype" }, -- I added copilot here
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
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "arkav/lualine-lsp-progress", -- どのLSPを使っているか表示
    opts = {
      sections = {
        lualine_c = {
          "filename",
          {
            "lsp_progress",
            display_components = { "lsp_client_name", { "title", "percentage", "message" } },
            -- With spinner
            -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
            -- colors = {
            --   percentage = colors.cyan,
            --   title = colors.cyan,
            --   message = colors.cyan,
            --   spinner = colors.cyan,
            --   lsp_client_name = colors.magenta,
            --   use = true,
            -- },
            separators = {
              component = " ",
              progress = " | ",
              message = { pre = "(", post = ")" },
              percentage = { pre = "", post = "%% " },
              title = { pre = "", post = ": " },
              lsp_client_name = { pre = "[", post = "]" },
              spinner = { pre = "", post = "" },
              message = { commenced = "In Progress", completed = "Completed" },
            },
            display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
            timer = {
              progress_enddelay = 500,
              spinner = 1000,
              lsp_client_name_enddelay = -1, -- 常に表示
            },
            spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
          },
        },
      },
    },
  },
  -- { "j-hui/fidget.nvim", opts = {} },
}
