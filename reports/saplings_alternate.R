library(duckdb)
library(DBI)
library(dplyr)

# Specify the path to .duckdb file for database
database_path <-
  here::here("data", "db", "foresttime-from-state-parquet.duckdb")

if (!file.exists(database_path)) {
  warning("Database file not found.")
}

# Connect to database
con <- dbConnect(duckdb(dbdir = database_path))

one_state <- tbl(con, "tree") |>
  filter(STATECD == 1) |>
  collect()

saplings_ever <- one_state |>
  filter(DIA < 5) |>
  select(TREE_COMPOSITE_ID, PLOT) |>
  distinct() 

one_state_saplings <- saplings_ever |>
  left_join(one_state) |>
  select(TREE_COMPOSITE_ID, PLOT, CYCLE, INVYR, STATUSCD, DIA, HT, ACTUALHT) |>
  group_by(TREE_COMPOSITE_ID) |>
  mutate(FIRST_INVYR = min(INVYR)) |>
  ungroup()

plot_cycles <- one_state |>
  select(PLOT, CYCLE, INVYR) |>
  distinct()

one_state_saplings_all_cycle_years <- inner_join(saplings_ever, plot_cycles) |>
  left_join(one_state_saplings) |>
  filter(INVYR >= FIRST_INVYR) 

one_state_saplings_wide <- one_state_saplings_all_cycle_years |>
  select(TREE_COMPOSITE_ID, PLOT, CYCLE, STATUSCD, DIA, HT, ACTUALHT) |>
  tidyr::pivot_wider(id_cols = c(TREE_COMPOSITE_ID, PLOT), names_from = CYCLE, values_from = c(STATUSCD, DIA, HT, ACTUALHT)) 

one_state_statuses <- one_state_saplings_all_cycle_years |>
  group_by(PLOT, CYCLE, STATUSCD) |>
  tally() |>
  tidyr::pivot_wider(id_cols = c(PLOT, CYCLE), names_from = STATUSCD, values_from = n, values_fill = 0)
