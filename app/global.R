# global.R (versão pública: só lê o .rds, sem BAP.csv)
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

app_data <- readRDS("data/monitor_data.rds")

# Cole aqui as funções auxiliares do global.R atual que o Monitor usa
# (ex.: fmt_n, e as funções plot_timeline_annual e plot_timeline_cumulative
# se estiverem no global.R e não em R/). Remova qualquer trecho que leia
# data/BAP.csv ou use app_data$core.