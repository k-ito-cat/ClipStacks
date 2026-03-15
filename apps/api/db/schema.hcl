schema "public" {}

table "users" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "name" {
    type = varchar(255)
    null = false
  }

  column "handle_name" {
    type = varchar(255)
    null = false
  }

  column "password_hash" {
    type = varchar(255)
    null = false
  }

  column "created_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  column "updated_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  primary_key {
    columns = [column.id]
  }

  index "users_handle_name_key" {
    columns = [column.handle_name]
    unique  = true
  }
}

table "collections" {
  schema = schema.public

  column "id" {
    type = integer
    null = false
    identity {
      generated = ALWAYS
    }
  }

  column "parent_collection_id" {
    type = integer
    null = true
  }

  column "collection_name" {
    type = varchar(255)
    null = false
  }

  column "user_id" {
    type = uuid
    null = false
  }

  column "created_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  column "updated_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "collections_parent_collection_id_fkey" {
    columns     = [column.parent_collection_id]
    ref_columns = [table.collections.column.id]
    on_delete   = CASCADE
  }

  foreign_key "collections_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_delete   = CASCADE
  }
}

table "collection_items" {
  schema = schema.public

  column "id" {
    type = integer
    null = false
    identity {
      generated = ALWAYS
    }
  }

  column "collection_id" {
    type = integer
    null = false
  }

  column "collection_item_name" {
    type = varchar(255)
    null = false
  }

  column "collection_item_url" {
    type = text
    null = false
  }

  column "is_pinned" {
    type    = boolean
    null    = false
    default = false
  }

  column "created_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  column "updated_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "collection_items_collection_id_fkey" {
    columns     = [column.collection_id]
    ref_columns = [table.collections.column.id]
    on_delete   = CASCADE
  }
}

table "tags" {
  schema = schema.public

  column "id" {
    type = integer
    null = false
    identity {
      generated = ALWAYS
    }
  }

  column "user_id" {
    type = uuid
    null = false
  }

  column "tag_name" {
    type = varchar(255)
    null = false
  }

  column "created_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  column "updated_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "tags_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_delete   = CASCADE
  }

  index "tags_user_id_tag_name_key" {
    columns = [column.user_id, column.tag_name]
    unique  = true
  }
}

table "collection_item_tag" {
  schema = schema.public

  column "id" {
    type = integer
    null = false
    identity {
      generated = ALWAYS
    }
  }

  column "tag_id" {
    type = integer
    null = false
  }

  column "collection_item_id" {
    type = integer
    null = false
  }

  column "created_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  column "updated_at" {
    type    = timestamptz
    null    = false
    default = sql("CURRENT_TIMESTAMP")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "collection_item_tag_tag_id_fkey" {
    columns     = [column.tag_id]
    ref_columns = [table.tags.column.id]
    on_delete   = CASCADE
  }

  foreign_key "collection_item_tag_collection_item_id_fkey" {
    columns     = [column.collection_item_id]
    ref_columns = [table.collection_items.column.id]
    on_delete   = CASCADE
  }

  index "collection_item_tag_collection_item_id_tag_id_key" {
    columns = [column.collection_item_id, column.tag_id]
    unique  = true
  }
}
