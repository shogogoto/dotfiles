#!/usr/bin/env python3
import sqlite3
import subprocess
import time
from pathlib import Path
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.common.exceptions import WebDriverException, TimeoutException


def find_firefox_profiles():
    # 考えられるすべてのFirefoxプロファイルの場所
    possible_locations = [
        Path.home() / "snap" / "firefox" / "common" / ".mozilla" / "firefox",
        Path.home() / ".mozilla" / "firefox",
        Path.home() / "snap" / "firefox" / "current" / ".mozilla" / "firefox",
    ]

    for loc in possible_locations:
        if loc.exists():
            profiles = [
                d
                for d in loc.iterdir()
                if d.is_dir()
                and (
                    d.name.endswith(".default")
                    or d.name.endswith(".default-release")
                    or "." in d.name
                )
            ]

            if profiles:
                return profiles[0], loc

    return None, None


# Firefoxのプロファイルディレクトリを見つける
profile_dir, mozilla_dir = find_firefox_profiles()

if not profile_dir:
    print("Firefoxのプロファイルディレクトリが見つかりませんでした。")
    exit(1)

print(f"使用するプロファイルディレクトリ: {profile_dir}")

# まずFirefoxを終了
subprocess.run(["pkill", "firefox"], stderr=subprocess.DEVNULL)

# faviconファイルを削除して新しく作成させる
favicon_files = [
    "favicons.sqlite",
    "favicons.sqlite-shm",
    "favicons.sqlite-wal",
    "favicons.sqlite-journal",
]
for file in favicon_files:
    try:
        file_path = profile_dir / file
        if file_path.exists():
            file_path.unlink()
            print(f"{file} を削除しました")
    except Exception as e:
        print(f"{file} の削除中にエラーが発生しました: {e}")

# ブックマークのURLを取得
places_db = profile_dir / "places.sqlite"
bookmark_urls = []

if places_db.exists():
    try:
        conn = sqlite3.connect(places_db)
        cursor = conn.cursor()
        # ブックマークのURLを取得
        cursor.execute("""
            SELECT moz_places.url, moz_bookmarks.title
            FROM moz_places
            JOIN moz_bookmarks ON moz_bookmarks.fk = moz_places.id
            WHERE url LIKE 'http%'
        """)
        bookmark_urls = [
            (row[0], row[1] if row[1] else "Unknown") for row in cursor.fetchall()
        ]
        conn.close()
        print(f"{len(bookmark_urls)}件のブックマークURLを取得しました")
    except Exception as e:
        print(f"places.sqliteからの読み取り中にエラーが発生しました: {e}")
        exit(1)
else:
    print("places.sqliteが見つかりません")
    exit(1)

if not bookmark_urls:
    print("更新するブックマークURLが見つかりませんでした。")
    exit(1)

print("\n以下のURLのfaviconを更新します：")
for i, (url, title) in enumerate(bookmark_urls[:10]):  # 最初の10件のみ表示
    print(f"{i + 1}. {title} - {url}")

if len(bookmark_urls) > 10:
    print(f"...他 {len(bookmark_urls) - 10} 件")

print("\nSeleniumを使用してヘッドレスモードでfaviconを更新します...")

# Firefoxのオプションを設定
options = Options()
options.add_argument("-headless")  # ヘッドレスモードで実行

# 現在のユーザープロファイルを使用
options.add_argument("-profile")
options.add_argument(str(profile_dir))

try:
    # WebDriverを開始
    driver = webdriver.Firefox(options=options)
    driver.set_page_load_timeout(30)  # タイムアウトを30秒に設定

    # 各ブックマークURLにアクセス
    success_count = 0
    error_count = 0

    for i, (url, title) in enumerate(bookmark_urls):
        try:
            print(f"処理中 ({i + 1}/{len(bookmark_urls)}): {title} - {url}")
            driver.get(url)

            # ページが読み込まれるのを少し待つ
            time.sleep(0.5)
            success_count += 1

        except TimeoutException:
            print(f"  タイムアウト: {url}")
            error_count += 1
            continue
        except WebDriverException as e:
            print(f"  エラー: {e}")
            error_count += 1
            continue

        # 50サイトごとにドライバーを再起動（メモリリーク対策）
        if (i + 1) % 50 == 0 and i < len(bookmark_urls) - 1:
            print("WebDriverを再起動しています...")
            driver.quit()
            time.sleep(1)
            driver = webdriver.Firefox(options=options)
            driver.set_page_load_timeout(30)

    # 終了
    driver.quit()

    print(f"\n完了: {success_count}件成功, {error_count}件失敗")

except Exception as e:
    print(f"Seleniumの実行中にエラーが発生しました: {e}")

print(
    "\nfaviconの更新が完了しました。Firefoxを起動してブックマークを確認してください。"
)
