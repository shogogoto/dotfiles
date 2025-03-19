return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- LSP setup
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Pyright setup
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true
            }
          }
        }
      })


      -- カスタム参照検索関数（選択後に参照一覧を閉じる）
      local function references_with_auto_close()
        vim.lsp.buf.references(nil, {
          on_list = function(options)
            vim.fn.setqflist({}, ' ', options) -- 元の結果を処理
            vim.cmd('copen') -- クイックフィックスリストを開く
            -- EnterキーでQuickFixウィンドウを閉じるマッピングを追加
            vim.api.nvim_create_autocmd("BufWinEnter", {
              pattern = "quickfix",
              once = true,
              callback = function()
                -- vim.api.nvim_buf_set_keymap(0, 'n', '<CR>',
                --   ':<C-u>let qf_index = line(".")<CR><CR>:cclose<CR>:execute qf_index . "cc"<CR>',
                --   {noremap = true, silent = true})
                vim.api.nvim_buf_set_keymap(0, 'n', '<CR>',
                  '<CR><cmd>:cclose<CR>', {noremap = true, silent = true})
              end
            })
          end
        })

      end


      -- LSP keybindings (coc.nvim style)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, noremap = true, silent = true }

          -- coc.nvim like keybindings
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gr', references_with_auto_close, opts)
          vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
    end
  },

  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

     { "hrsh7th/cmp-emoji" },
     -- { "hrsh7th/cmp-buffer" }, -- 現在のバッファの内容を補完候補に含める
     -- { "saadparwaiz1/cmp_luasnip" }, -- LuaSnip と nvim-cmp を統合
     -- { "L3MON4D3/LuaSnip" }, -- スニペットエンジン LuaSnip
     { "rafamadriz/friendly-snippets" }, -- 事前定義されたスニペットコレクション
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" }
        }),
      })
    end
  },

  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },
      })
    end
  },
}

--return {
--  "hrsh7th/nvim-cmp",
--  event = "InsertEnter", -- 挿入モードに入ったときにプラグインをロード
--  dependencies = { -- nvim-cmp に必要な依存プラグイン
--    { "hrsh7th/cmp-emoji" },
--    { "hrsh7th/cmp-buffer" }, -- 現在のバッファの内容を補完候補に含める
--    { "saadparwaiz1/cmp_luasnip" }, -- LuaSnip と nvim-cmp を統合
--    { "L3MON4D3/LuaSnip" }, -- スニペットエンジン LuaSnip
--    { "rafamadriz/friendly-snippets" }, -- 事前定義されたスニペットコレクション
--  },
--  config = function()
--      -- nvim-cmp の設定
--      local cmp = require("cmp") -- nvim-cmp のメインモジュールをロード
--      local luasnip = require("luasnip") -- LuaSnip のモジュールをロード
--      require("luasnip/loaders/from_vscode").lazy_load() -- VSCode スタイルのスニペットをロード

--      cmp.setup({
--          snippet = {
--              -- スニペット展開方法を定義
--              expand = function(args)
--                  luasnip.lsp_expand(args.body) -- LuaSnip を使ってスニペットを展開
--              end,
--          },
--          mapping = cmp.mapping.preset.insert({
--              ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 補完候補のドキュメントを上にスクロール
--              ["<C-f>"] = cmp.mapping.scroll_docs(4), -- 補完候補のドキュメントを下にスクロール
--              ["<C-Space>"] = cmp.mapping.complete(), -- 手動で補完候補を表示
--              ["<C-e>"] = cmp.mapping.abort(), -- 補完を中断して閉じる
--              ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 補完確定 (現在選択中の候補を使用)
--          }),
--          sources = cmp.config.sources({
--              { name = "luasnip", priority_weight = 20 }, -- LuaSnip を補完候補に含める
--          }, {
--              { name = "buffer" }, -- バッファの内容を補完候補に含める
--          }),
--      })
--  end,
--  ---@param opts cmp.ConfigSchema
--  -- opts = function(_, opts)
--  --   table.insert(opts.sources, { name = "emoji" })
--  -- end,
--}
