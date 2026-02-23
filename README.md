## bookmark-app-mock

`corepack enable`

## プロジェクトの目的

- ブックマークアプリのモックを作成する
- API / DB 周りの実装を通して学習する
- 技術選定と組み合わせの理解を深める（例: Hono / Kysely / Atlas / PostgreSQL）
- Monorepo 構成での責務分割と運用を試す

## API

### 現時点の技術スタック

- Runtime: Node.js
- Web Framework: Hono（`@hono/node-server`）
- Query Builder: Kysely
- Migration / Schema Management: Atlas（導入予定）
- Database: PostgreSQL（Docker でローカル起動想定）
- ER図作成: `beautiful-mermaid`（Mermaid を ASCII 表示）
- ER図描画スクリプト: `scripts/renderMermaidAscii.ts`（`er.mmd` を読み込み）

### アーキテクチャ方針

- Hono の route は薄く保つ
- `route / service / repository` を分ける
- DB スキーマ管理は Atlas、アプリケーションのクエリ実装は Kysely に分離する
- まず最小で動く構成を作り、後から機能単位に整理する

### ディレクトリ構成（現時点）

```txt
apps/api/
  src/index.ts
  package.json
  tsconfig.json
```

### ディレクトリ構成（予定）

```txt
apps/api/
  src/
    app.ts
    server.ts
    db/
      kysely.ts
      types.ts
    modules/
      health/
        route.ts
      bookmarks/
        route.ts
        service.ts
        repository.ts
        schema.ts
    middleware/
      error-handler.ts
  db/
    schema.sql
    migrations/
  atlas.hcl
```
