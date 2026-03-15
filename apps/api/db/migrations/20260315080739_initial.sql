-- Create "users" table
CREATE TABLE "users" (
  "id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "handle_name" character varying(255) NOT NULL,
  "password_hash" character varying(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id")
);
-- Create index "users_handle_name_key" to table: "users"
CREATE UNIQUE INDEX "users_handle_name_key" ON "users" ("handle_name");
-- Create "collections" table
CREATE TABLE "collections" (
  "id" integer NOT NULL GENERATED ALWAYS AS IDENTITY,
  "parent_collection_id" integer NULL,
  "collection_name" character varying(255) NOT NULL,
  "user_id" uuid NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id"),
  CONSTRAINT "collections_parent_collection_id_fkey" FOREIGN KEY ("parent_collection_id") REFERENCES "collections" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "collections_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "collection_items" table
CREATE TABLE "collection_items" (
  "id" integer NOT NULL GENERATED ALWAYS AS IDENTITY,
  "collection_id" integer NOT NULL,
  "collection_item_name" character varying(255) NOT NULL,
  "collection_item_url" text NOT NULL,
  "is_pinned" boolean NOT NULL DEFAULT false,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id"),
  CONSTRAINT "collection_items_collection_id_fkey" FOREIGN KEY ("collection_id") REFERENCES "collections" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "tags" table
CREATE TABLE "tags" (
  "id" integer NOT NULL GENERATED ALWAYS AS IDENTITY,
  "user_id" uuid NOT NULL,
  "tag_name" character varying(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id"),
  CONSTRAINT "tags_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create index "tags_user_id_tag_name_key" to table: "tags"
CREATE UNIQUE INDEX "tags_user_id_tag_name_key" ON "tags" ("user_id", "tag_name");
-- Create "collection_item_tag" table
CREATE TABLE "collection_item_tag" (
  "id" integer NOT NULL GENERATED ALWAYS AS IDENTITY,
  "tag_id" integer NOT NULL,
  "collection_item_id" integer NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id"),
  CONSTRAINT "collection_item_tag_collection_item_id_fkey" FOREIGN KEY ("collection_item_id") REFERENCES "collection_items" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "collection_item_tag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tags" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create index "collection_item_tag_collection_item_id_tag_id_key" to table: "collection_item_tag"
CREATE UNIQUE INDEX "collection_item_tag_collection_item_id_tag_id_key" ON "collection_item_tag" ("collection_item_id", "tag_id");
