-- 診断結果を表示するためのキーマップ
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic at cursor" })

vim.keymap.set("n", "gK", function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })
vim.opt.updatetime = 600 -- ホバー表示の遅延時間を設定（ミリ秒）

local symbols = require("user.symbols")
local sev = vim.diagnostic.severity

local function format_diagnostic(diagnostic)
  local msg = diagnostic.message
  local code = diagnostic.code or ""
  local src = diagnostic.source or ""
  if src:lower() == "ruff" and code ~= "" then
    local url = string.format("https://docs.astral.sh/ruff/rules/%s", code)
    return string.format("[%s] %s: %s\nReference: %s", src, code, msg, url)
  end
  if code ~= "" then
    return string.format("[%s] %s: %s", src, code, msg)
  else
    return string.format("[%s]: %s", src, msg)
  end
end
-- カーソルがホバーした時に自動的に診断情報を表示する
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float({
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    })
  end,
})

vim.diagnostic.config({
  underline = true,         -- エラー箇所に下線を表示
  update_in_insert = false, -- インサートモード中は更新しない
  severity_sort = true,     -- 重要度でソート
  signs = {
    text = {
      [sev.ERROR] = symbols.error,
      [sev.WARN] = symbols.warn,
      [sev.INFO] = symbols.info,
      [sev.HINT] = symbols.hint,
    },
  },

  -- loclist = { open = true },
  -- virtual_text = false,
  -- virtual_lines = true,
  virtual_text = {
    prefix = "●", -- 診断情報の前に表示する記号
    source = "if_many", -- 複数のソースがある場合にのみソースを表示
    spacing = 0, -- テキストとの間隔
    header = "Diagnostic Details", -- ヘッダーテキスト
    format = format_diagnostic, -- テキストのフォーマット関数
  },
  float = {
    source = "always",
    border = "single",
    title = "Diagnostics",
    format = format_diagnostic,
  },
})
