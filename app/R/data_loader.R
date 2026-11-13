# R/data_loader.R
# Loads the BAP dataset.
# Priority: pre-geocoded .rds (fast, has lat/lon) > raw CSV (needs geocoding).
# Set data_source = "local_rds" for the geocoded version (recommended for map).
# Set data_source = "local_csv" to reload from raw file (then re-run geocoding).

load_opab_raw <- function(
  source = c("local_rds", "local_csv", "github"),
  rds_path    = "data/bap_geocoded.rds",
  local_path  = "data/BAP.csv",
  github_url  = "https://raw.githubusercontent.com/ClarissaLimaPaulo/OPAB-cebrap/main/data/BAP%20-%20BAP.csv"
) {
  source <- match.arg(source)

  if (source == "local_rds") {
    if (!file.exists(rds_path)) {
      stop(
        "Geocoded file not found at '", rds_path, "'.\n",
        "Run: source('R/geocode_bap.R'); add_coordinates(core_df) ",
        "after loading raw data."
      )
    }
    message("Loading pre-geocoded dataset from ", rds_path)
    return(readRDS(rds_path))
  }

  if (source == "local_csv") {
    message("Loading raw CSV from ", local_path)
    return(readr::read_csv(local_path, show_col_types = FALSE))
  }

  # github: raw CSV, no lat/lon
  message("Loading raw CSV from GitHub (no lat/lon — map will be limited)")
  readr::read_csv(github_url, show_col_types = FALSE)
}
