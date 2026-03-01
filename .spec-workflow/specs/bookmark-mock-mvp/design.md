# Design: bookmark-mock-mvp

## 設計サマリ

本設計は、`requirements.md` の `REQ-001` から `REQ-010` を満たすための実装方針を定義する。  
本ドキュメントは方針設計に限定し、詳細なテーブル定義や API 仕様は後続の作図（beautiful-mermaid）および API 仕様書（Swagger など）で確定する。

## 仕様書と派生成果物の関係

- 本 spec（requirements/design/tasks）を正本として扱う
- 詳細アーキテクチャは本 spec をもとに beautiful-mermaid で作図する
- API 仕様は本 spec をもとに Swagger などで定義する
- 画面デザインは本 spec をもとに pencil で作成する
- 派生成果物で差分が生じた場合は、先に本 spec を更新して整合させる

## 確認済み事実と設計判断

### 確認済み事実（公式ドキュメント）

- Hono はバリデーションをミドルウェアとして扱える  
  参照: https://hono.dev/docs/guides/validation
- Kysely は型安全なクエリビルダーとして transaction を利用できる  
  参照: https://www.kysely.dev/docs/examples/transactions/simple-transaction
- Atlas はスキーマ管理とマイグレーション運用のワークフローを提供する  
  参照: https://atlasgo.io/docs
- Zod は TypeScript-first なスキーマ検証を提供する  
  参照: https://zod.dev/

### 設計判断

- API 入出力検証は zod を採用する
- DB スキーマ管理は Atlas、アプリ側データアクセスは Kysely に分離する
- 共有 schema/type は `packages/shared` に集約する
- Web は最小 UI を優先し、Next.js または TanStack 系を実装時に確定する

## アーキテクチャ

## 全体構成

```txt
apps/
  api/
    src/
      modules/
      db/
      middleware/
  web/
packages/
  shared/
  api-client/
  config/
docker/
```

## レイヤー責務

- `route`: HTTP 入出力、入力検証、レスポンス整形
- `service`: ユースケース制御、トランザクション境界
- `repository`: DB 操作

## 依存方向

- `route -> service -> repository`
- `apps/api -> packages/shared`
- `apps/web -> packages/shared + packages/api-client`
- `packages/shared` はアプリ層へ依存しない

## データ設計方針

- 対象ドメインは `users`, `collections`, `bookmarks`, `tags`, `categories` を中心に構成する
- コレクションは親子 2 階層までを許可し、それ以上は拒否する（`REQ-002`）
- ブックマークはピン状態を保持し、一覧時に優先表示できるようにする（`REQ-006`）
- タグは複数付与、カテゴリは単一分類を基本方針とする（`REQ-007`）
- 検索 / フィルタ / ソートに必要なクエリ効率を確保する
- 詳細スキーマは後続の作図・マイグレーション設計で確定する

## API 設計方針

- API は最小セットから段階導入する（`REQ-009`）
- 入出力は schema 検証を必須とする
- エラー形式は `{ code, message, details? }` に統一する
- 検索 / フィルタ / ソートの入力条件は一貫したクエリ規約で扱う（`REQ-008`）
- 詳細エンドポイント定義と payload は後続の API 仕様書で確定する

## バリデーション / エラーハンドリング

- zod schema を `packages/shared` に配置する
- route 層で parse して service へ受け渡す
- バリデーション失敗は統一エラーで返す
- 共通エラーハンドラを導入して例外処理を一本化する

## 検索 / フィルタ / ソート実装方針

- repository 層で条件付きクエリを組み立てる
- ピン状態の優先表示を可能にする
- URL・タグ・カテゴリ・コレクションを主条件として扱う
- MVP では部分一致検索を採用する

## トランザクション方針

- 複数エンティティ更新が発生する処理は service 層で transaction 管理する
- 失敗時に partial update を残さない

## migration / seed 方針

- スキーマ変更は Atlas ベースで履歴管理する
- ローカル再現可能な migration 順序を維持する
- seed は動作検証に必要な最小データを用意する

## 共有パッケージ方針

## packages/shared

- API 入出力 schema/type の真実源
- API/Web で共通利用する契約を定義

## packages/api-client

- Web から API を呼ぶ共通窓口
- 直接 fetch ではなくクライアント経由を原則化する

## Web 方針（最小実装）

- ユーザー登録
- コレクション管理（2階層）
- ブックマーク一覧 / 追加 / 削除 / ピン
- タグ / カテゴリ管理
- 検索 / フィルタ / ソート

UI は検証に必要な最小構成とし、過度な装飾は対象外とする。

## セキュリティ方針（MVP）

- 本番認証は対象外だが、資格情報は平文保存しない
- DB 操作はクエリビルダー経由とし、直接文字列連結を避ける
- 機密情報は環境変数で管理する

## 要件トレーサビリティ

- `REQ-001`: ユーザー登録機能方針
- `REQ-002`: コレクション 2 階層制約方針
- `REQ-003`: URL 登録と入力検証方針
- `REQ-004`: 一覧表示方針
- `REQ-005`: 削除処理方針
- `REQ-006`: ピン管理と優先表示方針
- `REQ-007`: タグ / カテゴリ管理方針
- `REQ-008`: 検索 / フィルタ / ソート方針
- `REQ-009`: schema 検証と統一エラー方針
- `REQ-010`: Docker / migration / workspace 再現性方針

## 実装フェーズ分割

1. DB スキーマと migration/seed の土台
2. API 基盤（app, route, error handler）
3. users / collections の実装
4. bookmarks と pin、検索/フィルタ/ソートの実装
5. tags / categories の実装
6. shared schema/type と api-client の整備
7. web 最小画面の接続
