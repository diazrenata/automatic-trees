library(zen4R)

zenodo <- ZenodoManager$new(
  url = "http://sandbox.zenodo.org/api",
  token = Sys.getenv("ZEN_TOKEN_TEXT"), 
  logger = "INFO"
)

my_rec <- zenodo$getDepositionByDOI(
  
  "10.5072/zenodo.51340"
  
)

myrec <- zenodo$depositRecordVersion(myrec, delete_latest_files = TRUE, files = "Test.txt", publish = FALSE)


# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", "foresttime-to-share.duckdb")
