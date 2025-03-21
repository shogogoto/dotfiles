return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = "evil_lualine"
    }
  },
  {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  },
}

