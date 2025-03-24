return {
  { "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
      { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover information" },
      { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
      { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },
      { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
      { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
      { "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "List workspace folders" },
      { "<leader>D", vim.lsp.buf.type_definition, desc = "Type definition" },
      { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
      { "gr", vim.lsp.buf.references, desc = "References" },
      { "<leader>fm", function() vim.lsp.buf.format { async = true } end, desc = "Format" },
      -- 新しいruffでのインポート整理を呼び出し
      { "<leader>ro", function() vim.cmd("RuffOrganizeImports") end, desc = "Organize imports with ruff" },
    },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim", -- Neovim APIの補完を強化（オプション）
    },
    config = function()
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          plugins = true,
          types = true,
        },
      })
      local lspconfig = require("lspconfig")
      local on_attach = function(client, bufnr) -- 共通のon_attach関数
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities() -- LSP機能を補完に追加
    end,
  },


  { "hrsh7th/nvim-cmp", -- 補完エンジン
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      { "L3MON4D3/LuaSnip"},
      "rafamadriz/friendly-snippets", -- cocでも使える
      -- スニペット共存
      { "quangnguyen30192/cmp-nvim-ultisnips" }, -- cmp と UltiSnips の連携プラグイン
      { "SirVer/ultisnips" }, -- スニペットエンジン
      { "honza/vim-snippets" }, -- スニペット集
      "hrsh7th/cmp-nvim-lsp", -- LSP補完
      "onsails/lspkind-nvim", -- アイコン表示
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
      local lspkind = require("lspkind")
       -- UltiSnips スニペットディレクトリを設定
      vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath("data") .. "/lazy/vim-snippets/UltiSnips" }
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 補完候補のドキュメントを上にスクロール
          ["<C-f>"] = cmp.mapping.scroll_docs(4), -- 補完候補のドキュメントを下にスクロール
          ["<C-e>"] = cmp.mapping.abort(), -- 補完を中断して閉じる
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 補完確定 (現在選択中の候補を使用)
          -- ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            -- if cmp.visible() then
            --   cmp.select_next_item()
            -- elseif luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
            -- else
            --   fallback()
            -- end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            cmp_ultisnips_mappings.jump_backwards(fallback)
            -- if cmp.visible() then
            --   cmp.select_prev_item()
            -- elseif luasnip.jumpable(-1) then
            --   luasnip.jump(-1)
            -- else
            --   fallback()
            -- end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "luasnip", priority_weight = 20 },-- LuaSnip を補完候補に含める
          { name = "ultisnips", priority_weight = 10 },-- UltiSnips を補完候補に含める
          { name = "buffer" },
          { name = "path" },
        }),
        completion = { completeoht = "menu,menuone,noinsert" },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            menu = { -- 補完候補の由来を表示
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                path = "[Path]",
                vsnip = "[Snippet]",
            },
          }),
        },
      })
      cmp.setup.cmdline(":", { -- コマンドライン補完の設定
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" }
        })
      })
      cmp.setup.cmdline("/", { -- 検索補完の設定
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } }
      })
    end,
  },
}
