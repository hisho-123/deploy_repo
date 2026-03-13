# deploy用リポジトリ

## 目的

デプロイ用の資材や手順をプロジェクトごとに配置して管理する。

## 構成

```
deploy_repo/
├── README.md
└── server/
    └── {{アプリ名}}/
        ├── README.md        # デプロイ手順
        ├── backend/         # バックエンドバイナリ（手動デプロイ時）
        ├── frontend/        # ビルド済み静的ファイル（手動デプロイ時）
        └── infra/
            └── migrations/  # DB マイグレーションファイル
```

## 自動デプロイ (CI/CD)

`mvb` アプリケーションは GitHub Actions による自動デプロイを採用しています。

```
[Frontend repo] main ブランチへの push/merge
       │
       ▼ GitHub Actions
  npm run build → S3 sync → CloudFront invalidation
       │
       ▼
  CloudFront → my-vocabulary-book.hisho-123.com

[Backend repo] main ブランチへの push/merge
       │
       ▼ GitHub Actions
  go build (linux/amd64) → zip → S3 → CodeDeploy
       │
       ▼
  EC2 ASG (2台) → systemd restart
       │
  ALB → api.my-vocabulary-book.hisho-123.com
```

詳細は各アプリの README を参照してください。

## 手動デプロイ（緊急時）

詳細は [`server/mvb/README.md`](server/mvb/README.md) を参照してください。

## DB マイグレーション

マイグレーションは自動デプロイの対象外です。`server/mvb/infra/migrations/` を参照して手動で実行してください。
