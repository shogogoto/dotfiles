return {
  {
    "williamboman/mason.nvim", -- LSPのインストール管理
    opts = {
      ui = {
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
    keys = { { "<leader>m", "<cmd>Mason<CR>", desc = "Mason Package Manager Menu" } },
    dependencies = {},
  },
  { -- masonのdepsに入れたかったけどauto install 走らなくなった
    -- 自動インストールどっちもできる
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        --lua
        "stylua",
        "lua-language-server", --"lua_ls",
        "luacheck",
        -- python
        "pyright",
        -- "ruff", -- formatter
        "pyproject-flake8",
        -- typescript
        "typescript-language-server", --"ts_ls",
        "eslint-lsp", -- "eslint".
        "bash-language-server", --"bashls",
        "dockerfile-language-server", --"dockerls",
        "docker-compose-language-service", -- "docker_compose_language_service",
        "cypher-language-server", --"cypher_ls",
        "vim-language-server", --"vimls",
        -- text
        "json-lsp", -- "jsonls",
        "yaml-language-server", --"yamlls",
        -- markdown
        "markdown-toc",
        "markdownlint",

        "cspell",
        "copilot-language-server",
      },
      auto_update = true,
      run_on_start = true,
      -- automatic_installation = true,
    },
  },
}
