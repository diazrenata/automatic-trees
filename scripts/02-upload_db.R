library(boxr)

box_auth_service(token_text = Sys.getenv("BOX_TOKEN_TEXT"))

# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", "foresttime-to-share.duckdb")
