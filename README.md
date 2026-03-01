## bookmark-app-mock

## Get Started

クローン直後に、現時点の構成を再現するための最小手順。

1. リポジトリを clone する
2. `corepack enable`
3. 依存をインストールする
   - ルート: `ni`（または `pnpm install`）
   - 必要に応じて各ディレクトリ: `cd apps/api && ni`
4. DB を起動する
   - `docker compose -f docker/docker-compose.yml up -d db`
5. API を起動する（Hono）
   - `pnpm --filter api run dev`
   - ブラウザで `http://localhost:3000` を確認する
6. ER 図（ASCII）を表示する
   - `pnpm run render`
7. Atlas CLI（Docker 実行）を確認する
   - `docker compose -f docker/docker-compose.yml run --rm atlas version`
8. Atlas から DB 接続できることを確認する
   - `docker compose -f docker/docker-compose.yml run --rm atlas schema inspect --url "postgres://postgres:postgres@db:5432/lab?sslmode=disable"`

### 主要コマンド（現時点）

- API 開発サーバー起動: `pnpm --filter api run dev`
- API ビルド: `pnpm --filter api run build`
- DB 起動: `docker compose -f docker/docker-compose.yml up -d db`
- DB 停止: `docker compose -f docker/docker-compose.yml down`
- Atlas バージョン確認: `docker compose -f docker/docker-compose.yml run --rm atlas version`
- Atlas で DB スキーマ参照: `docker compose -f docker/docker-compose.yml run --rm atlas schema inspect --url "postgres://postgres:postgres@db:5432/lab?sslmode=disable"`
- ER 図 ASCII 描画: `pnpm run render`

// TODO: 導入メモの続き（Atlasのmigration生成/適用、kysely-codegen、API実装、Web実装）は後続で追記する

### 導入メモ（現時点 / 作業履歴）

1. リポジトリを clone する
2. `corepack enable`
3. 依存をインストールする（例: `pnpm install` / `ni`）
4. `hono create` で `apps/api` の雛形を作成する
5. `pnpm --filter api run dev` でAPIを起動し、`http://localhost:3000` を確認する
6. `apps/api` に `kysely` を導入する
7. `docs/diagrams/er.mmd` と `scripts/renderMermaidAscii.ts` を用意し、`pnpm run render` でER図をASCII表示できる状態にする
8. `docker/docker-compose.yml` で `db`（PostgreSQL）と `atlas`（CLI）を定義する
9. `docker compose -f docker/docker-compose.yml up -d db` でDBを起動する
10. `docker compose -f docker/docker-compose.yml run --rm atlas version` でAtlas CLIの実行を確認する
11. `docker compose -f docker/docker-compose.yml run --rm atlas schema inspect --url "postgres://postgres:postgres@db:5432/lab?sslmode=disable"` でAtlasからDBへ接続できることを確認する

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
- Type Generation: `kysely-codegen`（導入予定）
- Migration / Schema Management: Atlas（HCLでスキーマ定義）
  - Atlas は migration 用の CLI ツール
  - OS へ直接インストールが一般的だが、プロジェクト依存ツールをOSに入れると再現性が低くなる。Dockerに入れて実行することでdocker-composeにより再現性を担保できるためDockerに入れる。
- Database: PostgreSQL（Docker でローカル起動想定）
- ER図作成: `beautiful-mermaid`（Mermaid を ASCII 表示）
- ER図描画スクリプト: `scripts/renderMermaidAscii.ts`（`docs/diagrams/er.mmd` を読み込み）

### アーキテクチャ方針

- Hono の route は薄く保つ
- `route / service / repository` を分ける
- ER図をもとに Atlas HCL でスキーマ定義を行う
- スキーマを起点に Atlas で migration を生成・適用する
- スキーマを起点に `kysely-codegen` で Kysely の型を生成する
- DB スキーマ管理は Atlas、アプリケーションのクエリ実装は Kysely に分離する
- まず最小で動く構成を作り、後から機能単位に整理する

### ディレクトリ構成（現時点）

```txt
apps/api/
  src/index.ts
  package.json
  tsconfig.json
docs/
  diagrams/
    er.mmd
  pencil/
    .gitkeep
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
      generated.ts
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
    schema.hcl
    migrations/
  atlas.hcl
```
