# R/prep/prep_timeline.R
# Prepares data for the Linha do Tempo tab.
# Includes a presidential term lookup matching the 2003-2023 dataset range.

prep_timeline_data <- function(core_df) {
  vc <- vela_colors()

  # Cores de fundo por mandato — alternando vinho / dourado / cinza-escuro
  # apenas para diferenciar visualmente mandatos adjacentes (é uma faixa
  # de fundo com opacidade baixa, não precisa de uma cor única por mandato).
  term_lookup <- tibble::tribble(
    ~term_id,    ~label,        ~start_year, ~end_year, ~cor,
    "lula1",     "Lula I",      2003,        2006,      vc$vinho,
    "lula2",     "Lula II",     2007,        2010,      vc$dourado,
    "dilma1",    "Dilma I",     2011,        2014,      vc$vinho,
    "dilma2",    "Dilma II",    2015,        2016,      vc$dourado,
    "temer",     "Temer",       2016,        2018,      vc$cinza_esc,
    "bolsonaro", "Bolsonaro",   2019,        2022,      vc$vinho,
    "lula3",     "Lula III",    2023,        2023,      vc$dourado
  )

  # Monthly series for sparkline / line chart
  monthly_series <- core_df %>%
    filter(!is.na(mes)) %>%
    count(ano, mes, tipo_acao, name = "n") %>%
    mutate(data = make_date(ano, mes, 1L)) %>%
    arrange(data)

  # Annual series with cumulative total
  annual_series <- core_df %>%
    count(ano, name = "n") %>%
    arrange(ano) %>%
    mutate(cum_n = cumsum(n))

  # Breakdown by action type per year
  annual_by_tipo <- core_df %>%
    count(ano, tipo_acao, name = "n") %>%
    arrange(ano)

  list(
    term_lookup     = term_lookup,
    monthly_series  = monthly_series,
    annual_series   = annual_series,
    annual_by_tipo  = annual_by_tipo,
    events          = core_df
  )
}
