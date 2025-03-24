return {
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "lua", "python", "typescript", "javascript", "terraform" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    dependencies = {
      -- テキストオブジェクト
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- このプラグインがロードされる前にハイライトモジュールを無効化して最適化
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = opts.textobjects.move.enable
          opts.textobjects.move.enable = false

          vim.api.nvim_create_autocmd("BufReadPost", {
            callback = function()
              local bufnr = vim.api.nvim_get_current_buf()
              vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                  opts.textobjects.move.enable = enabled
                  require("nvim-treesitter.configs").setup(opts)
                end
              end, 100)
            end,
          })
        end,
      },

      -- コンテキスト表示
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true,
          max_lines = 3,
          min_window_height = 10,
          line_numbers = true,
          multiline_threshold = 5,
          trim_scope = "outer",
          patterns = {
            default = {
              "class", "function", "method", "for", "while",
              "if", "switch", "case", "interface", "struct",
              "enum", "module", "namespace"
            },
            rust = {
              "impl_item", "struct", "enum", "function", "match",
              "loop", "for", "while", "if"
            },
            typescript = {
              "class_declaration", "abstract_class_declaration", "class_expression",
             "interface_declaration", "type_alias_declaration", "enum_declaration",
              "method_definition", "function_declaration", "function_expression",
              "arrow_function", "for_statement", "while_statement", "if_statement"
            },
          },
        },
      },

      -- コメントプラグイン連携
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
          enable_autocmd = false,
          languages = {
            typescript = { __default = '// %s', __multiline = '/* %s */' },
            javascript = { __default = '// %s', __multiline = '/* %s */' },
            css = '/* %s */',
            scss = '/* %s */',
            html = '<!-- %s -->',
            svelte = '<!-- %s -->',
            vue = '<!-- %s -->',
            astro = '<!-- %s -->',
            handlebars = '{{!-- %s --}}',
            glimmer = '{{!-- %s --}}',
            graphql = '# %s',
            lua = '-- %s',
            python = '# %s',
            rust = '// %s',
            go = '// %s',
          },
        },
      },

      -- プレイグラウンド
      {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
        keys = {
          { "<leader>tp", "<cmd>TSPlaygroundToggle<cr>", desc = "Treesitter Playground" },
          { "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<cr>", desc = "TS Highlight Capture" },
        },
      },

      -- 自動タグ閉じ
      -- {
      --   "windwp/nvim-ts-autotag",
      --   event = "InsertEnter",
      --   opts = {
      --     enable = true,
      --     enable_rename = true,
      --     enable_close = true,
      --     enable_close_on_slash = true,
      --     filetypes = {
      --       "html", "xml", "javascript", "javascriptreact", "typescript",
      --       "typescriptreact", "svelte", "vue", "tsx", "jsx", "rescript",
      --       "php", "markdown", "astro", "handlebars", "hbs"
      --     },
      --   },
      -- },

      -- rainbow 括弧
      {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
          local rainbow_delimiters = require("rainbow-delimiters")

          vim.g.rainbow_delimiters = {
            strategy = {
              [""] = rainbow_delimiters.strategy["global"],
              vim = rainbow_delimiters.strategy["local"],
            },
            query = {
              [""] = "rainbow-delimiters",
              lua = "rainbow-blocks",
              javascript = "rainbow-delimiters-react",
              typescript = "rainbow-delimiters-react",
              tsx = "rainbow-delimiters-react",
              jsx = "rainbow-delimiters-react",
            },
            highlight = {
              "RainbowDelimiterRed",
              "RainbowDelimiterYellow",
              "RainbowDelimiterBlue",
              "RainbowDelimiterOrange",
              "RainbowDelimiterGreen",
              "RainbowDelimiterViolet",
              "RainbowDelimiterCyan",
            },
          }
        end,
      },

      -- Treesitter補強プラグイン
      -- {
      --   "nvim-treesitter/nvim-treesitter-refactor",
      --   opts = {
      --     highlight_definitions = {
      --       enable = true,
      --       clear_on_cursor_move = true,
      --     },
      --     smart_rename = {
      --       enable = true,
      --       keymaps = {
      --         smart_rename = "grr",
      --       },
      --     },
      --     navigation = {
      --       enable = true,
      --       keymaps = {
      --         goto_definition = "gnd",
      --         list_definitions = "gnD",
      --         list_definitions_toc = "gO",
      --         goto_next_usage = "<a-*>",
      --         goto_previous_usage = "<a-#>",
      --       },
      --     },
      --   },
      -- },
    },
    keys = {
      { "<leader>ti", "<cmd>TSConfigInfo<cr>", desc = "Treesitter Info" },
      { "<leader>tu", "<cmd>TSUpdate<cr>", desc = "Update Parsers" },
      { "<leader>tU", "<cmd>TSUpdateSync<cr>", desc = "Update Parsers (Sync)" },
    },
    opts = {
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gss",
          node_incremental = "gsn",
          scope_incremental = "gsc",
          node_decremental = "gsm",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- 関数周り
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["am"] = "@method.outer",
            ["im"] = "@method.inner",

            -- コード構造
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["as"] = "@statement.outer",
            ["is"] = "@statement.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",

            -- コメント/ドキュメント
            ["a/"] = "@comment.outer",
            ["i/"] = "@comment.inner",
            ["ad"] = "@doc.outer",
            ["id"] = "@doc.inner",

            -- その他
            ["ar"] = "@regex.outer",
            ["ir"] = "@regex.inner",
            ["an"] = "@number.outer",
            ["in"] = "@number.inner",
            ["aj"] = "@json.outer",
            ["ij"] = "@json.inner",
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]m"] = "@method.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
            ["]s"] = "@statement.outer",
            ["]a"] = "@parameter.outer",
            ["]/"] = "@comment.outer",
            ["]o"] = "@block.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]M"] = "@method.outer",
            ["]I"] = "@conditional.outer",
            ["]L"] = "@loop.outer",
            ["]S"] = "@statement.outer",
            ["]A"] = "@parameter.outer",
            ["]/"] = "@comment.outer",
            ["]O"] = "@block.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[m"] = "@method.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
            ["[s"] = "@statement.outer",
            ["[a"] = "@parameter.outer",
            ["[/"] = "@comment.outer",
            ["[o"] = "@block.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[M"] = "@method.outer",
            ["[I"] = "@conditional.outer",
            ["[L"] = "@loop.outer",
            ["[S"] = "@statement.outer",
            ["[A"] = "@parameter.outer",
            ["[/"] = "@comment.outer",
            ["[O"] = "@block.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sa"] = "@parameter.inner",
            ["<leader>sf"] = "@function.outer",
            ["<leader>sm"] = "@method.outer",
          },
          swap_previous = {
            ["<leader>SA"] = "@parameter.inner",
            ["<leader>SF"] = "@function.outer",
            ["<leader>SM"] = "@method.outer",
          },
        },
        lsp_interop = {
          enable = true,
          border = "rounded",
          floating_preview_opts = {},
          peek_definition_code = {
            ["<leader>pf"] = "@function.outer",
            ["<leader>pc"] = "@class.outer",
            ["<leader>pm"] = "@method.outer",
          },
        },
      },
      matchup = {
        enable = true,
        disable_virtual_text = false,
        include_match_words = true,
      },
      ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "bash", "c", "cpp", "css", "dockerfile", "go", "gomod", "gosum", "gowork",
        "html", "javascript", "jsdoc", "json", "jsonc", "python", "regex", "rust",
        "toml", "tsx", "typescript", "yaml", "markdown", "markdown_inline",
        "comment", "gitignore", "gitcommit", "diff", "git_rebase", "make", "sql",
        "php", "svelte", "vue", "graphql", "hcl", "java", "kotlin",
        "http", "ini", "terraform", "zig", "r", "ruby", "scala", "scss", "solidity"
      },
    },
    config = function(_, opts)
      -- 追加のハイライト用のグループを設定
      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })

      -- Treesitterモジュールの設定
      require("nvim-treesitter.configs").setup(opts)

      -- 折りたたみ設定
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false  -- 初期状態では折りたたみを無効化
      vim.opt.foldlevel = 99

      -- -- 依存プラグインのrefactorとの連携
      -- if vim.o.ft == "tsx" or vim.o.ft == "jsx" or vim.o.ft == "typescript" or vim.o.ft == "javascript" then
      --   local refactor_opts = require("nvim-treesitter.configs").get_module("refactor")
      --   refactor_opts.navigation.keymaps.goto_next_usage = "<a-]>"
      --   refactor_opts.navigation.keymaps.goto_previous_usage = "<a-[>"
      --   require("nvim-treesitter.configs").setup({ refactor = refactor_opts })
      -- end

      -- matchup プラグインとの連携 (matchupがインストールされている場合)
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- TreesitterとCommentプラグインとの連携用
  {
    "numToStr/Comment.nvim",
    -- event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        mappings = {
          basic = true,
          extra = true,
        },
      }
    end,
  },

  -- Treesitterと連携するautopairsプラグイン
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "template_string", "string" },
        typescript = { "template_string", "string" },
        jsx = { "jsx_element", "jsx_fragment" },
        tsx = { "tsx_element", "tsx_fragment" },
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
      disable_in_macro = false,
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      -- nvim-cmpとの連携（cmpがインストールされている場合）
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end

      -- ルールのカスタマイズ
      local Rule = require("nvim-autopairs.rule")
      local ts_conds = require("nvim-autopairs.ts-conds")

      -- スペースの追加
      npairs.add_rules({
        Rule(" ", " ")
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({ "()", "[]", "{}" }, pair)
          end)
          :with_move(function(opts)
            return opts.char == ")"
          end)
          :with_cr(function(opts)
            return false
          end)
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return context:match("%( %)")
              or context:match("%{ %}")
              or context:match("%[ %]")
          end)
      })

      -- Treesitterを使った条件付きルール
      npairs.add_rules({
        -- コメント内では$を無視
        Rule("$", "$", { "tex", "latex", "markdown" })
          :with_pair(ts_conds.is_not_ts_node({ "comment" })),

        -- バッククォート内では式展開{}を追加
        Rule("${", "}", { "javascript", "typescript", "javascriptreact", "typescriptreact" })
          :with_pair(ts_conds.is_ts_node({ "template_string" })),

        -- JSX/TSXの特別ルール
        Rule("<", ">", { "javascriptreact", "typescriptreact" })
          :with_pair(ts_conds.is_not_ts_node({ "comment", "string" })),
      })
    end,
  },
}
