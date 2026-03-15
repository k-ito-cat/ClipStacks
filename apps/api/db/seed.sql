BEGIN;

TRUNCATE TABLE
  collection_item_tag,
  collection_items,
  tags,
  collections,
  users
RESTART IDENTITY CASCADE;

INSERT INTO users (
  id,
  name,
  handle_name,
  password_hash,
  created_at,
  updated_at
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'Sample User',
  'sample-user',
  '$2b$12$exampleexampleexampleexampleexampleexampleexampleexample',
  '2026-03-15T08:00:00+09:00',
  '2026-03-15T08:00:00+09:00'
);

INSERT INTO collections (
  id,
  parent_collection_id,
  collection_name,
  user_id,
  created_at,
  updated_at
) OVERRIDING SYSTEM VALUE VALUES
  (
    1,
    NULL,
    'Sample Collection',
    '11111111-1111-1111-1111-111111111111',
    '2026-03-15T08:05:00+09:00',
    '2026-03-15T08:05:00+09:00'
  ),
  (
    2,
    1,
    'Reference Links',
    '11111111-1111-1111-1111-111111111111',
    '2026-03-15T08:06:00+09:00',
    '2026-03-15T08:06:00+09:00'
  );

INSERT INTO collection_items (
  id,
  collection_id,
  collection_item_name,
  collection_item_url,
  is_pinned,
  created_at,
  updated_at
) OVERRIDING SYSTEM VALUE VALUES
  (
    1,
    1,
    'Sample Article',
    'https://example.com/sample-article',
    true,
    '2026-03-15T08:10:00+09:00',
    '2026-03-15T08:10:00+09:00'
  ),
  (
    2,
    2,
    'Example Service',
    'https://example.com/service',
    true,
    '2026-03-15T08:11:00+09:00',
    '2026-03-15T08:11:00+09:00'
  ),
  (
    3,
    2,
    'Mock Landing Page',
    'https://example.com/mock-page',
    false,
    '2026-03-15T08:12:00+09:00',
    '2026-03-15T08:12:00+09:00'
  );

INSERT INTO tags (
  id,
  user_id,
  tag_name,
  created_at,
  updated_at
) OVERRIDING SYSTEM VALUE VALUES
  (
    1,
    '11111111-1111-1111-1111-111111111111',
    'sample',
    '2026-03-15T08:20:00+09:00',
    '2026-03-15T08:20:00+09:00'
  ),
  (
    2,
    '11111111-1111-1111-1111-111111111111',
    'demo',
    '2026-03-15T08:21:00+09:00',
    '2026-03-15T08:21:00+09:00'
  );

INSERT INTO collection_item_tag (
  id,
  tag_id,
  collection_item_id,
  created_at,
  updated_at
) OVERRIDING SYSTEM VALUE VALUES
  (
    1,
    1,
    1,
    '2026-03-15T08:30:00+09:00',
    '2026-03-15T08:30:00+09:00'
  ),
  (
    2,
    2,
    1,
    '2026-03-15T08:30:30+09:00',
    '2026-03-15T08:30:30+09:00'
  ),
  (
    3,
    1,
    2,
    '2026-03-15T08:31:00+09:00',
    '2026-03-15T08:31:00+09:00'
  ),
  (
    4,
    2,
    3,
    '2026-03-15T08:31:30+09:00',
    '2026-03-15T08:31:30+09:00'
  );

COMMIT;
