# R/prep/prep_index.R
# KPIs and series for the Início (home) tab.

prep_index_data <- function(core_df) {
  kpis <- tibble::tibble(
    metric = c("total_casos", "assassinatos", "tentativas", "ameacas",
               "estados", "cidades", "periodo"),
    value  = c(
      nrow(core_df),
      sum(core_df$tipo_acao == "Assassinato",              na.rm = TRUE),
      sum(core_df$tipo_acao == "Tentativa de assassinato", na.rm = TRUE),
      sum(core_df$tipo_acao == "Ameaça de assassinato",    na.rm = TRUE),
      n_distinct(core_df$uf,     na.rm = TRUE),
      n_distinct(core_df$cidade, na.rm = TRUE),
      max(core_df$ano, na.rm = TRUE) - min(core_df$ano, na.rm = TRUE) + 1L
    )
  )

  annual_series <- core_df %>%
    count(ano, tipo_acao, name = "n") %>%
    arrange(ano)

  top_states <- core_df %>%
    count(uf, sort = TRUE, name = "n") %>%
    slice_head(n = 10)

  top_grupos <- core_df %>%
    count(vitima_tipo_grupo, sort = TRUE, name = "n") %>%
    slice_head(n = 8)

  list(
    kpis          = kpis,
    annual_series = annual_series,
    top_states    = top_states,
    top_grupos    = top_grupos
  )
}
