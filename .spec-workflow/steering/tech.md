# Tech Steering

## 技術方針

- 学習効率を優先し、最小で動く構成から段階的に拡張する
- Monorepo で責務を分離しつつ、共有スキーマと共有型を中心に整合性を保つ
- API と DB の接続点は型安全を重視する
- 本番最適化より、再現性と理解しやすさを優先する

## モノレポ構成

- ワークスペース管理: `pnpm workspace`
- ルート管理対象: `apps/*`, `packages/*`
- 依存管理: `pnpm`（`corepack enable` 前提）

## 採用技術

- 言語: TypeScript
- API: Hono（`@hono/node-server`）
- データアクセス: Kysely
- DB: PostgreSQL（Docker Compose）
- スキーマ / マイグレーション: Atlas
- 入出力スキーマ: zod
- 図作成: beautiful-mermaid（Mermaid の ASCII 描画）
- Web: Next.js または TanStack 系（最小 UI 前提、最終選定は実装時に確定）

## 現在の実装状態

- `apps/api/src/index.ts` に最小 Hono サーバーを配置
- `GET /` の疎通確認用エンドポイントを配置
- `docker/docker-compose.yml` で `db`（PostgreSQL）と `atlas`（CLI）を定義
- ER 図描画スクリプトをルートスクリプトとして配置

## 目標アーキテクチャ

- API は `route / service / repository` を分離する
- route は HTTP 入出力に限定し、業務ロジックを持たせない
- service はユースケース単位の制御を担う
- repository は DB クエリと永続化の責務に限定する
- DB スキーマ管理（Atlas）とクエリ実装（Kysely）を分離する

## API 設計ルール

- 初期エンドポイントを最小セットで開始する
- `GET /health`
- `GET /bookmarks`
- `POST /bookmarks`
- `DELETE /bookmarks/:id`
- API の入力 / 出力は schema で検証する
- エラー形式は `{ code, message, details? }` に統一する

## データ / スキーマ方針

- スキーマ変更は Atlas ベースで管理する
- DB 変更は migration/seed で再現できる状態を維持する
- 型安全なクエリ実装は Kysely を起点に行う
- 必要に応じて `kysely-codegen` で生成型を活用する

## パッケージ責務

- `apps/api`: API 本体、DB 接続、migration/seed
- `apps/web`: 動作確認用の最小 UI
- `packages/shared`: 共通 schema/type の真実源
- `packages/api-client`: Web から API を呼ぶ共通クライアント
- `packages/config`: Biome / TSConfig などの共通設定

## 開発運用ルール

- まず動く最小実装を作り、必要になった時点で分離・抽象化する
- 早期の過剰なレイヤー分割は避ける
- Web からの API 直叩きは避け、クライアント層を経由する
- 変更理由を追える単位で差分を小さく保つ

## 開発コマンド方針

- DB 起動: `docker compose -f docker/docker-compose.yml up -d db`
- DB 停止: `docker compose -f docker/docker-compose.yml down`
- API 開発: `pnpm --filter api run dev`
- API ビルド: `pnpm --filter api run build`
- ER 図描画: `pnpm run render`

## 品質チェック方針

- 変更後は `npm run format`, `npm run lint`, `npm run test` を優先して確認する
- 影響範囲が大きい変更は `npm run build` も確認する
- スクリプト未定義の場合は既存構成を優先し、無理に追加しない
