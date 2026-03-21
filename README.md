## bookmark-app-mock

## 関連ドキュメント

- プロダクト要件: `docs/specs/product.md`
- 技術方針: `docs/specs/tech.md`
- 構成方針: `docs/specs/structure.md`
- API 設計方針: `docs/specs/api.md`

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
   - `pnpm run render`

## 開発コマンド

### 開発開始時

- DB 起動: `docker compose -f docker/docker-compose.yml up -d db`
- DB 停止: `docker compose -f docker/docker-compose.yml down`
- API 開発サーバー起動: `pnpm --filter api run dev`
- API ビルド: `pnpm --filter api run build`
- ER 図 ASCII 描画: `pnpm run render`

### スキーマ変更時

- `apps/api/db/schema.hcl` を更新する
- migration ファイル生成: `docker compose -f docker/docker-compose.yml run --rm -w /app/apps/api atlas migrate diff --env local <migration_name>`
- migration 適用: `docker compose -f docker/docker-compose.yml run --rm -w /app/apps/api atlas migrate apply --env local`
- migration 状態確認: `docker compose -f docker/docker-compose.yml run --rm -w /app/apps/api atlas migrate status --env local`

補足:
- Atlas の `env` 設定は `apps/api/atlas.hcl` に記載している

### 開発用データ投入時

- seed 実行: `docker compose -f docker/docker-compose.yml exec -T db psql -U postgres -d lab < apps/api/db/seed.sql`
