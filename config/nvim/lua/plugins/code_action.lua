return {
  "aznhe21/actions-preview.nvim",
  keys = {
    {
      "ga",
      "<cmd>lua require('actions-preview').code_actions()<cr>",
      mode = { "v", "n" },
      desc = "Code Actions Preview",
    },
  },
}
