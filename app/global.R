# global.R ---------------------------------------------------------------

library(shiny)
library(bslib)
library(htmltools)
library(dplyr)
library(tidyr)
library(stringr)
library(stringi)
library(lubridate)
library(readr)
library(janitor)
library(purrr)
library(tibble)
library(plotly)
library(DT)
library(scales)

source("R/app_theme.R")
source("R/app_utils.R")
source("R/data_loader.R")
# NOTE: data_dictionary.R removed — it conflicts with build_app_data() below
# NOTE: geocode_bap.R is a local-only tool — never source it here
source("R/prep/prep_core.R")
source("R/prep/prep_index.R")
source("R/prep/prep_map.R")
source("R/prep/prep_timeline.R")
source("R/prep/prep_analysis.R")
source("R/plots/plot_index.R")
source("R/plots/plot_map.R")
source("R/plots/plot_timeline.R")
source("R/plots/plot_analysis.R")

# ---- Build app data ---------------------------------------------------------
build_app_data <- function() {
  raw_df <- tryCatch(
    load_opab_raw(source = "local_rds"),
    error = function(e) {
      message("RDS not found — loading raw CSV (map will have no coordinates).")
      load_opab_raw(source = "local_csv")
    }
  )

  core_df <- if ("lat" %in% names(raw_df)) raw_df else prep_core_data(raw_df)

  list(
    core     = core_df,
    index    = prep_index_data(core_df),
    map      = prep_map_data(core_df),
    timeline = prep_timeline_data(core_df),
    analysis = prep_analysis_data(core_df)
  )
}

app_data <- build_app_data()
