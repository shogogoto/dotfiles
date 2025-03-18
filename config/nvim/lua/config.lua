-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
    { "vim-jp/vimdoc-ja", lazy = true, keys = {{ "h", mode = "c",},}, },
    {
      "ntk148v/habamax.nvim",
      dependencies={ "rktjmp/lush.nvim" }
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
      -- コマンドラインで行番号を入力してその行をチラ見、そのままEnterで移動できる
      'nacro90/numb.nvim',
      config = function()
        require('numb').setup()
      end,
    },
    -- Vim起動時や:editしたときに存在しないディレクトリを指定すると勝手にmkdir
    { "jghauser/mkdir.nvim" }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = {
    missing = true,
    colorscheme = { "habamax" }
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
