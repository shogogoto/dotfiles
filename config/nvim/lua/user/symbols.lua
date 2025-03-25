symbols = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

local signs = { Error = symbols.error, Warn = symbols.warn, Hint = symbols.hint, Info = symbols.info }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return symbols
