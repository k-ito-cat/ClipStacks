# Structure Steering

## 構成原則

- 学習しやすさを優先し、構造は段階的に育てる
- 最初は最小構成で開始し、必要に応じて責務分離を進める
- ただし `route / service / repository` の分離は初期から維持する
- 共通 schema/type は `packages/shared` に集約する

## リポジトリ全体構成

- `apps/`: 実行可能アプリケーション
- `packages/`: 共有パッケージ（型、クライアント、設定）
- `docker/`: ローカル開発インフラ定義
- `docs/`: 図や補助ドキュメント
- `scripts/`: 開発補助スクリプト
- `.spec-workflow/`: 仕様 / ステアリング / 承認管理

## 現在の主要構成

```txt
apps/
  api/
    src/index.ts
  web/
packages/
  shared/
    index.ts
  api-client/
  config/
docker/
  docker-compose.yml
docs/
  diagrams/er.mmd
  pencil/.gitkeep
scripts/
  renderMermaidAscii.ts
```

## 目標構成

```txt
apps/
  api/
    src/
      app.ts
      server.ts
      modules/
        health/
          route.ts
        bookmarks/
          route.ts
          service.ts
          repository.ts
          schema.ts
      db/
        kysely.ts
        generated.ts
      middleware/
        error-handler.ts
    db/
      schema.hcl
      migrations/
      seeds/
  web/
    src/
      features/
      pages/
packages/
  shared/
    src/
      schemas/
      types/
  api-client/
    src/
  config/
    biome/
    tsconfig/
```

## ディレクトリ責務

- `apps/api`
- HTTP 入口、ユースケース、DB 操作を分離して実装する
- スキーマ変更とマイグレーション運用を保持する

- `apps/web`
- 動作確認に必要な最小 UI を実装する
- API 呼び出しは `packages/api-client` を経由する

- `packages/shared`
- API 入出力 schema/type の真実源を配置する
- API と Web の双方から参照する

- `packages/api-client`
- API 呼び出しロジックを共通化する
- エンドポイント URL やレスポンス整形を一元化する

- `packages/config`
- Biome / TypeScript 設定を共通管理する

## ファイル配置ルール

- API の機能追加は `modules/<feature>/` 配下で完結させる
- feature 単位で `route.ts`, `service.ts`, `repository.ts`, `schema.ts` を揃える
- DB 接続と DB 型定義は `apps/api/src/db/` に置く
- 共有型・共有スキーマは `packages/shared` 以外に重複定義しない
- 一時的な検証コードは恒久配置しない

## 命名ルール

- ディレクトリ名は小文字 + ハイフンまたは単語小文字で統一する
- ファイル名は役割が伝わる名詞ベース（`route.ts`, `service.ts` など）を優先する
- feature 名は業務概念に合わせる（例: `bookmarks`, `health`）

## 依存方向ルール

- `apps/web` は `packages/shared` と `packages/api-client` に依存してよい
- `apps/api` は `packages/shared` に依存してよい
- `packages/shared` はアプリ層へ依存しない
- 循環依存を作らない

## 変更運用ルール

- 機能追加・仕様変更・挙動変更・整形を同一差分で混在させない
- ファイル移動 / リネーム / import 整理は可能な限り機械的変更として分離する
- 大きな変更は小さく分割し、途中段階でも動作確認できる単位を保つ

## ドキュメント同期ルール

- 構成変更時は `README.md` の関連記述を更新する
- 実装実態と steering 文書の乖離を放置しない
- 新規ディレクトリ追加時は責務を短く明記する
