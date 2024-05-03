library(boxr)
box_auth_service(token_text = Sys.getenv("BOX_TOKEN_TEXT"))


box_dir_create("automatic-fia-tables")
box_collab_create(dir_id = "261941293561",
                  user_id = "RENATASID",
                  role = "co-owner")
