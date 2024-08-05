library(boxr)
box_auth_service(token_text = Sys.getenv("BOX_TOKEN_TEXT"))

# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", "foresttime-from-state-parquet.duckdb")

box_ul(dir_id = "261941293561",
       file = database_path)
