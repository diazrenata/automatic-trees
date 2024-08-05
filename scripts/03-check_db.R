library(duckdb)
library(DBI)
library(dplyr)
source(here::here("R", "create_all_tables.R"))

# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", "foresttime-from-parquet.duckdb")

if (!file.exists(database_path)) {
  warning("Database file not found.")
}

# Connect to database
con <- dbConnect(duckdb(dbdir = database_path))

# Check that the db contains the right tables

expected_table_names <-
  c(
    'all_invyrs',
    'cond',
    'plot',
    'qa_flags',
    'sapling_transitions',
    'tree',
    'tree_annualized',
    'tree_cns',
    'tree_info_composite_id'
  )

if (!(all(dbListTables(con) == expected_table_names))) {
  warning("Table names do not match expected table names.")
}

# Check that sapling transitions sum to 1

saplings <- tbl(con, "sapling_transitions") |>
  collect()

expected_rowsums <- ifelse(saplings$PREV_live_and_skipped > 0, 1, NA)

if(!all.equal(rowSums(saplings[,7:13]), expected_rowsums)) {
  warning("Sapling proportions do not sum to 1")
}

if(!all(saplings$PREV_INVYR < saplings$INVYR)) {
  warning("Sapling years out of order")
}

warning("Here is just a warning")

# RMD needs to think of additional relevant checks. 

dbDisconnect(con, shutdown = TRUE)
