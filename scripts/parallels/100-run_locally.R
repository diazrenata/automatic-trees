do_not_upload <- TRUE

state_scripts <- list.files(here::here("scripts",
                                       "parallels"),
                            pattern = "-state-parquet.R",
                            full.names = T) 

state_scripts <- state_scripts[7:50]

lapply(state_scripts,
       source) 
