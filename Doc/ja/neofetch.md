# neofetch

システム情報をアスキーアートと共に表示するツール。

---

## 使い方

```bash
neofetch
```

ターミナルを開いたときや新しい環境に入ったときに実行すると、
OS・カーネル・CPU・メモリなどの情報を素早く確認できます。

---

## 表示される情報

| 項目 | 内容 |
|------|------|
| OS | ディストリビューション名とバージョン |
| Host | ホスト名・マシンモデル |
| Kernel | カーネルバージョン |
| Uptime | システム稼働時間 |
| Packages | インストール済みパッケージ数 |
| Shell | 使用中のシェルとバージョン |
| Resolution | 画面解像度（デスクトップ環境がある場合） |
| DE / WM | デスクトップ環境 / ウィンドウマネージャ |
| Terminal | 使用中のターミナルエミュレータ |
| CPU | プロセッサ名とコア数 |
| GPU | グラフィックカード（検出できる場合） |
| Memory | メモリ使用量 / 総量 |

---

## 主なオプション

```bash
neofetch --off            # アスキーアートなしで情報のみ表示
neofetch --ascii_distro ubuntu  # 別のディストリのアスキーアートを使用
neofetch --config none    # 設定ファイルを無視して実行
```

---

## 設定ファイル

`~/.config/neofetch/config.conf` で表示項目・色・アスキーアートをカスタマイズできます。

```bash
# 設定ファイルを生成（初回）
neofetch --config ~/.config/neofetch/config.conf
```

主な設定項目：
- `info` 行のコメントアウトで表示項目を非表示にする
- `image_backend` でアスキーアートを画像に変更（kitty / iterm2 など対応ターミナルのみ）
- `colors` で配色をカスタマイズ

---

## WSL での注意

WSL2 上では GPU 情報や解像度が正しく取得できない場合があります。
`neofetch --off` で情報部分のみ確認するのが安定しています。
