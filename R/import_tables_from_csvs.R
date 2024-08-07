#' Import tree, plot, and condition tables from csvs
#'
#' @param con database connection
#' @param csv_dir directory with csv files
#'
#' @return nothing
#' @export
#'
#' @importFrom DBI dbSendQuery dbListTables
import_tables_from_csvs <- function(con, csv_dir) {
  
  existing_tables <- dbListTables(con)
  
  if(any(c("tree", "plot", "cond") %in% existing_tables)) {
    message("Tree, plot, and/or cond tables already present in database!")
    return()
  }
  
  tree_file <- list.files(csv_dir, pattern = "_TREE.csv", full.names = T)
  tree_columns <- readr::read_csv(tree_file, col_types = "c") |>
    select(-c(CN, PLT_CN, PREV_TRE_CN, INVYR, STATECD, UNITCD, COUNTYCD, PLOT, SUBP, TREE)) |>
    head() |>
    colnames() |>
    paste0(collapse = ", ")
  
  
  plot_file <- list.files(csv_dir, pattern = "_PLOT.csv", full.names = T)
  plot_columns <- readr::read_csv(plot_file, col_types = "c") |>
    select(-CN) |>
    head() |>
    colnames() |>
    paste0(collapse = ", ")
  
  
  cond_file <- list.files(csv_dir, pattern = "_COND.csv", full.names = T)
  cond_columns <- readr::read_csv(cond_file, col_types = "c") |>
    select(-c(CN)) |>
    head() |>
    colnames() |>
    paste0(collapse = ", ")
  
  tree_query <- paste0(
    "CREATE TABLE tree AS SELECT CN AS TREE_CN, PLT_CN, PREV_TRE_CN, INVYR, STATECD, UNITCD, COUNTYCD, PLOT, SUBP, TREE, ",
    tree_columns,
    ", CONCAT_WS('_', STATECD, UNITCD, COUNTYCD, PLOT, SUBP, TREE) AS TREE_COMPOSITE_ID, CONCAT_WS('_', STATECD, UNITCD, COUNTYCD, PLOT) AS PLOT_COMPOSITE_ID FROM '",
    csv_dir,
    "/*_TREE.csv' WHERE (INVYR >= 2000.0)"
  )
  
  plot_query <- paste0(
    "CREATE TABLE plot AS SELECT CN AS PLT_CN, ",
    plot_columns,
    ", CONCAT_WS('_', STATECD, UNITCD, COUNTYCD, PLOT) AS PLOT_COMPOSITE_ID FROM '",
    csv_dir,
    "/*_PLOT.csv' WHERE (INVYR >= 2000.0)")
  
  cond_query <- paste0(
    "CREATE TABLE cond AS SELECT CN AS COND_CN, ",
    cond_columns,
    ", CONCAT_WS('_', STATECD, UNITCD, COUNTYCD, PLOT) AS PLOT_COMPOSITE_ID FROM '",
    csv_dir,
    "/*_COND.csv' WHERE (INVYR >= 2000.0)")
  
  dbExecute(con, tree_query)
  dbExecute(con, plot_query)
  dbExecute(con, cond_query)
  
  return()
  
}
