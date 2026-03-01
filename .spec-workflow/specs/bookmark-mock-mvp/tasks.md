# Tasks: bookmark-mock-mvp

## 実装タスク一覧

- [ ] 1. ER図を作成する（beautiful-mermaid）
  - Files: `docs/diagrams/er.mmd`, `scripts/renderMermaidAscii.ts`
  - Requirements: `REQ-002`, `REQ-003`, `REQ-006`, `REQ-007`, `REQ-010`
  - _Prompt:
```text
Implement the task for spec bookmark-mock-mvp, first run spec-workflow-guide to get the workflow guide then implement the task:
Role: data modeling and diagram engineer
Task: requirements/design を正本として、users/collections/bookmarks/tags/categories を含む ER 図を `docs/diagrams/er.mmd` に作成し、`pnpm run render` で確認できる状態にする。
Restrictions: 仕様書にない機能エンティティを追加しない。テーブル詳細の過剰定義を先に行わない。図と仕様の不整合を残さない。
_Leverage: .spec-workflow/specs/bookmark-mock-mvp/requirements.md, .spec-workflow/specs/bookmark-mock-mvp/design.md, docs/diagrams/er.mmd
_Requirements: REQ-002, REQ-003, REQ-006, REQ-007, REQ-010
Success: ER 図が仕様と整合し、レンダリングで構造確認できる。
Instructions: 作業開始時に tasks.md の当該タスクを `[-]` に変更する。完了後に log-implementation を実行して実装内容を記録し、その後 `[x]` に更新する。
```

- [ ] 2. デザインと画面遷移図を作成する（pencil.dev）
  - Files: `docs/pencil/screen-flow.md`, `docs/pencil/wireframe-notes.md`
  - Requirements: `REQ-001`, `REQ-002`, `REQ-004`, `REQ-005`, `REQ-006`, `REQ-007`, `REQ-008`
  - _Prompt:
```text
Implement the task for spec bookmark-mock-mvp, first run spec-workflow-guide to get the workflow guide then implement the task:
Role: product flow and UI planning engineer
Task: pencil.dev 作業の元になる画面一覧・画面遷移・UI 要素定義を文書化し、ユーザー登録/コレクション/一覧/追加/削除/検索の遷移を整理する。
Restrictions: UI の作り込みはしない。仕様外画面を追加しない。機能仕様を画面都合で変更しない。
_Leverage: .spec-workflow/specs/bookmark-mock-mvp/requirements.md, .spec-workflow/specs/bookmark-mock-mvp/design.md
_Requirements: REQ-001, REQ-002, REQ-004, REQ-005, REQ-006, REQ-007, REQ-008
Success: 主要画面と遷移が不足なく定義され、pencil.dev で具体化できる材料が揃う。
Instructions: 作業開始時に tasks.md の当該タスクを `[-]` に変更する。完了後に log-implementation を実行して実装内容を記録し、その後 `[x]` に更新する。
```

- [ ] 3. スキーマを HCL で作成する
  - Files: `apps/api/atlas.hcl`, `apps/api/db/schema.hcl`
  - Requirements: `REQ-001`, `REQ-002`, `REQ-003`, `REQ-006`, `REQ-007`, `REQ-010`
  - _Prompt:
```text
Implement the task for spec bookmark-mock-mvp, first run spec-workflow-guide to get the workflow guide then implement the task:
Role: atlas schema engineer
Task: ER 図と仕様をもとに Atlas 用 HCL スキーマを作成し、ユーザー・コレクション2階層・ブックマーク・タグ/カテゴリ関連を表現する。
Restrictions: 仕様外の列や制約を追加しない。HCL と設計文書を乖離させない。
_Leverage: docs/diagrams/er.mmd, .spec-workflow/specs/bookmark-mock-mvp/design.md, docker/docker-compose.yml
_Requirements: REQ-001, REQ-002, REQ-003, REQ-006, REQ-007, REQ-010
Success: HCL で必要ドメインを表現でき、Atlas コマンドで読み取れる。
Instructions: 作業開始時に tasks.md の当該タスクを `[-]` に変更する。完了後に log-implementation を実行して実装内容を記録し、その後 `[x]` に更新する。
```

- [ ] 4. Atlas でマイグレーションを作成・適用する
  - Files: `apps/api/db/migrations/`, `README.md`
  - Requirements: `REQ-010`
  - _Prompt:
```text
Implement the task for spec bookmark-mock-mvp, first run spec-workflow-guide to get the workflow guide then implement the task:
Role: database migration engineer
Task: HCL スキーマから Atlas migration を生成し、ローカル DB へ適用して再現可能な手順を確立する。
Restrictions: 手動 SQL のみで運用しない。再現不能なローカル差分を残さない。
_Leverage: apps/api/atlas.hcl, apps/api/db/schema.hcl, docker/docker-compose.yml
_Requirements: REQ-010
Success: migration ファイルが作成され、適用手順を README に反映できる。
Instructions: 作業開始時に tasks.md の当該タスクを `[-]` に変更する。完了後に log-implementation を実行して実装内容を記録し、その後 `[x]` に更新する。
```

- [ ] 5. 実DBから kysely-codegen で型生成する
  - Files: `apps/api/src/db/generated.ts`, `apps/api/package.json`, `README.md`
  - Requirements: `REQ-009`, `REQ-010`
  - _Prompt:
```text
Implement the task for spec bookmark-mock-mvp, first run spec-workflow-guide to get the workflow guide then implement the task:
Role: type generation engineer
Task: migration 適用済み DB を参照して kysely-codegen による型生成フローを作成し、生成物と実行手順を整備する。
Restrictions: 手書き型と生成型を重複させない。生成手順を属人化しない。
_Leverage: apps/api/package.json, apps/api/db/migrations, README.md
_Requirements: REQ-009, REQ-010
Success: `generated.ts` が生成され、再生成手順を実行可能な形で残せる。
Instructions: 作業開始時に tasks.md の当該タスクを `[-]` に変更する。完了後に log-implementation を実行して実装内容を記録し、その後 `[x]` に更新する。
```
