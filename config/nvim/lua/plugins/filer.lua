return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      { "s1n7ax/nvim-window-picker", -- 既存の分割ウィンドウを指定してopen
        config = function()
          require("window-picker").setup({
            autoselect_one = true,
            include_current = true,
            filter_rules = {
              bo = {
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                buftype = { "terminal", "quickfix" }
              }
            },
            other_win_hl_color = "#e35e4f",
          })
        end
      },

      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { "<Leader>ee", "<cmd>Neotree position=left toggle reveal_force_cwd<CR>", mode = "n", desc = "ファイラー開く" },
      { "<Leader>ef", "<cmd>Neotree position=float toggle reveal_force_cwd<CR>", mode = "n", desc = "フロートでファイラー開く" },
    },
    opts = {
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      filesystem = {
        follow_current_file = true,
        use_libuv_file_watcher = true,
        expand_root = true,
        -- hijack_netrw_behavior = "open_current",
        window = {
          position = "float",
          width = 30,
          mappings = {
            ["<cr>"] = "open_with_window_picker",
            ["l"] = "open_with_window_picker", -- override "focus_preview" to similar to fern.vim
            ["s"] = "split_with_window_picker",
            ["v"] = "vsplit_with_window_picker",
            ["h"] = "close_node",
            ['oa'] = 'avante_add_files',
          }
        },
        commands = {
          avante_add_files = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local relative_path = require('avante.utils').relative_path(filepath)
            local sidebar = require('avante').get()
            local open = sidebar:is_open()
            -- ensure avante sidebar is open
            if not open then
              require('avante.api').ask()
              sidebar = require('avante').get()
            end

            sidebar.file_selector:add_selected_file(relative_path)

            -- remove neo tree buffer
            if not open then
              sidebar.file_selector:remove_selected_file('neo-tree filesystem [1]')
            end
          end,
        },
      },
    },
    init = function() -- netrwを無効化
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- vi 単体で開く画面
  {
    "goolord/alpha-nvim",
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- local name = "alpha.themes.startify"
      -- local name = "alpha.themes.dashboard"
      local name = "alpha.themes.theta"
      local theme = require(name)
      -- theme.file_icons.provider = "devicons" -- available: devicons, mini, default is mini
      require("alpha").setup(theme.config)
    end,
  },
}
