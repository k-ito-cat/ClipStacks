env "local" {
  src = "file://db/schema.hcl"
  url = getenv("DATABASE_URL")
  dev = getenv("ATLAS_DEV_DATABASE_URL")

  migration {
    dir = "file://db/migrations"
  }
}
