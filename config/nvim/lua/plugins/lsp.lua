return {
  { "neovim/nvim-lspconfig",
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim", -- Neovim APIの補完を強化（オプション）
    },
    config = function()
      require("neodev").setup()
      local lspconfig = require("lspconfig")
      local on_attach = function(client, bufnr) -- 共通のon_attach関数
        -- フォーマット時の設定
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
      -- Python (pyright) - Poetry環境対応
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        before_init = function(_, config)
          local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p 2>/dev/null"))
          if vim.v.shell_error == 0 and poetry_venv ~= "" then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = poetry_venv .. "/bin/python"
            config.settings.python.venvPath = poetry_venv:match("(.*/)")
            config.settings.python.venv = poetry_venv:match(".*/(.*)$")
          end
        end,
        settings = {
          python = {
            analysis = {
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
            },
            testing = {
              provider = "pytest",
            },
            inlayHints = false,
          },
        },
      })
      
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
  -- null-ls: フォーマッターとリンターの統合
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      
      -- Poetryの環境を検出する関数
      local function get_poetry_venv()
        local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p 2>/dev/null"))
        if vim.v.shell_error == 0 and poetry_venv ~= "" then
          return poetry_venv
        end
        return nil
      end
      
      -- ruffコマンドのパスを取得する関数
      local function get_ruff_command()
        local poetry_venv = get_poetry_venv()
        if poetry_venv then
          return poetry_venv .. "/bin/ruff"
        end
        return "ruff" -- デフォルトはグローバルのruff
      end
      
      -- null-lsの設定
      null_ls.setup({
        debug = false,
        sources = {
          -- ruffフォーマッター
          null_ls.builtins.formatting.ruff.with({
            command = get_ruff_command(),
            args = { "format", "--stdin-filename", "$FILENAME", "-" },
            extra_args = { "--line-length=88" }, -- 必要に応じて調整
          }),
          -- ruffリンター
          null_ls.builtins.diagnostics.ruff.with({
            command = get_ruff_command(),
            extra_args = { "--select=E,F,W,I" }, -- 必要に応じて調整
          }),
          -- ホワイトスペース削除
          null_ls.builtins.formatting.trim_whitespace,
          -- ruffでインポート整理
          null_ls.builtins.formatting.ruff_format.with({
            command = get_ruff_command(),
            args = { "format", "--stdin-filename", "$FILENAME", "-" },
          }),
        },
        -- 保存時に自動フォーマット
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
      
      -- ruffでインポート整理するコマンドを追加
      vim.api.nvim_create_user_command("RuffOrganizeImports", function()
        local ruff_cmd = get_ruff_command()
        local file = vim.fn.expand("%:p")
        vim.fn.system(ruff_cmd .. " --select I001 --fix " .. file)
        vim.cmd("edit") -- ファイルを再読み込み
      end, { desc = "Organize imports with ruff" })
    end,
  },
}
      -- ESLintの設定
      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- ESLintの自動修正を保存時に適用
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
        capabilities = capabilities,
        settings = {
          packageManager = "yarn",
          nodePath = ".yarn/sdks",
        }
      })
      
      -- diagnosticsの見た目を設定
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      
      -- diagnosticsのアイコン設定
      local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "ℹ" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.api.nvim_create_user_command("DiagnosticSign" .. type, function()
          vim.api.nvim_buf_set_extmark(0, 0, 0, {
            virt_text = { { icon, hl } },
            hl_group = hl,
          })
        end, { desc = "Define diagnostic sign for " .. type })
      end
      
      -- cspellのカスタム単語を追加
      local custom_words = { "noqa", "pydantic" }
      for _, word in ipairs(custom_words) do
        vim.fn.execute("silent! spellgood " .. word)
      end
    end,
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
  },
  
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
      
      -- スニペットロード
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
      
      -- コマンドライン補完の設定
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" }
        })
      })
      
      -- 検索補完の設定
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })
    end,
  },
}
