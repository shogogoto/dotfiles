symbols = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = symbols.error,
      [vim.diagnostic.severity.WARN] = symbols.warn,
      [vim.diagnostic.severity.INFO] = symbols.info,
      [vim.diagnostic.severity.HINT] = symbols.hint,
    },
  },
})
return symbols
