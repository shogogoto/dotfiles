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
      { "<leader>f", function() vim.lsp.buf.format { async = true } end, desc = "Format" },
      -- 新しいruffでのインポート整理を呼び出し
      { "<leader>ro", function() vim.cmd("RuffOrganizeImports") end, desc = "Organize imports with ruff" },
    },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim", -- Neovim APIの補完を強化（オプション）
    },
    config = function()
      require("neodev").setup()
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
      -- LSP機能を補完に追加
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- ts_lsの設定
      lspconfig.ts_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            suggest = {
              autoImports = true,
            },
          },
        },
      }
      
      
    end,
  },  -- end of nvim-lspconfig
  
  -- 補完エンジン
  { "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
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
          { name = "buffer" },
          { name = "path" },
        }),
        completion = {
          completeopt = "menu,menuone,noinsert",
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
        sources = {
          { name = "buffer" }
        }
      })
    end,
  },
}
