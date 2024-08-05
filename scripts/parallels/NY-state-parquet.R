state_to_use = "NM"

library(duckdb)
library(DBI)
library(dplyr)
source(here::here("R", "download_csv_wrapper.R"))
source(here::here("R", "create_all_tables.R"))

if(!dir.exists(here::here("data", "db"))) {
  dir.create(here::here("data", "db"), recursive = T)
}


# Download data ####

csv_dir <- here::here("data", "rawdat", "state")

if (!dir.exists(csv_dir)) {
  dir.create(csv_dir, recursive = T)
}

download_csv_from_datamart(states = state_to_use,
                           rawdat_dir = csv_dir,
                           overwrite = FALSE)

# Create database  ####

# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", paste0("foresttime-", state_to_use, ".duckdb"))

if (file.exists(database_path)) {
  file.remove(database_path)
}

# Connect to database
con <- dbConnect(duckdb(dbdir = database_path))

# Create database tables
create_all_tables(con, rawdat_dir = csv_dir, delete_downloads = T)

# Store parquets #### 

tree_parquet_query <- paste0("COPY tree TO 'data/parquet/tree", state_to_use, ".parquet' (FORMAT PARQUET)")
plot_parquet_query <- gsub("tree", "plot", tree_parquet_query)
cond_parquet_query <- gsub("tree", "cond", tree_parquet_query)
qa_flags_parquet_query <- gsub("tree", "qa_flags", tree_parquet_query)
tree_info_composite_id_parquet_query <- gsub("tree", "tree_info_composite_id", tree_parquet_query)
sapling_transitions_parquet_query <- gsub("tree", "sapling_transitions", tree_parquet_query)
tree_annualized_parquet_query <- gsub("tree", "tree_annualized", tree_parquet_query)
tree_cns_parquet_query <- gsub("tree", "tree_cns", tree_parquet_query)
all_invyrs_parquet_query <- gsub("tree", "all_invyrs", tree_parquet_query)

dbExecute(con,
          tree_parquet_query)
dbExecute(con,
          plot_parquet_query)
dbExecute(con,
          cond_parquet_query)
dbExecute(con,
          qa_flags_parquet_query)
dbExecute(con,
          tree_info_composite_id_parquet_query)
dbExecute(con,
          sapling_transitions_parquet_query)
dbExecute(con,
          tree_annualized_parquet_query)
dbExecute(con,
          tree_cns_parquet_query)
dbExecute(con,
          all_invyrs_parquet_query)

dbDisconnect(con, shutdown = TRUE)

# Upload parquets #### 

library(boxr)
box_auth_service(token_text = Sys.getenv("BOX_TOKEN_TEXT"))

# Specify the parquet file paths

parquet_paths <- list.files(here::here('data', 'parquet'),
                            full.names = T)

lapply(parquet_paths,
       box_ul,
       dir_id =  "267590977321")

