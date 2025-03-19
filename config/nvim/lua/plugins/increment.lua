-- increment <C-a><C-x>の拡張
return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
    { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    { "<C-a>", function() return require("dial.map").inc_visual() end, mode = "v", expr = true, desc = "Increment" },
    { "<C-x>", function() return require("dial.map").dec_visual() end, mode = "v", expr = true, desc = "Decrement" },
    { "g<C-a>", function() return require("dial.map").inc_gvisual() end, mode = "v", expr = true, desc = "Increment" },
    { "g<C-x>", function() return require("dial.map").dec_gvisual() end, mode = "v", expr = true, desc = "Decrement" },
  },
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group{
      default = {
        -- 数値関連
        augend.integer.new{
          decimal = true,
          hex = true,
          binary = true,
        },
        augend.integer.alias.decimal,      -- 10進数
        augend.integer.alias.hex,          -- 16進数
        augend.integer.alias.binary,       -- 2進数
        augend.hexcolor.new{},             -- カラーコード (#fff, #ffffff)
        augend.date.alias["%Y/%m/%d"],     -- 日付 (2023/01/01)
        augend.date.alias["%Y-%m-%d"],     -- 日付 (2023-01-01)
        augend.date.alias["%m/%d"],        -- 月日 (01/01)
        augend.date.alias["%H:%M"],        -- 時間 (13:30)
        augend.date.alias["%H:%M:%S"],     -- 時間（秒含む）(13:30:45)
        augend.constant.alias.alpha,       -- アルファベット (a, b, c, ...)
        augend.constant.alias.Alpha,       -- 大文字アルファベット (A, B, C, ...)
        
        -- ブール値・論理演算子
        augend.constant.new{
          elements = {"true", "false"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"True", "False"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"TRUE", "FALSE"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"yes", "no"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"Yes", "No"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"YES", "NO"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"on", "off"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"On", "Off"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"ON", "OFF"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"enable", "disable"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"enabled", "disabled"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"Enable", "Disable"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"Enabled", "Disabled"},
          word = true,
          cyclic = true,
        },
        
        -- 論理演算子
        augend.constant.new{
          elements = {"&&", "||"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"and", "or"},
          word = true,
          cyclic = true,
        },
        
        -- 比較演算子
        augend.constant.new{
          elements = {"==", "!="},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {">", "<"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {">=", "<="},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"===", "!=="},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"is", "is not"},
          word = true,
          cyclic = true,
        },
        
        -- 括弧・括弧式
        augend.constant.new{
          elements = {"(", ")"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"[", "]"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"{", "}"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"<", ">"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"'", '"'},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"`", "'", '"'},
          word = false,
          cyclic = true,
        },
        
        -- 記号・区切り
        augend.constant.new{
          elements = {",", ";"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {".", ","},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {":", ";"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"+", "-"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"++", "--"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"+=", "-="},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"*", "/"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"*=", "/="},
          word = false,
          cyclic = true,
        },
        
        -- プログラミング用語
        augend.constant.new{
          elements = {"public", "private", "protected"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"let", "const", "var"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"function", "method", "property"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"class", "interface", "type"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"get", "set"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"to", "from"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"min", "max"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"start", "end"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"first", "last"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"open", "close"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"up", "down"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"left", "right"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"next", "prev", "previous"},
          word = true,
          cyclic = true,
        },
        
        -- 時間関連
        augend.constant.new{
          elements = {"am", "pm"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"AM", "PM"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"},
          word = true,
          cyclic = true,
        },
        
        -- CSS・カラー関連
        augend.constant.new{
          elements = {"top", "right", "bottom", "left"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"margin", "padding", "border"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"width", "height"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"position", "display", "float"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"block", "inline", "flex", "grid", "none"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"red", "green", "blue", "yellow", "orange", "purple", "black", "white"},
          word = true,
          cyclic = true,
        },
        
        -- Markdown関連
        augend.constant.new{
          elements = {"#", "##", "###", "####", "#####", "######"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"- ", "* ", "+ "},
          word = false,
          cyclic = true,
        },
        
        -- その他の便利なトグル
        augend.paren.new{
          patterns = {{"(", ")"}, {"[", "]"}, {"{", "}"}, {"<", ">"}},
          nested = false,
          cyclic = true,
        },
        augend.case.new{
          types = {"camelCase", "snake_case", "kebab-case", "PascalCase", "SCREAMING_SNAKE_CASE"},
          cyclic = true,
        },
      },
    }
    
    -- ファイルタイプ別の設定
    require("dial.config").augends:register_group{
      -- Python用の設定
      python = {
        augend.constant.new{
          elements = {"if", "elif", "else"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"try", "except", "finally"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"def", "class", "lambda"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"__init__", "__str__", "__repr__"},
          word = true,
          cyclic = true,
        },
      },
      
      -- JavaScript/TypeScript用の設定
      javascript = {
        augend.constant.new{
          elements = {"var", "let", "const"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"function", "class", "interface", "type", "enum"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"if", "else if", "else"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"map", "filter", "reduce", "forEach"},
          word = true,
          cyclic = true,
        },
      },
    }
    
    -- ファイルタイプ別の設定を適用
    vim.api.nvim_create_augroup("dial_file_type", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = "dial_file_type",
      pattern = "python",
      callback = function()
        vim.api.nvim_buf_set_var(0, "dial_augends", {"default", "python"})
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      group = "dial_file_type",
      pattern = {"javascript", "typescript", "typescriptreact", "javascriptreact"},
      callback = function()
        vim.api.nvim_buf_set_var(0, "dial_augends", {"default", "javascript"})
      end,
    })
  end,
}
