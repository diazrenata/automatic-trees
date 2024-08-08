do_not_upload <- TRUE

state_scripts <- list.files(here::here("scripts",
                                       "parallels"),
                            pattern = "-state-parquet.R",
                            full.names = T) 

state_scripts <- state_scripts[2:51]

for(i in c(17, 25, 30, 34)) {
  source(state_scripts[i])
}

done_states <- list.files(here::here("data", "db"), full.names =F)

done_states <- gsub("foresttime-", "", x = done_states)
done_states <- gsub(".duckdb", "", done_states)

all_states <- gsub("C:/Users/renatadiaz/OneDrive - University of Arizona/Documents/GitHub/FIA/automatic-trees/scripts/parallels/", 
                   "",
                   state_scripts)

all_states <- gsub("-state-parquet.R", "", all_states)

which(all_states %in% setdiff(all_states, done_states))
