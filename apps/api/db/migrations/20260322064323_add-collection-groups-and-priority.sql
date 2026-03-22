-- Create enum type "priority"
CREATE TYPE "priority" AS ENUM ('high', 'medium', 'low');
-- Create "collection_groups" table
CREATE TABLE "collection_groups" (
  "id" integer NOT NULL GENERATED ALWAYS AS IDENTITY,
  "collection_id" integer NOT NULL,
  "collection_group_name" character varying(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("id"),
  CONSTRAINT "collection_groups_collection_id_fkey" FOREIGN KEY ("collection_id") REFERENCES "collections" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Modify "collection_items" table
ALTER TABLE "collection_items" ADD COLUMN "collection_group_id" integer NULL, ADD COLUMN "priority" "priority" NULL, ADD CONSTRAINT "collection_items_collection_group_id_fkey" FOREIGN KEY ("collection_group_id") REFERENCES "collection_groups" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
