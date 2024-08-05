library(boxr)
box_auth_service(token_text = Sys.getenv("BOX_TOKEN_TEXT"))
boxr::box_fetch(dir_id = "267590977321",
                local_dir = here::here("data", "parquet"))
