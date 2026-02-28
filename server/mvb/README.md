# 前提
今回のリモートサーバーのOSは、AlmaLinux8.10であるため、Linuxのコマンドを記載している。

# access
https://my-vocabulary-book.hisho-123.com

# deploy方法
## local での事前準備
- backendのビルド
  - ディレクトリ移動
    ```
    cd backend/
    ```
  - ビルド
    ```
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o my-vocabulary-book_backend
    ```
  - バイナリファイルを配置
    ```
    cp ./my-vocabulary-book_backend ../server/my-vocabulary-book/
    ```
  - ディレクトリ移動
    ```
    cd ..
    ```
- frontendのビルド
  - my-vocabulary-book_frontend/ のリポジトリに移動して、下記コマンドを実行する。
    ```
    npm run build
    ```
  - 静的ファイルの配置
    ```
    cp -r {{フロントエンドリポジトリのパス}}/dist/ ./server/my-vocabulary-book/frontend/
    ```
- 資材のアップロード
  ```
  scp -r ./server/my-vocabulary-book/ {{server_name}}:.
  ```

## remote作業
- ssh接続
  ```
  ssh {{server_name}}
  ```

## DBの起動
### docker環境の準備
- docker のインストール
  ```
  sudo dnf install -y dnf-plugins-core
  sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io
  ```
- docker 起動
  ```
  sudo systemctl start docker
  sudo systemctl enable docker
  ```
- ディレクトリ移動
  ```
  cd my-vocabulary-book/
  ```
- DB(docker)起動
  ```
  docker compose up -d
  ```

## アプリの起動
- logファイル作成
  ```
  sudo mkdir -p /var/log/app/
  sudo touch /var/log/app/my-vocabulary-book.log
  ```
- 起動
  ```
  nohup ./my-vocabulary-book/backend > /var/log/app/my-vocabulary-book.log 2>&1 &
  ```
