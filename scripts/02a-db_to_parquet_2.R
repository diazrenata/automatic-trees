library(duckdb)
library(DBI)
library(dplyr)

# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", "foresttime-to-share.duckdb")

# Connect to database
con <- dbConnect(duckdb(dbdir = database_path))

dbExecute(con,
"COPY tree TO 'data/parquet/tree2.parquet' (FORMAT PARQUET)")

dbExecute(con,
          "COPY plot TO 'data/parquet/plot2.parquet' (FORMAT PARQUET)")

dbExecute(con,
          "COPY cond TO 'data/parquet/cond2.parquet' (FORMAT PARQUET)")

dbExecute(con,
          "COPY qa_flags TO 'data/parquet/qa_flags2.parquet' (FORMAT PARQUET)")

dbExecute(con,
          "COPY sapling_transitions TO 'data/parquet/sapling_transitions2.parquet' (FORMAT PARQUET)")

dbExecute(con,
          "COPY tree_info_composite_id TO 'data/parquet/tree_info_composite_id2.parquet' (FORMAT PARQUET)")

dbExecute(con,
          "COPY tree_annualized TO 'data/parquet/tree_annualized2.parquet' (FORMAT PARQUET)")

dbExecute(con,
          "COPY tree_cns TO 'data/parquet/tree_cns2.parquet' (FORMAT PARQUET)")

# Clean up
dbDisconnect(con, shutdown = TRUE)