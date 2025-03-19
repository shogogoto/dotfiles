return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Open terminal in float mode" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Open terminal in float mode" },
    { "<leader>ts", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Open terminal in float mode" },
  },
  opts = {
    size = 60,
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    
    -- ターミナルモードでの設定
    function _G.set_terminal_keymaps()
      local map = vim.keymap.set
      local opts = { buffer = 0 }
      map("t", "<esc>", [[<C-\><C-n>]], opts)
      map("t", "jk", [[<C-\><C-n>]], opts)
      map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    end

    -- ターミナルが開いたときに自動でマッピングを設定
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
