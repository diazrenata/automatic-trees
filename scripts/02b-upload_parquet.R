library(boxr)
box_auth_service(token_text = Sys.getenv("BOX_TOKEN_TEXT"))

# Specify the parquet file paths

parquet_paths <- list.files(here::here('data', 'parquet'),
                            full.names = T)

lapply(parquet_paths,
       box_ul,
       dir_id =  "267557279158",
       overwrite = TRUE)
