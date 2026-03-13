# mvb (my-vocabulary-book) デプロイ手順

## アクセス URL

- フロントエンド: https://my-vocabulary-book.hisho-123.com
- バックエンド API: https://api.my-vocabulary-book.hisho-123.com

## 自動デプロイ (通常運用)

`main` ブランチへ push / PR マージすると GitHub Actions が自動実行されます。

| リポジトリ | トリガー | デプロイ先 |
|---|---|---|
| `my-vocabulary-book_frontend` | push to main | S3 → CloudFront |
| `my-vocabulary-book_backend` | push to main | S3 → CodeDeploy → EC2 ASG |

GitHub Actions の実行状況は各リポジトリの **Actions** タブで確認してください。

### GitHub Secrets (各リポジトリに設定が必要)

**my-vocabulary-book_backend:**

| Secret 名 | 値 (Terraform output から取得) |
|---|---|
| `AWS_ROLE_ARN_BACKEND` | `github_actions_backend_role_arn` |
| `CODEDEPLOY_BUCKET` | `codedeploy_artifacts_bucket` |
| `CODEDEPLOY_APP` | `codedeploy_app_name` |
| `CODEDEPLOY_DEPLOYMENT_GROUP` | `codedeploy_deployment_group_name` |

**my-vocabulary-book_frontend:**

| Secret 名 | 値 (Terraform output から取得) |
|---|---|
| `AWS_ROLE_ARN_FRONTEND` | `github_actions_frontend_role_arn` |
| `FRONTEND_BUCKET` | `frontend_s3_bucket` |
| `CLOUDFRONT_DISTRIBUTION_ID` | `cloudfront_distribution_id` |

---

## 手動デプロイ（緊急時）

CI/CD が使えない場合の手動手順です。

### 前提

- リモートサーバー OS: AlmaLinux 8.10 (EC2)
- `{{server_name}}` を実際のサーバー名/IP に置き換えてください

### 1. バックエンドビルド (ローカル)

```bash
cd my-vocabulary-book_backend/src/
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o my-vocabulary-book_backend .
cp ./my-vocabulary-book_backend /path/to/deploy_repo/server/mvb/backend/
```

### 2. フロントエンドビルド (ローカル)

```bash
# my-vocabulary-book_frontend/ で実行
npm run build
cp -r dist/ /path/to/deploy_repo/server/mvb/frontend/
```

### 3. 資材のアップロード

```bash
scp -r ./server/mvb/ {{server_name}}:.
```

### 4. リモート作業

```bash
ssh {{server_name}}
```

#### バックエンド起動

```bash
sudo mkdir -p /var/log/app/
sudo touch /var/log/app/my-vocabulary-book.log
chmod +x ~/mvb/backend/my-vocabulary-book_backend
sudo cp ~/mvb/backend/my-vocabulary-book_backend /opt/my-vocabulary-book/
sudo systemctl restart my-vocabulary-book
```

#### フロントエンド配信 (S3 へ直接アップロード)

```bash
aws s3 sync ~/mvb/frontend/ s3://{{frontend_bucket}} --delete
aws cloudfront create-invalidation \
  --distribution-id {{cloudfront_distribution_id}} \
  --paths "/*"
```

---

## DB マイグレーション

マイグレーションは自動デプロイとは分離して手動で実行します。

```bash
# リモートサーバーで実行
cd /path/to/migrations/
# マイグレーションコマンドをここに記載
```

マイグレーションファイルは `infra/migrations/` を参照してください。
