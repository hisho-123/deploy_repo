# deploy用リポジトリ

## 目的
- デプロイ用の資材や手順をプロジェクトごとに配置して管理する。

## 構成

下記ディレクトリ構成で整備する。
各アプリディレクトリのルートにあるREADMEにデプロイ手順を記載する。

```
deploy_repo
|
├─ README.md
├─ server
|    ├─ {{applicatioin dir}}
|    |    ├─ README
|    |    ├─ {{deploy資材}}
```
