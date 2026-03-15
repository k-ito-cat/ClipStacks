env "local" {
  src = "file://db/schema.hcl"
  url = "postgres://postgres:postgres@db:5432/lab?search_path=public&sslmode=disable"
  dev = "postgres://postgres:postgres@db:5432/lab?search_path=public&sslmode=disable"

  migration {
    dir = "file://db/migrations"
  }
}
