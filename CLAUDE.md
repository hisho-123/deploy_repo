# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 目的

このリポジトリはプロジェクトごとのデプロイ資材・手順を管理するためのものです。アプリケーションのソースコードは含まず、ビルド成果物・設定・デプロイ手順のみを管理します。

## リポジトリ構成

```
deploy_repo/
├── README.md
└── server/
    └── {{アプリ名}}/        # デプロイ対象アプリごとに1ディレクトリ
        ├── README.md        # そのアプリのデプロイ手順
        ├── backend/         # バックエンドバイナリと関連資材
        ├── frontend/        # ビルド済み静的ファイル (dist/)
        └── infra/
            └── migrations/  # DBマイグレーションファイル
```

## 現在のアプリケーション

### `server/mvb` — my-vocabulary-book

- **URL**: https://my-vocabulary-book.hisho-123.com
- **サーバーOS**: AlmaLinux 8.10

#### デプロイ手順

**ローカル — バックエンドビルド（Go、Linux向けクロスコンパイル）:**
```bash
cd backend/
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o my-vocabulary-book_backend
cp ./my-vocabulary-book_backend ../server/my-vocabulary-book/
```

**ローカル — フロントエンドビルド:**
```bash
# フロントエンドリポジトリで実行
npm run build
cp -r {{フロントエンドリポジトリのパス}}/dist/ ./server/my-vocabulary-book/frontend/
```

**資材をサーバーへアップロード:**
```bash
scp -r ./server/my-vocabulary-book/ {{server_name}}:.
```

**リモート — DB起動（Docker）:**
```bash
ssh {{server_name}}
cd my-vocabulary-book/
sudo systemctl start docker   # 未起動の場合
docker compose up -d
```

**リモート — バックエンド起動:**
```bash
sudo mkdir -p /var/log/app/
sudo touch /var/log/app/my-vocabulary-book.log
nohup ./my-vocabulary-book/backend > /var/log/app/my-vocabulary-book.log 2>&1 &
```

## 新規アプリ追加時

上記ディレクトリ構成に従い、`server/{{アプリ名}}/` を作成します。ルートに `README.md`（デプロイ手順を記載）を置き、必要に応じて `backend/`・`frontend/`・`infra/migrations/` を用意してください。

## Issueテンプレート

`.github/ISSUE_TEMPLATE/` に配置:
- `bug.md` — バグ報告用（ラベル: `bug`）
- `feature.md` — 新機能追加用（ラベル: `enhancement`）

いずれもデフォルトで `hisho-123` にアサインされます。
