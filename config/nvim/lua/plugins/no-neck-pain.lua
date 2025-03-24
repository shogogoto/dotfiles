-- https://qiita.com/ysmb-wtsg/items/a63344d5acae52d53af9
return {
  "shortcuts/no-neck-pain.nvim",
  -- version = "*",
  opts = {
    buffers = {
      right = {
        enabled = true, -- 右側の分割画面を有効化
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
  },
  keys = {
    { "<Leader>cc", "<cmd>NoNeckPain<CR>", mode = "n", desc = "no neck pain" }, -- center zだとスペースから指遠い
  },
}
