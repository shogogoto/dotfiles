-- https://qiita.com/ysmb-wtsg/items/a63344d5acae52d53af9
return {
  "shortcuts/no-neck-pain.nvim",
  -- version = "*",
  config = function()
    require("no-neck-pain").setup({
      buffers = {
        right = {
          enabled = false,
        },
        scratchPad = {
          enabled = true,
          location = "~/notes",
        },
        bo = {
          filetype = "md",
        },
      },
      autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
        reloadOnColorSchemeChange = true,
      },
    })
  end,
  keys = {
    { "<Leader>c", "<cmd>NoNeckPain<CR>", mode = "n" }, -- center zだとスペースから指遠い
  }
}

