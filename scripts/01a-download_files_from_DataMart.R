# This script downloads the TREE, PLOT, and COND tables from DataMart
# and stores them as .csv files.

library(dplyr)
source(here::here("R", "download_csv_wrapper.R"))

# Create directory for raw data files ####

csv_dir <- here::here("data", "rawdat", "state")

if (!dir.exists(csv_dir)) {
  dir.create(csv_dir, recursive = T)
}

# Specify which states to download ####

# Or assign states_to_use to a few states:

states_to_use <- c("AZ", "CT")

# states_to_use <-
#   c("AL",
#     "AK",
#     "AZ",
#     "CA",
#     "CO",
#     "CT",
#     "DE",
#     "FL",
#     "GA",
#     "ID",
#     "IL",
#     "IN",
#     "IA",
#     "KS",
#     "KY",
#     "LA",
#     "MT",
#     "WY",
#     "OH",
#     "PA",
#     "MD",
#     "MA",
#     "NJ",
#     "VT",
#     "NH",
#     "RI",
#     "ME",
#     "CT",
#     "WV",
#     "NY",
#     "MI",
#     "MO",
#     "WI",
#     "MN"
#   ) |>
#   unique()

# Specify whether to overwite existing downloaded files ####
# overwrite_downloads will skip downloading existing files.
# This can speed things up.
# If you need the newest files, set overwrite_downloads to TRUE.

overwrite_downloads <- FALSE

# Download .csvs from DataMart ####

download_csv_from_datamart(states = states_to_use,
                           rawdat_dir = csv_dir,
                           overwrite = overwrite_downloads)
