-- lazy.nvim example https://lazy.folke.io/spec/examples
return {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end
}
-- return {
--     {
--         'maxmx03/fluoromachine.nvim',
--         lazy = false,
--         priority = 1000,
--         config = function ()
--          local fm = require 'fluoromachine'

--          fm.setup {
--             overrides = {
--                ['@type'] = { italic = true, bold = false },
--                ['@function'] = { italic = false, bold = false },
--                ['@comment'] = { italic = true },
--                ['@keyword'] = { italic = false },
--                ['@constant'] = { italic = false, bold = false },
--                ['@variable'] = { italic = true },
--                ['@field'] = { italic = true },
--                ['@parameter'] = { italic = true },
--            }
--         }
--         -- fm.setup {
--         --     glow = true,
--         --     theme = 'fluoromachine',
--         --     transparent = true,
--         --  }

--          vim.cmd.colorscheme 'fluoromachine'
--         end
--     }
-- }
