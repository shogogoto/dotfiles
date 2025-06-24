alias vin="vi -u NONE -N" # 設定なしのデフォルトで起動
#alias dos2unix='fromdos'
#alias unix2dos='todos'
alias wt='curl wttr.in'
alias p='poetry shell'
alias repomix="npx repomix --copy; rm repomix-output.xml"
alias yt-dlp-batch='yt-dlp --embed-thumbnail -x --audio-format mp3 --audio-quality 0 --parse-metadata "title:(?P<artist>.+?) - (?P<title>.+?) .*" ' # youtube チャンネル内mp3一括ダウンロード
alias t="todo.sh"
alias i="vi ~/Documents/Dropbox/todo/inbox.md"
alias a="vi ~/Documents/Dropbox/todo/processed.md"
alias ta="batch_todo.sh ~/Documents/Dropbox/todo/action.md"


function online(){
  ngrok http https://localhost:${1} --url=toucan-renewing-jackal.ngrok-free.app
}
