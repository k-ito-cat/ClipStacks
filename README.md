## bookmark-app-mock

## 関連ドキュメント

- プロダクト要件: `docs/specs/product.md`
- 用語集: `docs/specs/glossary.md`
- 技術方針: `docs/specs/tech.md`
- 構成方針: `docs/specs/structure.md`
- API 設計方針: `docs/specs/api.md`
- デザイン方針: `docs/design/DESIGN.md`
- レイアウト定義: `docs/design/layouts.md`
- 画面設計: `docs/design/screens.md`
- コンポーネント設計: `docs/design/components.md`
- UI パターン: `docs/design/ui-patterns.md`
- デザイントークン: `docs/design/tokens.md`
- デザインチェックリスト: `docs/design/checklist.md`

## Get Started

クローン直後に、現時点の構成を再現するための最小手順。

1. リポジトリを clone する
2. `corepack enable`
3. 依存をインストールする
   - ルート: `ni` または `pnpm install`
   - 必要に応じて: `cd apps/api && ni`
4. DB を起動する
   - `docker compose -f docker/docker-compose.yml up -d db`
5. Atlas CLI を確認する
   - `docker compose -f docker/docker-compose.yml run --rm atlas version`
6. API を起動する
   - `pnpm --filter api run dev`
7. ER 図を確認する
   - Mermaid 再生成: `pnpm run db:schema:mermaid`
   - ASCII 確認: `pnpm run render`

## 開発コマンド

### 開発開始時

- DB 起動: `docker compose -f docker/docker-compose.yml up -d db`
- DB 停止: `docker compose -f docker/docker-compose.yml down`
- API 開発サーバー起動: `pnpm --filter api run dev`
- API ビルド: `pnpm --filter api run build`
- ER 図 Mermaid 再生成: `pnpm run db:schema:mermaid`
- ER 図 ASCII 描画: `pnpm run render`

### スキーマ変更時

- `apps/api/db/schema.hcl` を更新する
- 必要なら ER 図を再生成する: `pnpm run db:schema:mermaid`
- migration ファイル生成: `pnpm run db:migrate:diff -- <migration_name>`
- migration 適用: `pnpm run db:migrate:apply`
- migration 状態確認: `pnpm run db:migrate:status`

補足:
- Atlas の `env` 設定は `apps/api/atlas.hcl` に記載している
- `migrate diff` の `dev` DB は差分計算専用の空 DB として `atlas_dev` を使う
- `lab` は実際に migration を適用する DB、`atlas_dev` は差分計算用 DB として分けている
- `atlas_dev` は `docker/initdb/01-create-atlas-dev.sql` で初期化時に作成する
- 既存の `pgdata` ボリュームを使っている場合は初期化 SQL が再実行されないため、必要なら `atlas_dev` を手動作成するか DB ボリュームを作り直す
- `db:migrate:diff` は例: `pnpm run db:migrate:diff -- add-collection-groups-and-priority`
- `pnpm run render` は ASCII 確認用で、ER の線表現は限定的

### 開発用データ投入時

- seed 実行: `pnpm run db:seed`
