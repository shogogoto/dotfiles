# dotfiles

Linuxのユーザー環境をNix + Home Managerで管理する。
移行先のディストリビューションは固定しない。`install-nix.sh` がNix用の
ビルド・適用の入口で、既存のUbuntu用 `install.sh` は元の内容のまま残す。

CLIとdotfilesは共通のNix構成で再現する。DockerなどのOSサービス、
入力デバイスの権限、デスクトップ連携は移行先OSの仕組みで設定する。

## 初回セットアップ

このリポジトリは `~/dotfiles` に置く。`nix/host.nix` のユーザー名、
ホームディレクトリ、CPUアーキテクチャを実際の環境に合わせる。
標準構成は `gotoh`、`/home/gotoh`、`x86_64-linux`。
flakeの構成名 `gotoh` はユーザー名とは独立した名前。

Nixがなければ、[公式のインストール手順](https://nixos.org/download/)
に従って導入する。systemdが動いているLinuxでのmulti-user導入例:

```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
```

新しいターミナルを開き、まず適用せずにビルドする。

```bash
cd ~/dotfiles
./install-nix.sh build
```

既存の `.bashrc`、`.profile` や設定ファイルがある初回は、衝突する
ファイルを退避してから適用する。`-b` はHome Managerが管理を始める
ファイルの既存実体を指定の接尾辞でバックアップする。

```bash
./install-nix.sh switch -b before-home-manager
```

同名のバックアップが既にある場合は上書きせず止まる。その場合は
対象を確認して別の接尾辞を使う。適用後は新しいターミナルを開く。
以前の `.bashrc` は丸ごと復元せず、必要な独自設定を `bashrc` に移す。

`install-nix.sh` はNix定義とlockだけを一時ディレクトリにコピーする。
新規ファイルをGitへ登録する前でも実行でき、ローカルの認証情報・
仮想環境・node_modulesはflakeのソースへ含めない。

## 管理するもの

| 元の処理 | 移行先・方針 |
| --- | --- |
| apt / curl / npmによるCLI導入 | `nix/packages.nix`、バージョンは `flake.lock` で固定 |
| n / Nodeの入れ替え | Nixの `nodejs` に統一 |
| pyenv、Pythonビルド用のライブラリ | NixのPythonを使用。プロジェクト別のPythonはdevShellで指定 |
| Poetry本体とself add | `poetry.withPlugins` でshell・dynamic-versioningを同時導入 |
| Poetryのin-project設定 | 既存の `config/pypoetry/config.toml` と環境変数 |
| starship、direnv、fzfの導入とhook | Home Managerの `programs.*` |
| bashmarksのclone / make install | コミットとハッシュを固定して取得・source |
| gitconfig、tigrc、各アプリの設定 | `nix/home.nix` によるホームへのリンク |
| NeovimのNode / Python provider | Home ManagerのNeovim wrapper |
| fd-findと手動のfdリンク | Nixの `fd`、コマンド名も `fd` |
| neofetch | `fastfetch` に置換 |
| ngrokのsnap | Nixの `ngrok` |
| EspansoのWayland版deb | NixのWayland版。入力権限とサービス登録は別途設定 |
| apt upgrade / autoremove | 日常のOS更新として別途実施 |
| Docker、SSH、Samba、preload | 移行先OSのパッケージ・サービス |
| Flatpak、GNOME / Nautilus連携 | 使用するOS・デスクトップ環境に合わせて設定 |
| Tailscale | 移行先OSでサービスを導入し、認証 |
| gh-copilot拡張 | 廃止済みの旧拡張は導入しない |
| repomix、claude-code、gemini-cli、hub | 使用していないためNix構成には含めない |

元のスクリプトでコメントアウトされていたRust導入とフォント導入は
自動化の対象に含めない。`zellij` と `viu` はNixパッケージで導入する。
`installers/init_dots.sh` は旧方式用で、`install-nix.sh` からは呼ばない。

設定ファイルには `mkOutOfStoreSymlink` を使う。リポジトリの編集が即座に
反映され、Neovimの `lazy-lock.json` も書き込める。Nixの世代を戻しても
dotfilesの編集内容は戻らないため、設定の内容はGitで管理する。

Neovim本体は `nix/home.nix` の `programs.neovim.enable = true` で導入する。
Home Managerのこのモジュールがパッケージを追加するため、
`nix/packages.nix` への重複指定は不要。
Neovimの `init.lua` とプラグイン管理は既存構成を使用する。
Masonやlazy.nvimがダウンロードするものまでNixで固定する構成ではない。
cmigemoの実行パスはPATHから取得し、辞書パスはNixが `MIGEMO_DICT` で渡す。
認証用の `config/pypoetry/auth.toml` は管理・コピーしない。

## 移行先OS側の初期設定

`install-nix.sh` はapt・dnf・pacmanなどを呼ばない。
必要なサービスは移行先のディストリビューションの手順で導入する。
旧 `install.sh` はUbuntu用の参照・従来のセットアップとして残してあり、
Nixによる導入では実行しない。

- Docker: Nix側はCLI・Compose・Buildxを提供する。daemonは移行先OSで
  有効にし、ユーザーの利用権限を設定する。
  [Docker公式手順](https://docs.docker.com/engine/install/)を参照。
- SSH: サーバーが必要なら、OS側でsshdを導入・有効化する。
- Tailscale: [公式のLinux手順](https://tailscale.com/docs/install/linux)に従い、
  サービスを導入して `sudo tailscale up` で認証する。
- Samba、preload、Flatpak、GNOME / Nautilus連携: 使用するOSと
  デスクトップ環境に応じて導入する。
  SaveDesktopとMirrorHallは必要ならFlathubからユーザー用に導入する。

NixOSを選ぶ場合は、これらのOSサービスもNixOSのシステム構成で宣言できる。
このリポジトリではHome Managerの共通ユーザー構成を提供し、
移行先のマシン全体を定義するNixOS構成はまだ含めない。

その他、必要なものだけ個別に設定する。

- `gh auth login`、`ngrok config add-authtoken ...` による認証。
- `mkcert -install` によるローカルCAの登録。
- Espansoは[Wayland向け公式手順](https://espanso.org/docs/install/linux/)に従って
  入力デバイスの権限とサービスを設定する。Nix storeのバイナリを直接
  chmod / setcapする方式は使わず、移行先OS側で入力権限を構成する。
- ディレクトリ名を英語に変える場合は `LANG=C xdg-user-dirs-gtk-update` を一度実行する。
- `bashrc` が使用する `ja_JP.UTF-8` ロケールは移行先OS側で有効にする。

既存のOSパッケージ / npm / pyenvで入れたソフトは自動では削除しない。
移行後は `type -a node python3 poetry nvim docker` で使う実体を確認する。
Home Manager経由で起動するBashではpyenvを自動初期化しない。
既存のpyenv環境は残るが、Pythonの選択はNixと各プロジェクトのdevShellへ移す。

## 更新・検証・ロールバック

Git経由でflakeを評価するには、新しいNixファイルを先に登録する。
`git add` だけではコミットされない。

```bash
git add flake.nix flake.lock nix
nix --extra-experimental-features 'nix-command flakes' flake update
./install-nix.sh build
./install-nix.sh switch
```

`flake.lock` の差分を確認してコミットする。`home.stateVersion` は互換性の
基準なので、パッケージ更新のたびに変更しない。

```bash
nix --extra-experimental-features 'nix-command flakes' flake check --no-build
for script in install.sh install-nix.sh bashrc bash_aliases; do
  bash -n "$script"
done
home-manager generations
```

以前の世代に戻す場合は、`home-manager generations` が表示する
対象の `/nix/store/...-home-manager-generation/activate` を実行する。
CIでも評価とactivationPackageのビルドを行い、ホームへの適用はしない。

[Home Managerのflakeによるstandalone構成](https://github.com/nix-community/home-manager/blob/release-26.05/docs/manual/nix-flakes/standalone.md)
と、[旧gh-copilotの廃止案内](https://github.com/github/gh-copilot)も参照。
