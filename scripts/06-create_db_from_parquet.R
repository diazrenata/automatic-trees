library(duckdb)
library(DBI)

# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", "foresttime-from-parquet.duckdb")

# Connect to database
con <- dbConnect(duckdb(dbdir = database_path))

tree_query <- "CREATE TABLE tree AS SELECT * FROM read_parquet(['data/parquet/tree1.parquet', 'data/parquet/tree2.parquet'])"
plot_query <- gsub("tree", "plot", tree_query)
cond_query <- gsub("tree", "cond", tree_query)
qa_flags_query <- gsub("tree", "qa_flags", tree_query)
tree_info_composite_id_query <- gsub("tree", "tree_info_composite_id", tree_query)
sapling_transitions_query <- gsub("tree", "sapling_transitions", tree_query)
tree_annualized_query <- gsub("tree", "tree_annualized", tree_query)

dbExecute(con,
          tree_query)
dbExecute(con,
          plot_query)
dbExecute(con,
          cond_query)
dbExecute(con,
          qa_flags_query)
dbExecute(con,
          tree_info_composite_id_query)
dbExecute(con,
          sapling_transitions_query)
dbExecute(con,
          tree_annualized_query)

# Clean up
dbDisconnect(con, shutdown = TRUE)